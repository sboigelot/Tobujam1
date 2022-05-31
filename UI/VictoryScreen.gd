extends Control

export(NodePath) var np_victory_label

onready var victory_label = get_node(np_victory_label) as Label

func _ready():
	update_ui(Game.win, Game.score, Game.time)

func update_ui(win:bool, score:int, time:float):
	victory_label.text = "Victory" if win else "Haha! U dieded!"

func _on_BackToMenuButton_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")
