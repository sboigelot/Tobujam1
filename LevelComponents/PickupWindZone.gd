extends Area2D

export(Vector2) var wind_speed
	
func _physics_process(delta):
	var level = Game.current_level as Level
	for pickup in level.orb_pickup_placeholder.get_children():
		if overlaps_area(pickup):
			var node2d = pickup as Node2D
			node2d.global_position += (wind_speed * delta)

