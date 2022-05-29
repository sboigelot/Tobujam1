extends CanvasLayer

class_name HUD

export(NodePath) var np_heart_placeholedr
export(PackedScene) var scene_heart_container
onready var heart_placeholder = get_node(np_heart_placeholedr) as Control

export(NodePath) var np_stamina_bar
onready var stamina_bar = get_node(np_stamina_bar) as ProgressBar
	
func clear_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
func update_player_hearts(player:Player, clear:bool):
	if clear:
		clear_children(heart_placeholder)
	
	for i in player.data.max_health:
		var heart_container
		if heart_placeholder.get_child_count() > i:
			heart_container = heart_placeholder.get_child(i)
		else:
			heart_container = scene_heart_container.instance()
			heart_placeholder.add_child(heart_container)
	
		heart_container.full = i < player.data.health

func _process(delta):
	if Game.current_level == null:
		return
		
	if Game.current_level.players.size() == 0:
		return
		
	update_stamina_bar(Game.current_level.players[0])

func update_stamina_bar(player:Player):
	stamina_bar.rect_min_size.x = player.data.max_stamina * 100
	stamina_bar.max_value = player.data.max_stamina
	stamina_bar.value = player.data.stamina
