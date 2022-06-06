extends Control

export(NodePath) var np_victory_label
onready var victory_label = get_node(np_victory_label) as Label

export(NodePath) var np_retry_button
onready var retry_button = get_node(np_retry_button) as Button

func _ready():
	update_ui(Game.win, Game.score, Game.time)
	DrumsMobManager.open_menu()

func update_ui(win:bool, score:int, time:float):
	victory_label.text = "Victory" if win else "Haha! U dieded!"
	retry_button.visible = not win

func _on_BackToMenuButton_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")

func _on_RetryButton_pressed():
	Game.retry_level()
