extends RigidBody2D

class_name Orb

const VELOCITY_STOP_THRESHOLD = 25

export(PackedScene) var orb_pickup_scene

var orb_pickup_placeholder: Node2D

export(Color) var orb_color

export(NodePath) var np_orb_sprite
onready var orb_sprite = get_node(np_orb_sprite) as Sprite

func _ready():		
	orb_sprite.modulate = orb_color

func _physics_process(delta):
	if linear_velocity.length() < VELOCITY_STOP_THRESHOLD:
		turn_back_to_pickup()
		
func turn_back_to_pickup():
	queue_free()
	var instance = orb_pickup_scene.instance() as Node2D
	instance.orb_color = orb_color
	orb_pickup_placeholder.add_child(instance)
	instance.global_position = global_position
