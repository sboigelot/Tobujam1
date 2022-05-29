extends Node2D

class_name Level

export(NodePath) var np_orb_placeholder
export(NodePath) var np_orb_slot_placeholder
export(NodePath) var np_orb_pickup_placeholder
export(NodePath) var np_mob_placeholder
export(NodePath) var np_player
export(NodePath) var np_door

onready var orb_placeholder = get_node(np_orb_placeholder) as Node2D
onready var orb_slot_placeholder = get_node(np_orb_slot_placeholder) as Node2D
onready var orb_pickup_placeholder = get_node(np_orb_pickup_placeholder) as Node2D
onready var mob_placeholder = get_node(np_mob_placeholder) as Node2D
onready var player = get_node(np_player) as Player
onready var door = get_node(np_door) as Door

export(NodePath) var np_hud
onready var hud = get_node(np_hud) as HUD

var orb_slot_to_solve: Array

func _ready():
	Game.setup_level(self)
	register_puzzle()
	hud.update_player_hearts(player, true)
	player.connect("took_damage", self, "on_player_took_damage")

func on_player_took_damage(player):
	hud.update_player_hearts(player, false)
			
func register_puzzle():
	for slot in orb_slot_placeholder.get_children():
		orb_slot_to_solve.append(slot)
		slot.connect("orb_accepted", self, "on_slot_accept_orb")

func on_slot_accept_orb(slot:OrbSlot):
	if orb_slot_to_solve.has(slot):
		orb_slot_to_solve.erase(slot)
		
	if orb_slot_to_solve.size() == 0:
		door.open()
		

