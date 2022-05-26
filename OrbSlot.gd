extends Node2D


export(Color) var accepted_color
export(Color) var orb_color

export(NodePath) var np_orb_sprite
onready var orb_sprite = get_node(np_orb_sprite) as Sprite

func _on_Area2D_body_entered(body):
	if body.is_in_group("orb"):
		if  body.orb_color == accepted_color:
			accept_orb(body)
		else:
			reject_orb(body)

func accept_orb(orb:Orb):
	orb_sprite.visible = true
	orb_color = orb.orb_color
	orb_sprite.modulate = orb_color
	orb.queue_free()
	
func reject_orb(orb:Orb):
	orb_sprite.visible = true
	orb_color = orb.orb_color
	orb_sprite.modulate = orb_color
	orb.visible = false	
	orb.set_physics_process(false)
	orb.set_process(false)
	yield(get_tree().create_timer(2.0), "timeout")
	
	orb_sprite.visible = false
	orb.visible = true	
	orb.set_physics_process(true)
	orb.set_process(true)
	orb.apply_central_impulse(Vector2(0, -40))
	
