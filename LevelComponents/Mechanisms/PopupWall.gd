extends Mechanism

class_name PopupWall

export(NodePath) var np_open_sprite
export(NodePath) var np_close_sprite
export(NodePath) var np_static_body_shape

onready var open_sprite = get_node(np_open_sprite) as Sprite
onready var close_sprite = get_node(np_close_sprite) as Sprite
onready var static_body_shape = get_node(np_static_body_shape) as CollisionShape2D

func ready():
	close()

func close():
	close_sprite.visible = true
	open_sprite.visible = false
	static_body_shape.set_deferred("disabled", false)

func open():
	static_body_shape.set_deferred("disabled", true)
	close_sprite.visible = false
	open_sprite.visible = true
