extends Area2D

export(Color) var orb_color

export(NodePath) var np_orb_sprite
onready var orb_sprite = get_node(np_orb_sprite) as Sprite

func _ready():		
	orb_sprite.modulate = orb_color
