extends MarginContainer

var full setget set_full

func set_full(value):
	full = value
	$EmptyTexture.visible = not full
	$FullTexture.visible = full
