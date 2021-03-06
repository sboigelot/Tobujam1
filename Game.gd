extends Node

export var orb_throw_speed = 400

export var damage_orb = 2
export var damage_hammer = 3
export var damage_upgraded_hammer = 4
export var damage_mob = 1
export var damage_swirl = 1
export var damage_arrow = 1

export(PackedScene) var player_scene
export(PackedScene) var orb_scene
export(PackedScene) var orb_pickup_scene
export(PackedScene) var heart_pickup_scene
export(PackedScene) var arrow_scene

var current_player_datas: Array
var player_datas: Array
var current_level_path = ""
var current_level: Level
var current_level_count: int
var current_tutorial_level_count: int
var current_bonus_level_count: int

var win: bool
var score: int
var time: float
var tutorial: bool
var bonus: bool

func ready():
	current_player_datas.clear()
	player_datas.clear()

func add_player(input_prefix):
	var player_data = ActorData.new()
	player_data.speed = 200
	player_data.input_prefix = input_prefix
	current_player_datas.append(player_data)
	player_datas.append(player_data)

func new_game(with_tutorial:bool):
	randomize()
	
	current_level = null
	current_level_count = 1
	current_tutorial_level_count = 1
	current_bonus_level_count = 1
	win = false
	score = 0
	time = 0
	tutorial = with_tutorial
	
	if with_tutorial:
#		change_level("res://Levels/A6_swirl.tscn")
		change_level("res://Levels/A1_tutorial_slot.tscn")
	else:	
#		change_level("res://Levels/L10.tscn")
		change_level("res://Levels/L01.tscn")

func _input(event):
	if event.is_action_pressed("skip_level"):
		on_level_completed()
			
func change_level(path):
	current_level_path = path
	get_tree().change_scene(path)

func setup_level(level:Level):
	current_level = level
	for player_data in current_player_datas:
		var player = level.spawn_player(player_data)
		player.connect("died", self, "on_player_death")
	
	if tutorial and not level.tutorial:
		tutorial = level.tutorial
		time = 0
		score = 0
	
	bonus = level.bonus_level

func on_player_death(player):
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

func spawn_arrow(global_position, shot_direction, hurt_mobs):
	var arrow = arrow_scene.instance() as Arrow
	arrow.velocity = shot_direction
	arrow.hurt_mobs = hurt_mobs
	arrow.global_position = global_position
	current_level.arrow_placeholder.add_child(arrow)

func spawn_heart_pickup(global_position:Vector2, persistant:bool):
	var pickup = heart_pickup_scene.instance() as HeartPickup
	pickup.persistant = persistant
	pickup.global_position = global_position
	current_level.orb_pickup_placeholder.add_child(pickup)

func spawn_mob(global_position:Vector2, mob_scene:PackedScene)->Mob:
	var instance = mob_scene.instance() as Mob
	instance.global_position = global_position
	current_level.mob_placeholder.add_child(instance)
	current_level.register_mob(instance)
	return instance

func defeat():
	win = false
	current_player_datas.clear()
	get_tree().change_scene("res://UI/VictoryScreen.tscn")

func retry_level():
	respawn_dead_players(true)
	change_level(current_level_path)

func victory():
	win = true
	get_tree().change_scene("res://UI/VictoryScreen.tscn") 

func on_level_completed():
	if current_level.next_level == "":
		victory()
		return
	
	if current_level.tutorial:
		current_tutorial_level_count += 1
	elif current_level.bonus_level:
		current_bonus_level_count += 1
	else:
		current_level_count += 1
	respawn_dead_players()
	change_level(current_level.next_level)
	
func respawn_dead_players(full_health:bool = false):
	current_player_datas = player_datas.duplicate()
	for player_data in current_player_datas:
		var half_health = floor(player_data.max_health / 2)
		if player_data.health < half_health:
			player_data.health = half_health
		if full_health:
			player_data.health = player_data.max_health
			
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if current_level != null and current_player_datas.size() > 0:
			get_tree().change_scene("res://UI/MainMenu.tscn")
			current_level = null
			win = false
			current_player_datas.clear()
		else:
			get_tree().quit()
		
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
