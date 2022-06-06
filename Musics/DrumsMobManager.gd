extends Node

export var big_combat_mob_threshold = 4

var slime_count = 0
var ghost_count = 0
var eye_count = 0
var squid_count = 0
var boss_count = 0

func clear():
	Drums.isEnd = false
	slime_count = 0
	ghost_count = 0
	eye_count = 0
	squid_count = 0
	boss_count = 0
	update_drums()
	

func add_mob(mob:Mob):
	count_mob(mob, +1)
	
func remove_mob(mob:Mob):
	count_mob(mob, -1)
	
func count_mob(mob, amount):
	match mob.filename:
		"res://Actors/Mobs/MobEye.tscn":
			eye_count += amount
		"res://Actors/Mobs/MobGhost.tscn":
			ghost_count += amount
		"res://Actors/Mobs/MobLee.tscn":
			slime_count += amount
		"res://Actors/Mobs/MobQueen.tscn":
			boss_count += amount
		"res://Actors/Mobs/MobSquid.tscn":
			squid_count += amount
		"res://Actors/Mobs/MobTreeeyeo.tscn":
			boss_count += amount
		_:
			printerr("DrumsMobManager: unknown mob filename")

	update_drums()

func on_victory():
	pass
#	Drums.isEnd = true
	
func update_drums():
	var total_mobs = (
		eye_count +
		ghost_count +
		slime_count +
		boss_count +
		squid_count)
		
	Drums.isCombat = total_mobs != 0
	Drums.isBigCombat = total_mobs >= big_combat_mob_threshold
	Drums.isSlime = slime_count > 0
	Drums.isGhost = ghost_count > 0
	Drums.isEye = eye_count > 0
	Drums.isSquid = squid_count > 0
	Drums.isBoss = boss_count > 0
