extends KinematicBody2D

class_name Actor

signal took_damage
signal died

export var max_health:int = 5
export var health:int = 5
export var max_stamina:float = 2
export var stamina:float = 2
export var stamina_regen_per_second:float = 0.2
export var boost_stamina_cost_per_second:float = 1
var invincible:bool = false
export var speed: int = 50

export var carry_orb: bool
export var orb_persistant: bool
export var orb_color: Color

func _process(delta):
	regen_stamina(delta)
	
func regen_stamina(delta):
	if stamina < max_stamina:
		stamina += stamina_regen_per_second * delta
		stamina = min(stamina, max_stamina)

func boost(direction, delta):
	
	var stamina_cost = boost_stamina_cost_per_second * delta
	if stamina < stamina_cost:
		move(direction)
		return
		
	stamina -= stamina_cost
	var boost_velocity = direction * Game.player_boost_speed
	move_and_slide (boost_velocity)

func move(direction):
	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.
	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	var velocity = direction * speed
	move_and_slide(velocity)
	
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
		Game.spawn_orb_pickup(orb_color, orb_persistant, global_position)
	
	emit_signal("died",self)
	queue_free()

func blink(color:Color, time:float = 0.2):
	modulate = color
	yield(get_tree().create_timer(time), "timeout")
	modulate = Color.white
