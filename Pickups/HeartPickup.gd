extends Pickup

class_name HeartPickup

func picked_by(player):
	player.data.health = min(player.data.health+1, player.data.max_health)
	player.emit_signal("took_damage", player)
	queue_free()
