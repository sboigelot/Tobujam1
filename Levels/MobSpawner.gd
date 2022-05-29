extends Position2D

var spawn_timer:float
export var spawn_delay_second:float = 10
export var max_spawn_alive:int = 3
export(PackedScene) var mob_scene

export var orb_color_chance:float = 0
export(Color) var orb_color

var tracked_mobs: Array

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		if tracked_mobs.size() < max_spawn_alive:
			spawn_next_mob()
		spawn_timer = spawn_delay_second
		
func spawn_next_mob():
	$Particles2D.emitting = true
	var mob = Game.spawn_mob(global_position, mob_scene)
	mob.data = ActorData.new()
	mob.data.carry_orb = randf() >= orb_color_chance
	mob.data.orb_color = orb_color
	tracked_mobs.append(mob)
	mob.connect("died", self, "on_mob_death")

func on_mob_death(mob):
	tracked_mobs.erase(mob)
