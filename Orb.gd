extends RigidBody2D

class_name Orb

const VELOCITY_STOP_THRESHOLD = 25
var stoped_delay_second = 1

export(Color) var orb_color

export(NodePath) var np_orb_sprite
onready var orb_sprite = get_node(np_orb_sprite) as Sprite

func _ready():		
	orb_sprite.modulate = orb_color

func _physics_process(delta):
	if linear_velocity.length() < VELOCITY_STOP_THRESHOLD:
		stoped_delay_second -= delta
		if stoped_delay_second <= 0:
			turn_back_to_pickup()
	else:
		stoped_delay_second = 1
		
func turn_back_to_pickup():
	Game.spawn_orb_pickup(orb_color, global_position)
	queue_free()
