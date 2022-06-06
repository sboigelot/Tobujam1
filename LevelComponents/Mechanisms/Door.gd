extends Mechanism

class_name Door

export(NodePath) var np_close_sprite
export(NodePath) var np_lights_sprite
export(NodePath) var np_static_body_shape

onready var close_sprite = get_node(np_close_sprite) as Sprite
onready var lights_sprite = get_node(np_lights_sprite) as Sprite
onready var static_body_shape = get_node(np_static_body_shape) as CollisionShape2D

func ready():
	lights_sprite.visible = false
	close()

func close():
	close_sprite.visible = true
	lights_sprite.visible = false
	static_body_shape.set_deferred("disabled", false)

func open():
	static_body_shape.set_deferred("disabled", true)
	close_sprite.visible = false

func _on_WinZoneArea2D_body_entered(body):
	if body.is_in_group("player"):
		Game.on_level_completed()
		
func blink_lights():
	lights_sprite.visible = true
	yield(get_tree().create_timer(1),"timeout")
	lights_sprite.visible = false
	
