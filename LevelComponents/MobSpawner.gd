extends Position2D

var spawn_timer:float
export var initial_spawn_delay_second:float = 3
export var deactivate_delay_second:float = 0
export var spawn_delay_second:float = 10
export var spawn_group_size:int = 1
export var spawn_group_delay:float = .2
export var max_spawn_alive:int = 3
export(PackedScene) var mob_scene

export var carry_heart_chance: float = 1
export var carry_heart_reserve: int = 0

export var orb_color_chance:float = 0
export(PoolColorArray) var potential_orb_colors

var tracked_mobs: Array
var deactivate_timer: float

func _ready():
	spawn_timer = initial_spawn_delay_second
	deactivate_timer = deactivate_delay_second
	modulate = Color.transparent

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		modulate = Color.white
		spawn_timer = spawn_delay_second
		if spawn_group_size > 1:
			spawn_timer += (spawn_group_size * spawn_group_delay)
		for i in spawn_group_size:
			if tracked_mobs.size() < max_spawn_alive:
				spawn_next_mob()
				yield(get_tree().create_timer(spawn_group_delay), "timeout")
		
	if deactivate_delay_second != 0:
		deactivate_timer -= delta
		if deactivate_timer <= 0:
			queue_free()
		
func spawn_next_mob():
	$Particles2D.emitting = true
	var mob = Game.spawn_mob(global_position, mob_scene)
	mob.data.carry_orb = randf() <= orb_color_chance
	if mob.data.carry_orb:
		var picked_orb_color = Game.current_level.pick_free_orb_color(potential_orb_colors)
		mob.data.carry_orb = picked_orb_color != Color.black
		mob.data.orb_color = picked_orb_color
		Game.current_level.register_orb_color(picked_orb_color)
	elif carry_heart_reserve > 0:
		mob.data.carry_heart = 	randf() <= carry_heart_chance
		if mob.data.carry_heart:
			carry_heart_reserve -= 1
	
	tracked_mobs.append(mob)
	mob.connect("died", self, "on_mob_death")

func on_mob_death(mob):
	tracked_mobs.erase(mob)
