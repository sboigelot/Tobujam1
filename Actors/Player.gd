extends Actor

class_name Player

var orb_pickup_nearby

var direction = Vector2()

export(NodePath) var np_hammer_animation_player
onready var hammer_animation_player = get_node(np_hammer_animation_player) as AnimationPlayer

export(NodePath) var np_move_animation_player
onready var move_animation_player = get_node(np_move_animation_player) as AnimationPlayer

export(NodePath) var np_hands
export(NodePath) var np_hammer_hinge
export(NodePath) var np_hammer_area
export(NodePath) var np_orb_hinge

onready var hands = get_node(np_hands)
onready var hammer_hinge = get_node(np_hammer_hinge) as Node2D
onready var hammer_area = get_node(np_hammer_area) as Area2D
onready var orb_hinge = get_node(np_orb_hinge) as Node2D

export(NodePath) var np_orb_sprite
onready var orb_sprite = get_node(np_orb_sprite) as Sprite

export(NodePath) var np_hands_location_top_left
export(NodePath) var np_hands_location_top_center
export(NodePath) var np_hands_location_top_right
export(NodePath) var np_hands_location_center_left
export(NodePath) var np_hands_location_center_right
export(NodePath) var np_hands_location_bottom_left
export(NodePath) var np_hands_location_bottom_center
export(NodePath) var np_hands_location_bottom_right

class hinge_info:
	var position:Vector2
	var flip_x: bool
	var rotation: int
	
	func _init(_position:Vector2, _flip_x: bool, _rotation:int):
		position = _position
		flip_x = _flip_x
		rotation = _rotation

onready var hands_info_per_direction = {
	Vector2(-1,-1): hinge_info.new(
						get_node(np_hands_location_top_left).position,
						false,
						0
					),
	Vector2(0,-1): 	hinge_info.new(
						get_node(np_hands_location_top_center).position,
						false,
						90
					),
	Vector2(+1,-1): hinge_info.new(
						get_node(np_hands_location_top_right).position,
						true,
						0
					),
	Vector2(-1,0): 	hinge_info.new(
						get_node(np_hands_location_center_left).position,
						false,
						0
					),
	Vector2(+1,0): 	hinge_info.new(
						get_node(np_hands_location_center_right).position,
						true,
						0
					),
	Vector2(-1,+1): hinge_info.new(
						get_node(np_hands_location_bottom_left).position,
						false,
						0
					),
	Vector2(0,+1): 	hinge_info.new(
						get_node(np_hands_location_bottom_center).position,
						false,
						-90
					),
	Vector2(+1,+1): hinge_info.new(
						get_node(np_hands_location_bottom_right).position,
						true,
						0
					),
}

func _ready():
	speed = Game.player_walk_speed

func change_hands_tool():
	hammer_hinge.visible = not carry_orb
	orb_hinge.visible = carry_orb

func _physics_process(delta):
	change_hands_tool()
	
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	elif Input.is_action_pressed("ui_right"):
		direction.x = 1
	else:
		direction.x = 0

	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y =  1
	else:
		direction.y = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		if carry_orb:
			throw_orb()
		else:
			start_slash()
	
	if (not carry_orb and
		orb_pickup_nearby and
		Input.is_action_just_pressed("pickup")):
			pickup_orb()
	
	if hands_info_per_direction.has(direction):
		var info = hands_info_per_direction[direction] as hinge_info
		hands.position = info.position
		if info.flip_x:
			hands.scale = Vector2(-1,1)
		else:
			hands.scale = Vector2(1,1)
		hands.rotation_degrees = info.rotation
	
	if direction != Vector2() and not move_animation_player.is_playing():
		move_animation_player.play("Walk")
	
	move(direction)

func start_slash():
	if hammer_animation_player.is_playing():
		return
		
	hammer_animation_player.play("Slash")

func pickup_orb():
	orb_pickup_nearby.queue_free()
	orb_color = orb_pickup_nearby.orb_color
	orb_sprite.modulate = orb_color
	orb_pickup_nearby = null
	carry_orb = true

func throw_orb():
	carry_orb = false
	var direction = global_position.direction_to(hands.global_position).normalized()
	var throw_velocity = direction * Game.orb_throw_speed
	Game.spawn_orb(orb_color, hands.global_position, throw_velocity)

func _on_HammerArea2D_body_entered(body:Node2D):
	if body == self:
		return
		
	if body.is_in_group("mob"):
		body.take_damage(Game.damage_hammer)
		return

func enable_hammer_damage():
	hammer_area.monitoring = true
	
func disable_hammer_damage():
	hammer_area.monitoring = false

func _on_PickupArea2D_area_entered(area:Area2D):
	if area == self:
		return
		
	if area.is_in_group("orb_pickup"):
		orb_pickup_nearby = area
		return
		
	if area.is_in_group("heart_pickup"):
		pickup_heart(area)
		return
		
	if area.is_in_group("moving_orb_pickup"):
		orb_pickup_nearby = area.get_parent()
		return

func _on_PickupArea2D_area_exited(area):
	if area == orb_pickup_nearby or area.get_parent() == orb_pickup_nearby:
		orb_pickup_nearby = null

func pickup_heart(heart_pickup):
	heart_pickup.queue_free()
	health = min(health+1, max_health)
	emit_signal("took_damage", self)
