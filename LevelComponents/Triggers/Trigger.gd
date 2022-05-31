extends Node2D

class_name Trigger

signal activated
signal deactivated

export var trigger_group: String
export var resolved:bool
export var on_time_activation: bool

func resolve():
	if resolved:
		return
	
	resolved = true
	on_resolved()
	emit_signal("activated", self)
	
func on_resolved():
	pass
	
func revert():
	if not resolved:
		return
	
	if on_time_activation:
		return	
	
	resolved = false
	on_reverted()
	emit_signal("deactivated", self)

func on_reverted():
	pass 
