extends Control

export(NodePath) var np_start_game_button
export(NodePath) var np_start_game_skip_button
export(NodePath) var np_player_selector_1
export(NodePath) var np_player_selector_2

onready var start_game_button = get_node(np_start_game_button) as Button
onready var start_game_skip_button = get_node(np_start_game_skip_button) as Button
onready var player_selector_1 = get_node(np_player_selector_1)
onready var player_selector_2 = get_node(np_player_selector_2)

func _on_NewGameButton_pressed():
	Game.new_game(true)

func _on_NewGameSkipTutoButton_pressed():
	Game.new_game(false)

func _on_PlayerSelector1_joined():
	player_selector_2.listening = true
	player_selector_2.forbidden_layouts = player_selector_2.conflicting_layouts[player_selector_1.selected_layout]
	player_selector_2.update_ui()
	Game.add_player(
		player_selector_1.layout_input_prefixes[
			player_selector_1.selected_layout
		]
	)
	start_game_button.disabled = false
	start_game_skip_button.disabled = false

func _on_PlayerSelector2_joined():
	Game.add_player(
		player_selector_2.layout_input_prefixes[
			player_selector_2.selected_layout
		]
	)

