extends Pickup

class_name MaxStaminaPickup

export var bonus_max_stamina:int = 1

func picked_by(player):
	player.data.max_stamina += bonus_max_stamina
	queue_free()
