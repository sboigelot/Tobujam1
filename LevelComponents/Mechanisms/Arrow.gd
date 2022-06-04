extends KinematicBody2D

class_name Arrow

export(Vector2) var velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var collision = move_and_collide(velocity, true) as KinematicCollision2D
	if collision == null:
		return
		
	var body = collision.collider
	if body.is_in_group("player"):
		body.take_damage(Game.damage_arrow)
		queue_free()
		
	if body.is_in_group("mob"):
		body.take_damage(Game.damage_arrow)
		queue_free()
