extends Mechanism

func open():
	Game.spawn_heart_pickup(global_position, true)
