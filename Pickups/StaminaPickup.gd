extends Pickup

class_name StaminaPickup

func picked_by(player):
	player.data.stamina = player.data.max_stamina
	queue_free()
