extends Mechanism

export(Vector2) var shot_direction

export(bool) var hurt_mobs

func open():
	Game.spawn_arrow(global_position, shot_direction, hurt_mobs)
