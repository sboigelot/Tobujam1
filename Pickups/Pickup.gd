extends Area2D

class_name Pickup

export(bool) var persistant = false
export(float) var lifespan = 30

var blink_opacity_warning = [
	10, 5, 2
]

func _process(delta):
	if not persistant:
		lifespan -= delta
		
		if lifespan <= 0:
			despawn()
			
		if blink_opacity_warning.size() > 0:
			var next_warning_time = blink_opacity_warning[0]
			if lifespan < next_warning_time:
				blink_opacity_warning.remove(0)
				blink_opacity(0.3, 5, 0.1)
	
func despawn():
	queue_free()
	
func blink_opacity(value:float, times:int, duration:float):
	for i in times:
		modulate = Color(1,1,1,value)
		yield(get_tree().create_timer(duration), "timeout")
		modulate = Color.white
		yield(get_tree().create_timer(duration), "timeout")

