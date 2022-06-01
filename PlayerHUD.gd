extends MarginContainer

class_name PlayerHUD

export(NodePath) var np_player_name
onready var player_name = get_node(np_player_name) as Label

export(NodePath) var np_heart_placeholeder
export(PackedScene) var scene_heart_container
onready var heart_placeholder = get_node(np_heart_placeholeder) as Control

export(NodePath) var np_stamina_bar
export(NodePath) var np_super_bar

onready var stamina_bar = get_node(np_stamina_bar) as ProgressBar
onready var super_bar = get_node(np_super_bar) as ProgressBar

var player_data
	
func setup_player(player, player_id):
	visible = true
	player_data = player.data
	player_name.text = "Player %d" % (player_id+1)
	update_player_hearts(true)

	player.connect("took_damage", self, "on_player_took_damage")
	
func on_player_took_damage(player):
	update_player_hearts(false)

func clear_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
func update_player_hearts(clear:bool):
	if player_data == null:
		return
	
	if clear:
		clear_children(heart_placeholder)
	
	for i in player_data.max_health:
		var heart_container
		if heart_placeholder.get_child_count() > i:
			heart_container = heart_placeholder.get_child(i)
		else:
			heart_container = scene_heart_container.instance()
			heart_placeholder.add_child(heart_container)
	
		heart_container.full = i < player_data.health

func _process(delta):
	if player_data == null:
#		visible = false
		return
	visible = true
	 
	update_stamina_bar()

func update_stamina_bar():
	if player_data == null:
		return
		
	stamina_bar.rect_min_size.x = player_data.max_stamina * 100
	stamina_bar.max_value = player_data.max_stamina
	stamina_bar.value = player_data.stamina
	
	super_bar.max_value = player_data.max_stamina
	super_bar.value = player_data.super_stamina_cost
	super_bar.visible = super_bar.value > player_data.stamina
