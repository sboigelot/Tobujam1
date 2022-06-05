extends Mechanism

export(Vector2) var shot_direction
export(bool) var shot_rotate_with_trap
export(bool) var shot_rotate_with_parent

export(bool) var hurt_mobs

func open():
	var shot = shot_direction as Vector2
	if shot_rotate_with_trap:
		shot = shot.rotated(deg2rad(rotation_degrees))
	if shot_rotate_with_parent:
		shot = shot.rotated(deg2rad(get_parent().rotation_degrees))
	
	Game.spawn_arrow(global_position, shot, hurt_mobs)
