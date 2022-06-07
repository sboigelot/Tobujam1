extends Node

export var big_combat_mob_threshold = 4
export var info_visible: bool = false

export(NodePath) var np_richtextlabel
onready var richtextlabel = get_node(np_richtextlabel) as RichTextLabel

var slime_count = 0
var ghost_count = 0
var eye_count = 0
var squid_count = 0
var spicy_count = 0
var boss_count = 0

func open_menu():
	clear(false)
	Drums.inMenu = true
	Drums.isEnd = true
	update_drums()

func clear(update_drums:bool = true):
	Drums.isEnd = false
	Drums.inMenu = false
	slime_count = 0
	spicy_count = 0
	ghost_count = 0
	eye_count = 0
	squid_count = 0
	boss_count = 0
	if update_drums:
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
			spicy_count += amount
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
		spicy_count +
		boss_count +
		squid_count)
	
	
	richtextlabel.bbcode_text = ""
	
	Drums.isCombat = total_mobs != 0
	Drums.isBigCombat = total_mobs >= big_combat_mob_threshold
	Drums.isSlime = slime_count > 0
	Drums.isGhost = ghost_count > 0
	Drums.isEye = eye_count > 0
	Drums.isSquid = squid_count > 0
	Drums.isSpicy = spicy_count > 0
	Drums.isBoss = boss_count > 0
	Drums.CheckMusicLayer()
	
	richtextlabel.bbcode_text += "\nMenu: %s" % bbcode_bool(Drums.inMenu)
	richtextlabel.bbcode_text += "\nBaseline: %s" % bbcode_bool(not Drums.isEnd)
	richtextlabel.bbcode_text += "\nCombat: %s" % bbcode_bool(Drums.isCombat)
	richtextlabel.bbcode_text += "\nBigCombat: %s" % bbcode_bool(Drums.isBigCombat)
	richtextlabel.bbcode_text += "\nSlime: %s" % bbcode_bool(Drums.isSlime)
	richtextlabel.bbcode_text += "\nGhost: %s" % bbcode_bool(Drums.isGhost)
	richtextlabel.bbcode_text += "\nEye: %s" % bbcode_bool(Drums.isEye)
	richtextlabel.bbcode_text += "\nSquid: %s" % bbcode_bool(Drums.isSquid)
	richtextlabel.bbcode_text += "\nSpicy: %s" % bbcode_bool(Drums.isSpicy)
	richtextlabel.bbcode_text += "\nBoss: %s" % bbcode_bool(Drums.isBoss)
	richtextlabel.bbcode_enabled = true

func bbcode_bool(value):
	return "[color=%s]%s[/color]" % [ 
		"green" if value else "red",
		value
	]

func _process(delta):
	if Input.is_action_just_pressed("toggle_music_info"):
		info_visible = !info_visible
	richtextlabel.visible = info_visible
