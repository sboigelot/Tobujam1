extends Node2D

class_name Level

export(NodePath) var np_orb_placeholder
export(NodePath) var np_orb_slot_placeholder
export(NodePath) var np_orb_pickup_placeholder
export(NodePath) var np_mob_placeholder
export(NodePath) var np_door

export(NodePath) var np_player_spawnpoint_1
export(NodePath) var np_player_spawnpoint_2

onready var orb_placeholder = get_node(np_orb_placeholder) as Node2D
onready var orb_slot_placeholder = get_node(np_orb_slot_placeholder) as Node2D
onready var orb_pickup_placeholder = get_node(np_orb_pickup_placeholder) as Node2D
onready var mob_placeholder = get_node(np_mob_placeholder) as Node2D
onready var player_spawnpoint_1 = get_node(np_player_spawnpoint_1) as Position2D
onready var player_spawnpoint_2 = get_node(np_player_spawnpoint_2) as Position2D
onready var door = get_node(np_door) as Door

export(NodePath) var np_hud
onready var hud = get_node(np_hud) as HUD

export(String, FILE, "*.tscn") var next_level

var orb_slot_to_solve: Array
var players : Array

export(PoolColorArray) var puzzel_colors
var max_orb_per_colors: Dictionary
var orb_per_colors: Dictionary

func _ready():
	
	compute_max_orb_per_color()
	register_orbs()
	register_puzzle()
	
	Game.setup_level(self)

func compute_max_orb_per_color():
	for color in puzzel_colors:
		if max_orb_per_colors.has(color):
			max_orb_per_colors[color] += 1
		else:
			max_orb_per_colors[color] = 1

func register_orbs():
	orb_per_colors.clear()
	for orb in orb_placeholder.get_children():
		register_orb_color(orb.orb_color)
	for pickup in orb_pickup_placeholder.get_children():
		if pickup is OrbPickup:
			register_orb_color(pickup.orb_color)
		
func register_orb_color(color):
	if orb_per_colors.has(color):
		orb_per_colors[color] += 1
	else:
		orb_per_colors[color] = 1
	
func unregister_orb_color(color):
	if orb_per_colors.has(color):
		orb_per_colors[color] -= 1

func pick_free_orb_color()->Color:
	return Color.black

func spawn_player(player_data)->Player:
	
	var spawn_point = player_spawnpoint_1
	if players.size() != 0:
		spawn_point = player_spawnpoint_2
	
	var player = Game.player_scene.instance()
	player.global_position = spawn_point.global_position
	player.data = player_data
	
	hud.setup_player(player, players.size())
	add_child(player)
	players.append(player)
	return player
			
func register_puzzle():
	
	var remaining_colors = PoolColorArray(puzzel_colors)
	
	for slot in orb_slot_placeholder.get_children():
		orb_slot_to_solve.append(slot)
		slot.connect("orb_accepted", self, "on_slot_accept_orb")
		
		if slot.accepted_color == Color.black:
			var picked_index = randi() % remaining_colors.size()
			slot.accepted_color = remaining_colors[picked_index]
			remaining_colors.remove(picked_index)



func on_slot_accept_orb(slot:OrbSlot):
	if orb_slot_to_solve.has(slot):
		orb_slot_to_solve.erase(slot)
		
	if orb_slot_to_solve.size() == 0:
		door.open()
		

