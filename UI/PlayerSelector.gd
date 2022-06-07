extends PanelContainer

signal joined

enum LAYOUT { NONE, AZERTY, QWERTY, GP0, GP1 }

var selected_layout = LAYOUT.NONE

export(NodePath) var np_player_label
export(NodePath) var np_info_label
export(NodePath) var np_box_azerty
export(NodePath) var np_box_qwerty
export(NodePath) var np_box_gp0
export(NodePath) var np_box_gp1
export(NodePath) var np_hslider_volume_master
export(NodePath) var np_hslider_volume_music
export(NodePath) var np_hslider_volume_sfx

export var listening:bool = false
export var forbidden_layouts: Array
export var player_id: int

onready var player_label = get_node(np_player_label) as Label
onready var info_label = get_node(np_info_label) as Label
onready var hslider_volume_master = get_node(np_hslider_volume_master) as HSlider
onready var hslider_volume_music = get_node(np_hslider_volume_music) as HSlider
onready var hslider_volume_sfx = get_node(np_hslider_volume_sfx) as HSlider

onready var layout_boxes = {
	LAYOUT.AZERTY : get_node(np_box_azerty),
	LAYOUT.QWERTY : get_node(np_box_qwerty),
	LAYOUT.GP0 : get_node(np_box_gp0),
	LAYOUT.GP1 : get_node(np_box_gp1),
}

var conflicting_layouts = {
	LAYOUT.AZERTY : [LAYOUT.AZERTY, LAYOUT.QWERTY],
	LAYOUT.QWERTY : [LAYOUT.AZERTY, LAYOUT.QWERTY],
	LAYOUT.GP0 : [LAYOUT.GP0],
	LAYOUT.GP1 : [LAYOUT.GP1],
}

var layout_inputs = {
	LAYOUT.AZERTY : "azerty_move_left",
	LAYOUT.QWERTY : "qwerty_move_left",
	LAYOUT.GP0 : "gp0_attack",
	LAYOUT.GP1 : "gp1_attack",	
}

var layout_input_prefixes = {
	LAYOUT.AZERTY : "azerty",
	LAYOUT.QWERTY : "qwerty",
	LAYOUT.GP0 : "gp0",
	LAYOUT.GP1 : "gp1",	
}

func _ready():
	update_ui()
	
func update_ui():
	player_label.text = "Player %d" % player_id
	
	if not listening:
		if selected_layout == LAYOUT.NONE:
			info_label.text = "Wait for Player 1"
		else:
			info_label.text = "Joined"
	else:
		info_label.text = "Press key to join"
		if player_id != 1:
			info_label.text += " (optional)"
	
	for layout in layout_boxes:
		var box = layout_boxes[layout]
		box.visible = (not forbidden_layouts.has(layout) and
						(listening and selected_layout == LAYOUT.NONE) or
						layout == selected_layout)

func _process(delta):
	if not listening:
		return
	
	if selected_layout != LAYOUT.NONE:
		return
		
	for layout in layout_inputs:
		var input_name = layout_inputs[layout]
		if forbidden_layouts.has(layout):
			continue
		if Input.is_action_just_pressed(input_name):
			selected_layout = layout
			listening = false
			yield(get_tree().create_timer(0.1),"timeout")
			emit_signal("joined")
			update_ui()
	
		
	
