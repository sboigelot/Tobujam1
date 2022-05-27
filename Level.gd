extends Node2D

class_name Level

export(NodePath) var np_orb_placeholder
export(NodePath) var np_orb_slot_placeholder
export(NodePath) var np_orb_pickup_placeholder
export(NodePath) var np_mob_placeholder
export(NodePath) var np_player

onready var orb_placeholder = get_node(np_orb_placeholder) as Node2D
onready var orb_slot_placeholder = get_node(np_orb_slot_placeholder) as Node2D
onready var orb_mob_placeholder = get_node(np_mob_placeholder) as Node2D
onready var player = get_node(np_player) as Player

export(NodePath) var np_door

onready var door = get_node(np_door) as Door

var orb_slot_to_solve: Array

func _ready():
	Game.setup_level(self)
	
	for slot in orb_slot_placeholder.get_children():
		orb_slot_to_solve.append(slot)
		slot.connect("orb_accepted", self, "on_slot_accept_orb")

func on_slot_accept_orb(slot:OrbSlot):
	if orb_slot_to_solve.has(slot):
		orb_slot_to_solve.erase(slot)
		
	if orb_slot_to_solve.size() == 0:
		door.open()
		
	
