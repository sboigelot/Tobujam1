extends KinematicBody2D

class_name Arrow

export(Vector2) var velocity
export(bool) var hurt_mobs

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	rotation = velocity.angle()
	
	var collision = move_and_collide(velocity, true) as KinematicCollision2D
	if collision == null:
		return
		
	var body = collision.collider
	if body.is_in_group("player"):
		body.take_damage(Game.damage_arrow)
		
	if hurt_mobs and body.is_in_group("mob"):
		body.take_damage(Game.damage_arrow)
	
	queue_free()
