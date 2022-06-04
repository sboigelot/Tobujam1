extends Node2D

class_name Level

export(NodePath) var np_orb_placeholder
export(NodePath) var np_trigger_placeholder
export(NodePath) var np_mechanism_placeholder
export(NodePath) var np_orb_pickup_placeholder
export(NodePath) var np_mob_placeholder
export(NodePath) var np_arrow_placeholder
export(NodePath) var np_door

export(NodePath) var np_player_spawnpoint_1
export(NodePath) var np_player_spawnpoint_2

onready var orb_placeholder = get_node(np_orb_placeholder) as Node2D
onready var trigger_placeholder = get_node(np_trigger_placeholder) as Node2D
onready var mechanism_placeholder = get_node(np_mechanism_placeholder) as Node2D
onready var orb_pickup_placeholder = get_node(np_orb_pickup_placeholder) as Node2D
onready var mob_placeholder = get_node(np_mob_placeholder) as Node2D
onready var arrow_placeholder = get_node(np_arrow_placeholder) as Node2D
onready var player_spawnpoint_1 = get_node(np_player_spawnpoint_1) as Position2D
onready var player_spawnpoint_2 = get_node(np_player_spawnpoint_2) as Position2D
onready var door = get_node(np_door) as Door

export(NodePath) var np_hud
onready var hud = get_node(np_hud) as HUD

export(String, FILE, "*.tscn") var next_level

export(NodePath) var np_start_anim_1
export(NodePath) var np_start_anim_2
export(NodePath) var np_start_anim_3
export(NodePath) var np_start_anim_4
export(NodePath) var np_start_anim_5

onready var np_start_anims = [
	np_start_anim_1,
	np_start_anim_2,
	np_start_anim_3,
	np_start_anim_4,
	np_start_anim_5,
]
	
var triggers: Array
var mechanisms: Array
var players : Array

export(PoolColorArray) var puzzel_colors
var max_orb_per_colors: Dictionary
var orb_per_colors: Dictionary

export var trigger_all_mob_dead: String 
var mob_alive: Array


func _ready():
	register_mechanisms(mechanism_placeholder)
	register_triggers(trigger_placeholder)
	register_mobs(mob_placeholder)
	compute_max_orb_per_color()
	assing_accepted_colors()
	register_orbs()
	Game.setup_level(self)
	start_animations()


func register_mob(mob:Actor):
	if not mob_alive.has(mob):
		mob_alive.append(mob)
		mob.connect("died", self, "un_register_mob")

func un_register_mob(mob):
	if mob_alive.has(mob):
		mob_alive.erase(mob)
	
	if trigger_all_mob_dead != "" and mob_alive.size() == 0:
		resolve_trigger_group(trigger_all_mob_dead)


func start_animations():
	for np in np_start_anims:
		if np != null:
			var anim = get_node(np) as AnimationPlayer
			if anim != null:
				var animations = anim.get_animation_list()
				anim.play(animations[0])

func _process(delta):
	Game.time += delta
	
func compute_max_orb_per_color():
	max_orb_per_colors.clear()
	
	for color in puzzel_colors:
		if max_orb_per_colors.has(color):
			max_orb_per_colors[color] += 1
		else:
			max_orb_per_colors[color] = 1
			
	for trigger in triggers:
		if not trigger is OrbSlot:
			continue
		var slot = trigger as OrbSlot
		if slot.accepted_color == Color.black:
			continue
		if max_orb_per_colors.has(slot.accepted_color):
			max_orb_per_colors[slot.accepted_color] += 1
		else:
			max_orb_per_colors[slot.accepted_color] = 1

func register_mobs(container):
	for mob in container.get_children():
		if mob is Mob:
			register_mob(mob)

func register_orbs():
	orb_per_colors.clear()
	
	for orb in orb_placeholder.get_children():
		register_orb_color(orb.orb_color)
		
	for pickup in orb_pickup_placeholder.get_children():
		if pickup is OrbPickup:
			register_orb_color(pickup.orb_color)
			
	for mob in mob_placeholder.get_children():
		if mob is Mob and mob.data.carry_orb:
			register_orb_color(mob.data.orb_color)
		
func register_orb_color(color):
#	print("register_orb_color(color) with %s" % color)
	if orb_per_colors.has(color):
		orb_per_colors[color] += 1
	else:
		orb_per_colors[color] = 1
	
func unregister_orb_color(color):
#	print("unregister_orb_color(color) with %s" % color)
	if orb_per_colors.has(color):
		orb_per_colors[color] -= 1

func pick_free_orb_color(requester_set:PoolColorArray)->Color:
	var potential_colors = get_potential_colors(requester_set)
	if potential_colors.size() == 0:
		return Color.black
	
	return potential_colors[randi() % potential_colors.size()]
		
func get_potential_colors(requester_set:PoolColorArray)->PoolColorArray:
	
	var potential_colors = PoolColorArray()
	var requester_set_array = Array(requester_set)
	
	for orb_color in max_orb_per_colors:	
		if (requester_set_array.size() != 0 and
			not requester_set_array.has(orb_color)):
				continue
		
		var max_orbs = max_orb_per_colors[orb_color]
		var orb_count = 0
		if orb_per_colors.has(orb_color):
			orb_count = orb_per_colors[orb_color]
		var remaining_orbs = max_orbs - orb_count 
		if remaining_orbs > 0:
			potential_colors.append(orb_color)
	
	return potential_colors

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

func register_mechanisms(container):
	for mechanism in container.get_children():
		if mechanism is Mechanism:
			mechanisms.append(mechanism)
		else:
			register_mechanisms(mechanism)
	
func register_triggers(container):
	for trigger in container.get_children():
		if trigger is Trigger:
			triggers.append(trigger)
			trigger.connect("activated", self, "on_trigger_activated")
			trigger.connect("deactivated", self, "on_trigger_deactivated")
		else:
			register_triggers(trigger)

func assing_accepted_colors():
	var remaining_colors = PoolColorArray(puzzel_colors)
	for trigger in trigger_placeholder.get_children():
		if trigger is OrbSlot:
			var slot = trigger as OrbSlot
			if slot.accepted_color == Color.black:
				var picked_index = randi() % remaining_colors.size()
				slot.accepted_color = remaining_colors[picked_index]
				remaining_colors.remove(picked_index)

func on_trigger_deactivated(trigger:Trigger):
	var group = trigger.trigger_group
	if trigger.trigger_group != "":
		deresolve_trigger_group(group)
#
#	if trigger.deactivate_trigger_group != "":
#		resolve_trigger_group(trigger.deactivate_trigger_group)

func on_trigger_activated(trigger:Trigger):	
	
	if trigger.trigger_group != "":
		resolve_trigger_group(trigger.trigger_group)
		
	if trigger.deactivate_trigger_group != "":
		deresolve_trigger_group(trigger.deactivate_trigger_group, true)
		
func resolve_trigger_group(group):
	var group_resolved = true
	for other_trigger in triggers:
		if other_trigger.resolved:
			if other_trigger.any_trigger:
				group_resolved = true
				break
			continue
			
		if other_trigger.trigger_group == group:
			group_resolved = false
	
	if not group_resolved:
		return
	
	for mechanism in mechanisms:
		if mechanism.trigger_group == group:
			mechanism.open()

func deresolve_trigger_group(group, force:bool = false):
	for mechanism in mechanisms:
		if not force and mechanism.stay_open_on_deresolve:
			continue
		if mechanism.trigger_group == group:
			mechanism.close()
