extends Control

export(NodePath) var np_victory_label
onready var victory_label = get_node(np_victory_label) as Label

export(NodePath) var np_retry_button
onready var retry_button = get_node(np_retry_button) as Button


export(NodePath) var np_level_label
onready var level_label = get_node(np_level_label) as Label

export(NodePath) var np_time_label
onready var time_label = get_node(np_time_label) as Label

func _ready():
	update_ui(Game.win, Game.score, Game.time)
	DrumsMobManager.open_menu()

func update_ui(win:bool, score:int, time:float):
	victory_label.text = "Victory" if win else "Haha! U dieded!"
	retry_button.visible = not win
	
	if Game.tutorial:
		level_label.text = "Last Level: Turorial %d" % Game.current_tutorial_level_count
	elif Game.bonus:
		level_label.text = "Last Level: Bonus Room %d" % Game.current_bonus_level_count
	else:
		level_label.text = "Last Level: Level %d" % Game.current_level_count
	
	var seconds = floor(Game.time)
	var minutes = floor(seconds / 60)
	seconds -= minutes * 60
	var miliseconds = round((Game.time - seconds)*10)
	time_label.text = "Time: %02d:%02d:%02d" % [
		minutes,
		seconds,
		miliseconds
	] 

func _on_BackToMenuButton_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")

func _on_RetryButton_pressed():
	Game.retry_level()
