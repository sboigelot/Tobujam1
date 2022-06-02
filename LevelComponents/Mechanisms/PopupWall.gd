extends Mechanism

class_name PopupWall

export(NodePath) var np_open_sprite
export(NodePath) var np_close_sprite
export(NodePath) var np_static_body_shape

onready var open_sprite = get_node(np_open_sprite) as Sprite
onready var close_sprite = get_node(np_close_sprite) as Sprite
onready var static_body_shape = get_node(np_static_body_shape) as CollisionShape2D

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
	
	close_sprite.visible = not opened
	open_sprite.visible = opened
	static_body_shape.set_deferred("disabled", opened)

