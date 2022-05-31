extends CanvasLayer

class_name HUD

export(NodePath) var np_player_1
export(NodePath) var np_player_2

onready var player_1 = get_node(np_player_1) as PlayerHUD
onready var player_2 = get_node(np_player_2) as PlayerHUD

func _ready():
	player_1.visible = false
	player_2.visible = false

func setup_player(player, player_id):
	
	var player_hud = player_1
	if player_id != 0:
		player_hud = player_2
	
	player_hud.setup_player(player, player_id)
