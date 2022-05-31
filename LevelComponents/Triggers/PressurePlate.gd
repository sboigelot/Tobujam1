extends Trigger

export(NodePath) var np_normal_sprite
export(NodePath) var np_pressed_sprite

onready var normal_sprite = get_node(np_normal_sprite) as Sprite
onready var pressed_sprite = get_node(np_pressed_sprite) as Sprite

var players_on_plate : Array

func _ready():
	on_reverted()
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		players_on_plate.append(body)
		resolve()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		if players_on_plate.has(body):
			players_on_plate.erase(body)
		if players_on_plate.size() == 0:
			revert()

func on_resolved():
	normal_sprite.visible = false
	pressed_sprite.visible = true

func on_reverted():
	normal_sprite.visible = true
	pressed_sprite.visible = false
