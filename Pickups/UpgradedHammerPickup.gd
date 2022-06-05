extends Pickup

class_name UpgradedHammerPickup

func picked_by(player):
	player.upgrade_hammer()
	queue_free()
