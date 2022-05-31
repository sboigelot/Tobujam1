extends Node2D

class_name Trigger

signal activated

export var trigger_group: String
export var resolved:bool

func resolve():
	if resolved:
		return
		
	resolved = true
	emit_signal("activated", self)
	
func revert():
	if not resolved:
		return
		
	resolved = false
	emit_signal("activated", self)
