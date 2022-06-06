extends Node2D

class_name InputDisplay

export var input_prefix = "none"
export var input = "attack"

var input_listen = "" 
var actions: Array

export(Array, Resource) var visuals

var visual_per_input: Dictionary

func _ready():
	
	actions = InputMap.get_actions()
	
	for o in visuals:
		var visual = o as InputVisual
		visual_per_input[visual.input] = visual
	
	input_listen = "%s_%s" % [input_prefix, input]
	update_ui()

func setup_for_player(player_data):
	input_prefix = player_data.input_prefix
	input_listen = "%s_%s" % [input_prefix, input]
	update_ui()

func _process(delta):
	
	if input_listen == "":
		return
	
	if not actions.has(input_listen):
		print("input_listen not found: %s" % input_listen)
		input_listen = ""
		return
		
	if Input.is_action_just_pressed(input_listen):
		modulate = Color.red
	if Input.is_action_just_released(input_listen):
		modulate = Color.white

func update_ui():
	if input_prefix.begins_with("gp"):
		input_prefix = "gp"
	
	var full_input = "%s_%s" % [input_prefix, input]
	if not visual_per_input.has(full_input):
		full_input = "*_%s" % input
		if not visual_per_input.has(full_input):
			visible = false
			return
	
	var visual = visual_per_input[full_input] as InputVisual
	$ButtonSprite.texture = visual.texture
	$Label.text = visual.label
	visible = true
