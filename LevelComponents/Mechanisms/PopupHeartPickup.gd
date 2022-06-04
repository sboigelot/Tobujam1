extends Mechanism

export(Vector2) var shot_direction

func open():
	Game.spawn_heart_pickup(global_position, true)
