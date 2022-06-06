extends Actor

class_name Player

export var knockback_enabled: bool = false
var orb_pickups_nearby: Array
var direction = Vector2()

export(NodePath) var np_hammer_animation_player
onready var hammer_animation_player = get_node(np_hammer_animation_player) as AnimationPlayer

export(NodePath) var np_body_pivot
export(NodePath) var np_hands_pivot
export(NodePath) var np_hands
export(NodePath) var np_hammer_hinge
export(NodePath) var np_hammer_sprite
export(NodePath) var np_hammer_area
export(NodePath) var np_orb_hinge

onready var body_pivot = get_node(np_body_pivot) as Node2D
onready var hands_pivot = get_node(np_hands_pivot) as Node2D
onready var hands = get_node(np_hands) as Node2D
onready var hammer_hinge = get_node(np_hammer_hinge) as Node2D
onready var hammer_sprite = get_node(np_hammer_sprite) as Sprite
onready var hammer_area = get_node(np_hammer_area) as Area2D
onready var orb_hinge = get_node(np_orb_hinge) as Node2D

export(NodePath) var np_orb_sprite
onready var orb_sprite = get_node(np_orb_sprite) as Sprite

export(Texture) var upgraded_hammer_texture

func upgrade_hammer():
	data.upgraded_weapon = true
	hammer_sprite.texture = upgraded_hammer_texture
	
func change_hands_tool():
	hammer_hinge.visible = not data.carry_orb
	orb_hinge.visible = data.carry_orb

func rotate_hands(angle):
	body_pivot.rotation = angle
	
	var flip_h = body_pivot.rotation_degrees > 90 or body_pivot.rotation_degrees < -90
	if flip_h:
		hands.scale = Vector2(1, -1)
	else:
		hands.scale = Vector2(1, 1)
		
func mouse_rotation():
	var mouse_position = get_global_mouse_position()
	var direction = global_position.direction_to(mouse_position)
	rotate_hands(direction.angle())

func twin_stick_rotation():
	var direction = Input.get_vector(
		data.input_prefix + "_look_left", 
		data.input_prefix + "_look_right", 
		data.input_prefix + "_look_up", 
		data.input_prefix + "_look_down")
	if direction != Vector2(0,0):
		rotate_hands(direction.angle())
	
func _physics_process(delta):
	change_hands_tool()
	
	if hammer_animation_player.current_animation != "Swirl" or not hammer_animation_player.is_playing():
		if "gp" in data.input_prefix:
			twin_stick_rotation()
		else:
			mouse_rotation()

	var direction = Input.get_vector(
		data.input_prefix + "_move_left", 
		data.input_prefix + "_move_right", 
		data.input_prefix + "_move_up", 
		data.input_prefix + "_move_down")
	
	if Input.is_action_just_pressed(data.input_prefix + "_attack"):
		if data.carry_orb:
			throw_orb()
		else:
			start_slash()
			
	if Input.is_action_just_pressed(data.input_prefix + "_super"):
		if not data.carry_orb:
			start_swirl()
	
	if (not data.carry_orb and
		orb_pickups_nearby.size() > 0 and
		Input.is_action_just_pressed(data.input_prefix + "_pickup")):
			pickup_orb()
	
	flip_and_animate(direction)
	
	if Input.is_action_pressed(data.input_prefix + "_boost"):
		boost(direction, delta)
	else:
		move(direction)
	
func start_slash():
	if hammer_animation_player.is_playing():
		return
#	hammer_animation_player.stop(true)
	hammer_animation_player.play("Slash")

func start_swirl():
	if hammer_animation_player.is_playing():
		return
	
	if data.stamina > data.super_stamina_cost:
		data.stamina -= data.super_stamina_cost
		hammer_animation_player.play("Swirl")

func pickup_orb():
	var orb_pickup_nearby = orb_pickups_nearby[orb_pickups_nearby.size() - 1]
	orb_pickup_nearby.queue_free()
	orb_pickups_nearby.erase(orb_pickup_nearby)
	data.orb_color = orb_pickup_nearby.orb_color
	data.orb_persistant = orb_pickup_nearby.persistant
	orb_sprite.modulate = data.orb_color
	orb_pickup_nearby = null
	data.carry_orb = true

func throw_orb():
	data.carry_orb = false
	var direction = global_position.direction_to(hands.global_position).normalized()
	var throw_velocity = direction * Game.orb_throw_speed
	Game.spawn_orb(data.orb_color, data.orb_persistant, hands.global_position, throw_velocity)

func _on_HammerArea2D_body_entered(body:Node2D):
	if body == self:
		return
		
	if body.is_in_group("mob"):
		var damage = Game.damage_upgraded_hammer if data.upgraded_weapon else Game.damage_hammer 
		body.take_damage(damage)
		if knockback_enabled or body.data.suffer_knockback_on_hammer_attacks:
			body.knockback(global_position, 200, 0.25)
		return

func enable_hammer_damage():
	hammer_area.monitoring = true
	
func disable_hammer_damage():
	hammer_area.monitoring = false

func _on_PickupArea2D_area_entered(area:Area2D):
	if area == self:
		return

	if area.is_in_group("orb_pickup"):
		if not orb_pickups_nearby.has(area):
			orb_pickups_nearby.append(area)
		return
	
	
	if area is Pickup:
		area.picked_by(self)
		return
		
	if area.is_in_group("moving_orb_pickup"):
		var area_parent = area.get_parent()
		if not orb_pickups_nearby.has(area_parent):
			orb_pickups_nearby.append(area_parent)
		return

func _on_PickupArea2D_area_exited(area):
	if orb_pickups_nearby.has(area):
		orb_pickups_nearby.erase(area)
		return
		
	if orb_pickups_nearby.has(area.get_parent()):
		orb_pickups_nearby.erase(area.get_parent())
		return
