extends Node

#This loveable mess will let you toggle music layers to be brought in and out of gameplay.
#Click on the vars in the inspector to test out the system and adjust the 
#Check Time and Transition Duration until you're happy with it.

#either set the vars on your own, or call them through SetMusic(string,bool).

#Full list of allowed strings:
	# "baseline": base music
	# "fight","combat": combat music
	# "bigFight","bigCombat": combat music with large number of enemies
	# "slime","slimes": slime enemies present
	# "ghost","ghoul","ghosts",ghouls": Ghost enemies present
	# "eye","bat": EyeBatThing enemies present
	# "squid","boss0": Squid Boss
	# "queenslime","boss1","finalboss": Queen Slime



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#intentionally exposed vars
#checkTime controls how long between checking on game state
#export var checkTime = 1.2

#enemiesThreshold determines how many enemies it takes to make a fight a BIG fight
#export var enemiesThreshold = 3

export var minVolume = -80.0;
#set maxVolume with a slider and fading audio won't ever go past it.
export var maxVolume = 0.0;
export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE
export var ease_type = 2
#This determines how many steps are taken from max volume to mute and vice cersa.
#export var numberOfFadeSteps = 8;
#export var fadeWaitTime = .1


#internal vars
export var isCombat = false;
export var isBigCombat = false;
var enemiesCount = 0;
export var isSlime = false
export var isGhost = false
export var isEye = false
export var isSquid = false
export var isSpicy = false
export var isBoss = false
export var isEnd = false
export var inMenu = false

#vars for whether track is active or not; purely for system
var menuPlaying=false
var baselinePlaying=false
var combatPlaying = false
var ghostPlaying = false
var eyePlaying =false
var slimePlaying=false
var bigCombatPlaying=false
var squidPlaying=false 
var spicyPlaying=false 
var bossPlaying=false 
var endPlaying=false

#Set up audio streams
export var menuMusicPlayer: NodePath
export var baselinePlayer: NodePath
export var combatPlayer: NodePath
export var bigCombatPlayer: NodePath
export var slimePlayer: NodePath
export var eyePlayer: NodePath
export var ghostPlayer: NodePath
export var squidPlayer: NodePath
export var spicyPlayer: NodePath
export var bossPlayer: NodePath
#export var endPlayer: NodePath

onready var menuMusic = get_node(menuMusicPlayer) 
onready var baselineMusic = get_node(baselinePlayer) 
onready var combatMusic = get_node(combatPlayer) 
onready var bigCombatMusic = get_node(bigCombatPlayer) 
onready var slimeMusic = get_node(slimePlayer)  
onready var eyeMusic = get_node(eyePlayer) 
onready var ghostMusic = get_node(ghostPlayer) 
onready var squidMusic = get_node(squidPlayer) 
onready var spicyMusic = get_node(spicyPlayer) 
onready var bossMusic = get_node(bossPlayer) 
#onready var endMusic = get_node(endPlayer) 

#Set up timers

export var CheckTimerPath: NodePath
onready var checkTimer = get_node(CheckTimerPath)

export var FadeTimerPath: NodePath
onready var fadeTimer = get_node(FadeTimerPath)

#tweens
export var tweenInPath: NodePath
export var tweenOutPath: NodePath
onready var tween_in = get_node(tweenInPath)
onready var tween_out = get_node(tweenOutPath)

# Called when the node enters the scene tree for the first time.
#func _ready():
	#Start timer:
#	checkTimer.connect("timeout",self,"CheckMusicLayer",[],0)

#simple bool solution, handle with another script and SetMusic(layer,bool)
func CheckLayer(desired, is_playing, music_player)->bool:
	if desired: 
		if not is_playing:
			FadeIn(music_player)
		return true
		
	if is_playing:
		FadeOut(music_player)
	return false

func CheckMusicLayer():
#	print("checking for input")
	#Checks every layer to see if changes are necessary.
	#BigFight: uses Bigfight function to read enemy count
	#TODO: Combine with Fight for optimization
	
	#report that enemies are greater than (enemyThreshold) and this will trigger
	#if(BigFightMusic()): #Use this if you want to pass enemies with SetEnemyCount(int)
	
	#report that enemies are greater than 0 and this will enable
	#if(FightMusic()): Use this if you want to actually pass enemy count to script
	
	bigCombatPlaying = CheckLayer(isBigCombat, bigCombatPlaying, bigCombatMusic)
	combatPlaying = CheckLayer(isCombat, combatPlaying, combatMusic)
	slimePlaying = CheckLayer(isSlime, slimePlaying, slimeMusic)
	spicyPlaying = CheckLayer(isSpicy, spicyPlaying, spicyMusic)
	ghostPlaying = CheckLayer(isGhost, ghostPlaying, ghostMusic)
	eyePlaying = CheckLayer(isEye, eyePlaying, eyeMusic)
	squidPlaying = CheckLayer(isSquid, squidPlaying, squidMusic)
	bossPlaying = CheckLayer(isBoss, bossPlaying, bossMusic)
	baselinePlaying = CheckLayer(not isEnd and not inMenu, baselinePlaying, baselineMusic)
	menuPlaying = CheckLayer(inMenu, menuPlaying, menuMusic)
	

func FadeIn(audiosource):
	var i = minVolume
	tween_in.interpolate_property(audiosource, "volume_db", minVolume,maxVolume, transition_duration, transition_type, ease_type, 0)
	tween_in.start()
		
	#pass

func FadeOut(audiosource):
	#I miss CSharp :(
	var i = maxVolume
#	for _x in range(numberOfFadeSteps):
#		audiosource.volume_db = i
#		i -= ((minVolume-maxVolume)/numberOfFadeSteps)
		#yield(fadeTimer, "timeout")
	tween_out.interpolate_property(audiosource, "volume_db", maxVolume, minVolume, transition_duration, transition_type, ease_type, 0)
	tween_out.start()
	
	pass
#
#func BossFight(toggle):
#	isBoss = toggle
#	pass

#func FightMusic():
#	if(enemiesCount > 0):
#		return true
#	else:
#		return false

#func BigFightMusic():
#	if (enemiesCount > enemiesThreshold):
#		return true
#	else:
#		return false

#func SetMusic(layer,enabled):
#	match layer:
#		"baseline":
#			isEnd = !enabled
#		"combat" or "fight":
#			isCombat = enabled
#		"bigCombat" or "bigFight" or "bigcombat" or "bigfight":
#			isBigCombat = enabled
#		"slime" or "slimes":
#			isSlime = enabled
#		"ghost" or "ghoul" or "ghosts" or "ghouls":
#			isGhost = enabled
#		"eye" or "bat" or "eyes" or "bats":
#			isEye = enabled
#		"squid" or "boss0":
#			isSquid = enabled
#		"boss" or "boss1" or "finalboss" or "queenslime":
#			isBoss = enabled
#		"end" or "win":
#			isEnd = enabled
#
#func SetEnemyCount(enemyCount):
#	enemiesCount = enemyCount

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
