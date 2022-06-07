extends Mechanism

class_name PopupWallPost

export(NodePath) var np_highligth_sprite
onready var highligth_sprite = get_node(np_highligth_sprite) as Sprite

export(Color) var highligth_modulate

export var opened: bool = false
export var flipped: bool = false

func _ready():
	change_wall_state(opened)

func open():
	change_wall_state(true)
	
func close():
	change_wall_state(false)
	
func change_wall_state(new_state):
	
	if flipped:
		opened = not new_state
	else:
		opened = new_state
	
	if opened:
		highligth_sprite.modulate = Color.black
	else:
		highligth_sprite.modulate = highligth_modulate

