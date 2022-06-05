extends Trigger

export var start_time:float = 0
export var wait_time:float = 1
export var end_time:float = 0

var ended = false

func _ready():
	if end_time != 0:
		$EndTimer.wait_time = end_time
		$EndTimer.start()
		
	if start_time != 0:
		yield(get_tree().create_timer(start_time),"timeout")
		pass
		
	$Timer.wait_time = wait_time
	$Timer.one_shot = one_time_activation
	$Timer.start()
	
		
func _on_Timer_timeout():
	if not ended:
		resolve()
		revert()
		$Timer.start()

func _on_EndTimer_timeout():
	ended = true
