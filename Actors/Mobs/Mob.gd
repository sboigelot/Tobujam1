extends Actor

class_name Mob

enum { REST, HUNT, ATTACK }

var target: Player
var player_in_range: Player
export var hunt_rest_timer:float = 3
var rest_timer: float = 0
var mode = HUNT

func _physics_process(delta):
	if data == null:
		return
		
	match(mode):
		REST:
			mode = rest(delta)
		HUNT:
			mode = hunt(delta)
			
func rest(delta):
	if rest_timer > 0:
		rest_timer -= delta
		return REST
	return HUNT
		
func hunt(delta):
	if player_in_range != null:
		attack()
		return ATTACK
		
	if target == null:
		target = Game.current_level.players[0] #todo choose player
	
	if target == null or not is_instance_valid(target):
		target = null
		rest_timer = hunt_rest_timer
		return REST
		
	var move_direction = global_position.direction_to(target.global_position)
	flip_and_animate(move_direction)
	move(move_direction)
	return HUNT
	
func attack():
	mode = ATTACK
	$AttackAnimationPlayer.play("Attack")

func attack_damage_player():
	if player_in_range == null:
		return
	
	player_in_range.take_damage(Game.damage_mob)

func stop_attack():
	$AttackAnimationPlayer.stop(true)
	scale = Vector2(1,1)
	mode = REST

func take_damage(damage):
	stop_attack()
	.take_damage(damage)

func _on_Area2D_body_entered(body):
	if body == self:
		return
		
	if body.is_in_group("player"):
		player_in_range = body
		attack()
		return
		
	if body.is_in_group("orb"):
		take_damage(Game.damage_orb)
		return

func _on_Area2D_body_exited(body):
	if body == self:
		return
		
	if body.is_in_group("player"):
		if body == player_in_range:
			player_in_range = null
			stop_attack()
		return
