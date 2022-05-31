extends Node

export(Resource) var default_player_setup

export var orb_throw_speed = 400

export var damage_orb = 2
export var damage_hammer = 3
export var damage_mob = 1
export var damage_swirl = 1

export(PackedScene) var player_scene
export(PackedScene) var orb_scene
export(PackedScene) var orb_pickup_scene

var current_player_datas: Array
var player_datas: Array
var current_level: Level
var current_level_index: int

var win: bool
var score: int
var time: float

func ready():
	current_player_datas.clear()
	player_datas.clear()

func add_player(input_prefix):
	var player_data = default_player_setup.duplicate(true)
	player_data.input_prefix = input_prefix
	current_player_datas.append(player_data)
	player_datas.append(player_data)

func new_game():
	randomize()
	
	current_level = null
	current_level_index = 1
	win = false
	score = 0
	time = 0
	
	get_tree().change_scene("res://Levels/Level0.tscn")

func setup_level(level:Level):
	current_level = level
	for player_data in current_player_datas:
		var player = level.spawn_player(player_data)
		player.connect("died", self, "on_player_death")

func on_player_death(player):
#	todo check if all players are dead
	current_player_datas.erase(player.data)
	if current_player_datas.size() == 0:
		defeat()
		return

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

func defeat():
	win = false
	current_player_datas.clear()
	get_tree().change_scene("res://UI/VictoryScreen.tscn")

func victory():
	win = true
	get_tree().change_scene("res://UI/VictoryScreen.tscn") 

func on_level_completed():
	if current_level.next_level == "":
		victory()
		return
	
	current_level_index += 1
	respawn_dead_players()	
	get_tree().change_scene(current_level.next_level)
	
func respawn_dead_players():
	current_player_datas = player_datas.duplicate()
	for player_data in current_player_datas:
		var half_health = floor(player_data.max_health / 2)
		if player_data.health < half_health:
			player_data.health = half_health
			
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
