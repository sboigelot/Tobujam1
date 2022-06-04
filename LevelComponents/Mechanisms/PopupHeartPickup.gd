extends Mechanism

export(Vector2) var shot_direction

func open():
	Game.spawn_arrow(global_position, shot_direction)
