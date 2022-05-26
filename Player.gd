extends KinematicBody2D

const WALK_SPEED = 200
const THROW_SPEED = 400

var carry_orb: bool
var orb_pickup_nearby
export(Color) var orb_color

var velocity = Vector2()

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

export(PackedScene) var orb_scene
export(NodePath) var np_orb_placeholder
export(NodePath) var np_orb_pickup_placeholder

onready var orb_placeholder = get_node(np_orb_placeholder) as Node2D
onready var orb_pickup_placeholder = get_node(np_orb_pickup_placeholder) as Node2D

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

onready var hands_location_per_velocity = {
	Vector2(-WALK_SPEED,-WALK_SPEED): get_node(np_hands_location_top_left).position,
	Vector2(0,-WALK_SPEED): get_node(np_hands_location_top_center).position,
	Vector2(+WALK_SPEED,-WALK_SPEED): get_node(np_hands_location_top_right).position,
	Vector2(-WALK_SPEED,0): get_node(np_hands_location_center_left).position,
	Vector2(+WALK_SPEED,0): get_node(np_hands_location_center_right).position,
	Vector2(-WALK_SPEED,+WALK_SPEED): get_node(np_hands_location_bottom_left).position,
	Vector2(0,+WALK_SPEED): get_node(np_hands_location_bottom_center).position,
	Vector2(+WALK_SPEED,+WALK_SPEED): get_node(np_hands_location_bottom_right).position,
}

func change_hands_tool():
	hammer_hinge.visible = not carry_orb
	orb_hinge.visible = carry_orb

func _physics_process(delta):
	change_hands_tool()
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0

	if Input.is_action_pressed("ui_up"):
		velocity.y = -WALK_SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y =  WALK_SPEED
	else:
		velocity.y = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		if carry_orb:
			throw_orb()
		else:
			start_slash()
	
	if (not carry_orb and
		orb_pickup_nearby and
		Input.is_action_just_pressed("pickup")):
			pickup_orb()
	
#	Math solution
#	var hammerpos = Vector2(0,0).move_toward(velocity, 50)
#	hammer.position = hammerpos
	
#	var direction = velocity.normalized()
#	print("%s %s %s" % [velocity, direction, direction.length()])
	if hands_location_per_velocity.has(velocity):
		hands.position = hands_location_per_velocity[velocity]
		
		
	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.

	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))

func start_slash():
	if animation_player.is_playing():
		return
		
	animation_player.play("Slash")

func pickup_orb():
#	print("pickup orb: %s" % orb_pickup_nearby)
	orb_pickup_nearby.queue_free()
	orb_color = orb_pickup_nearby.orb_color
	orb_sprite.modulate = orb_color
	orb_pickup_nearby = null
	carry_orb = true

func throw_orb():
	carry_orb = false
	var instance = orb_scene.instance() as Orb
	instance.orb_pickup_placeholder = orb_pickup_placeholder
	instance.orb_color = orb_color
	
	orb_placeholder.add_child(instance)
	instance.global_position = hands.global_position
	
	var direction = global_position.direction_to(hands.global_position).normalized()
	var throw_velocity = direction * THROW_SPEED
	instance.apply_central_impulse (throw_velocity)
	
#	instance.add_force(instance.global_position, throw_velocity)

func _on_HammerArea2D_body_entered(body:Node2D):
	if body == self:
		return
		
	if body.is_in_group("mob"):
		body.queue_free()
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
