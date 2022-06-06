extends Node2D

export var input = "attack"

export var single_p1 = false
export var single_p2 = false

func _ready():
	update_ui()

func update_ui():
	var players = Game.player_datas 
	$InputDisplay.visible = false
	if not single_p2 and players.size() > 0:
		update_input($InputDisplay, players[0])
		
	$InputDisplay2.visible = false
	if not single_p1 and players.size() > 1:
		update_input($InputDisplay2, players[1])
		
	if not $InputDisplay2.visible:
		$InputDisplay.position = Vector2(0,0)
	else:
		$InputDisplay.position = Vector2(-75/2,0)
		
	if not $InputDisplay.visible:
		$InputDisplay2.position = Vector2(0,0)
	else:
		$InputDisplay2.position = Vector2(+75/2,0)

func update_input(input_display:InputDisplay, player_data):
	input_display.input = input
	input_display.setup_for_player(player_data)
