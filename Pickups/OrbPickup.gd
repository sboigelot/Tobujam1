extends Pickup

class_name OrbPickup

export(Color) var orb_color

export(NodePath) var np_orb_sprite
onready var orb_sprite = get_node(np_orb_sprite) as Sprite

func _ready():		
	orb_sprite.modulate = orb_color

func despawn():
	Game.current_level.unregister_orb_color(orb_color)
	.despawn()
