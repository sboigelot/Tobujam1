extends KinematicBody2D

const WALK_SPEED = 200

var velocity = Vector2()

export(NodePath) var np_animation_player
onready var animation_player = get_node(np_animation_player) as AnimationPlayer

export(NodePath) var np_hammer
export(NodePath) var np_hammer_area

onready var hammer = get_node(np_hammer)
onready var hammer_area = get_node(np_hammer_area) as Area2D

export(NodePath) var np_hammer_location_top_left
export(NodePath) var np_hammer_location_top_center
export(NodePath) var np_hammer_location_top_right
export(NodePath) var np_hammer_location_center_left
export(NodePath) var np_hammer_location_center_right
export(NodePath) var np_hammer_location_bottom_left
export(NodePath) var np_hammer_location_bottom_center
export(NodePath) var np_hammer_location_bottom_right

onready var hammer_location_per_velocity = {
	Vector2(-WALK_SPEED,-WALK_SPEED): get_node(np_hammer_location_top_left).position,
	Vector2(0,-WALK_SPEED): get_node(np_hammer_location_top_center).position,
	Vector2(+WALK_SPEED,-WALK_SPEED): get_node(np_hammer_location_top_right).position,
	Vector2(-WALK_SPEED,0): get_node(np_hammer_location_center_left).position,
	Vector2(+WALK_SPEED,0): get_node(np_hammer_location_center_right).position,
	Vector2(-WALK_SPEED,+WALK_SPEED): get_node(np_hammer_location_bottom_left).position,
	Vector2(0,+WALK_SPEED): get_node(np_hammer_location_bottom_center).position,
	Vector2(+WALK_SPEED,+WALK_SPEED): get_node(np_hammer_location_bottom_right).position,
}

func _physics_process(delta):
	
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
		start_slash()
	
#	Math solution
#	var hammerpos = Vector2(0,0).move_toward(velocity, 50)
#	hammer.position = hammerpos
	
#	var direction = velocity.normalized()
#	print("%s %s %s" % [velocity, direction, direction.length()])
	if hammer_location_per_velocity.has(velocity):
		hammer.position = hammer_location_per_velocity[velocity]
		
		
	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.

	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))

func start_slash():
	if animation_player.is_playing():
		return
		
	animation_player.play("Slash")


func _on_HammerArea2D_body_entered(body:Node2D):
	if body == self:
		return
	if body.is_in_group("mob"):
		body.queue_free()


#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "Slash":
#		hammer_area.monitoring == false

func enable_hammer_damage():
	hammer_area.monitoring = true
	
func disable_hammer_damage():
	hammer_area.monitoring = false

#func _on_AnimationPlayer_animation_started(anim_name):
#	if anim_name == "Slash":
#		hammer_area.monitoring == true

