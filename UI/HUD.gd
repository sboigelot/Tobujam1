extends CanvasLayer

class_name HUD

export(NodePath) var np_player_1
export(NodePath) var np_player_2
export(NodePath) var np_level_label
export(NodePath) var np_time_label

onready var player_1 = get_node(np_player_1) as PlayerHUD
onready var player_2 = get_node(np_player_2) as PlayerHUD
onready var level_label = get_node(np_level_label) as Label
onready var time_label = get_node(np_time_label) as Label

func _ready():
	player_1.visible = false
	player_2.visible = false

func _process(delta):
	if Game.current_level == null:
		return
		
	if Game.current_level.tutorial:
		level_label.text = "Turorial %d" % Game.current_tutorial_level_count
	elif Game.current_level.bonus_level:
		level_label.text = "Bonus Room %d" % Game.current_bonus_level_count
	else:
		level_label.text = "Level %d" % Game.current_level_count
	
	var seconds = floor(Game.time)
	var minutes = floor(seconds / 60)
	seconds -= minutes * 60
	var miliseconds = round((Game.time - seconds)*10)
	time_label.text = "Time %02d:%02d:%02d" % [
		minutes,
		seconds,
		miliseconds
	] 
	
func setup_player(player, player_id):
	
	var player_hud = player_1
	if player_id != 0:
		player_hud = player_2
	
	player_hud.setup_player(player, player_id)
