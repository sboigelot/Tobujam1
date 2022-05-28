extends Actor

class_name Player

var orb_pickup_nearby

var move_direction = Vector2()

export(NodePath) var np_animation_player
onready var animation_player = get_node(np_animation_player) as AnimationPlayer

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

onready var hands_location_per_move_direction = {
	Vector2(-1,-1): get_node(np_hands_location_top_left).position,
	Vector2(0,-1): 	get_node(np_hands_location_top_center).position,
	Vector2(+1,-1): get_node(np_hands_location_top_right).position,
	Vector2(-1,0): 	get_node(np_hands_location_center_left).position,
	Vector2(+1,0): 	get_node(np_hands_location_center_right).position,
	Vector2(-1,+1): get_node(np_hands_location_bottom_left).position,
	Vector2(0,+1): 	get_node(np_hands_location_bottom_center).position,
	Vector2(+1,+1): get_node(np_hands_location_bottom_right).position,
}

func _ready():
	speed = Game.player_walk_speed

func change_hands_tool():
	hammer_hinge.visible = not carry_orb
	orb_hinge.visible = carry_orb

func _physics_process(delta):
	change_hands_tool()
	
	if Input.is_action_pressed("ui_left"):
		move_direction.x = -1
	elif Input.is_action_pressed("ui_right"):
		move_direction.x = 1
	else:
		move_direction.x = 0

	if Input.is_action_pressed("ui_up"):
		move_direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		move_direction.y =  1
	else:
		move_direction.y = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		if carry_orb:
			throw_orb()
		else:
			start_slash()
	
	if (not carry_orb and
		orb_pickup_nearby and
		Input.is_action_just_pressed("pickup")):
			pickup_orb()
	
	if hands_location_per_move_direction.has(move_direction):
		hands.position = hands_location_per_move_direction[move_direction]
	
	move(move_direction)

func start_slash():
	if animation_player.is_playing():
		return
		
	animation_player.play("Slash")

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
		
	if area.is_in_group("moving_orb_pickup"):
		orb_pickup_nearby = area.get_parent()
		return

func _on_PickupArea2D_area_exited(area):
	if area == orb_pickup_nearby or area.get_parent() == orb_pickup_nearby:
		orb_pickup_nearby = null
