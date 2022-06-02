extends PopupWall

class_name SpikeTrap

export var damage:int = 1
export var knockback_force:int = 100
export var knockback_time:float = 0.3
export var close_timer:float = 3
export var hurt_mob:bool = true

func _on_SpikeArea2D_body_entered(body):
	if (body.is_in_group("player") or
		(body.is_in_group("mob") and hurt_mob)):
		body.take_damage(damage)
		body.knockback(global_position, knockback_force, knockback_time)
		open()
		yield(get_tree().create_timer(close_timer), "timeout")
		close()
