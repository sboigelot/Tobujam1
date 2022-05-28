extends KinematicBody2D

class_name Actor

signal took_damage
signal died

export var max_health:int = 5
export var health:int = 5
var invincible:bool = false
export var speed: int = 50

export var carry_orb: bool
export var orb_color: Color

func move(direction):
	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.
	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	var velocity = direction * speed
	move_and_slide(velocity, Vector2(0, 0))
	
func take_damage(damage):
	if invincible:
		return
	
	health -= damage
	if health <= 0:
		die()
	else:
		blink(Color.red)
	
	emit_signal("took_damage", self)
	invincible = true
	yield(get_tree().create_timer(0.2), "timeout")
	invincible = false
		
func die():
	speed = 0
	modulate = Color.red
	yield(get_tree().create_timer(0.2), "timeout")
	
	if carry_orb:
		Game.spawn_orb_pickup(orb_color, global_position)
	
	emit_signal("died",self)
	queue_free()

func blink(color:Color, time:float = 0.2):
	modulate = color
	yield(get_tree().create_timer(time), "timeout")
	modulate = Color.white
