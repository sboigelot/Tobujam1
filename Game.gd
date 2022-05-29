extends Node

export var player_walk_speed = 200
export var player_boost_speed = 400
export var orb_throw_speed = 400

export var damage_orb = 2
export var damage_hammer = 3
export var damage_mob = 1
export var damage_swirl = 1

export(PackedScene) var orb_scene
export(PackedScene) var orb_pickup_scene

var current_level: Level
var previous_level_health = 0

func _ready():
	randomize()

func setup_level(level):
	current_level = level
	if previous_level_health != 0:
		current_level.player.health = previous_level_health
	
func spawn_orb(orb_color:Color, orb_persistant: bool, global_position:Vector2, throw_velocity:Vector2):
	var orb = orb_scene.instance() as Orb
	orb.orb_color = orb_color
	orb.global_position = global_position
	orb.persistant = orb_persistant
	current_level.orb_placeholder.add_child(orb)
	orb.apply_central_impulse (throw_velocity)

func spawn_orb_pickup(orb_color:Color, orb_persistant: bool, global_position:Vector2):
	var pickup = orb_pickup_scene.instance() as OrbPickup
	pickup.orb_color = orb_color
	pickup.persistant = orb_persistant
	pickup.global_position = global_position
	current_level.orb_pickup_placeholder.add_child(pickup)

func spawn_mob(global_position:Vector2, mob_scene:PackedScene)->Mob:
	var instance = mob_scene.instance() as Mob
	instance.global_position = global_position
	current_level.mob_placeholder.add_child(instance)
	return instance

func victory():
	previous_level_health = current_level.player.health
	get_tree().change_scene("res://Levels/Level1.tscn")
#	get_tree().reload_current_scene()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
