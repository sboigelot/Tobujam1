extends Pickup

class_name SpeedBoostPickup

export var bonus_speed:int = 30

func picked_by(player):
	player.data.speed += bonus_speed
	queue_free()
