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

export(NodePath) var np_heart_placeholedr
export(PackedScene) var scene_heart_container
onready var heart_placeholder = get_node(np_heart_placeholedr) as Control

var orb_slot_to_solve: Array

func _ready():
	Game.setup_level(self)
	register_puzzle()
	update_player_hearts(true)
	player.connect("took_damage", self, "on_player_took_damage")

func on_player_took_damage(player):
	update_player_hearts(false)

func clear_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
			
func register_puzzle():
	for slot in orb_slot_placeholder.get_children():
		orb_slot_to_solve.append(slot)
		slot.connect("orb_accepted", self, "on_slot_accept_orb")
	
func update_player_hearts(clear:bool):
	if clear:
		clear_children(heart_placeholder)
	
	for i in player.max_health:
		var heart_container
		if heart_placeholder.get_child_count() > i:
			heart_container = heart_placeholder.get_child(i)
		else:
			heart_container = scene_heart_container.instance()
			heart_placeholder.add_child(heart_container)
	
		heart_container.full = i < player.health

func on_slot_accept_orb(slot:OrbSlot):
	if orb_slot_to_solve.has(slot):
		orb_slot_to_solve.erase(slot)
		
	if orb_slot_to_solve.size() == 0:
		door.open()
		

