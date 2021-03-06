extends Trigger

class_name OrbSlot

export(Color) var accepted_color
var orb_color: Color
var orb_persistant: bool
export var orb_ring_visible: bool
export var throw_direction: Vector2 = Vector2(0,1)

export(NodePath) var np_orb_sprite
export(NodePath) var np_orb_ring
export(NodePath) var np_slot_area_shape
export(NodePath) var np_static_area_shape
export(NodePath) var np_status_sprite

onready var orb_sprite = get_node(np_orb_sprite) as Sprite
onready var orb_ring = get_node(np_orb_ring) as Sprite
onready var slot_area_shape = get_node(np_slot_area_shape) as CollisionShape2D
onready var static_area_shape = get_node(np_static_area_shape) as CollisionShape2D
onready var status_sprite = get_node(np_status_sprite) as Sprite

func _ready():
	update_orb_ring()
	static_area_shape.set_deferred("disabled", true)

func update_orb_ring():
	orb_ring.modulate = accepted_color
	orb_ring.visible = orb_ring_visible
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("orb"):
		if  body.orb_color == accepted_color:
			accept_orb(body)
		else:
			reject_orb(body)

func accept_orb(orb:Orb):
	slot_area_shape.set_deferred("disabled", true)
	static_area_shape.set_deferred("disabled", false)
	
	orb_sprite.visible = true
#	orb_ring.visible = false
	orb_color = orb.orb_color
	orb_persistant = orb.persistant
	orb_sprite.modulate = orb_color
	orb.queue_free()
	
	status_sprite.visible = true
	status_sprite.modulate = Color.green
	SfxManager.play("harp_metal")
	
	resolve()
	
func reject_orb(orb:Orb):
	
	slot_area_shape.set_deferred("disabled", true)
	static_area_shape.set_deferred("disabled", false)
	
	orb_sprite.visible = true
	orb_color = orb.orb_color
	orb_persistant = orb.persistant
	orb_sprite.modulate = orb_color
	
	orb.queue_free()

	SfxManager.play("fail")
	status_sprite.modulate = Color.red
	
	status_sprite.visible = true
	for i in range(10):
		yield(get_tree().create_timer(0.3), "timeout")
		status_sprite.visible = !status_sprite.visible
	status_sprite.visible = true
	
	yield(get_tree().create_timer(2.0), "timeout")
	static_area_shape.set_deferred("disabled", true)
	Game.spawn_orb(orb_color, orb_persistant, orb_sprite.global_position, throw_direction * Game.orb_throw_speed*2)
	orb_sprite.visible = false
	status_sprite.modulate = Color.orange
	
	yield(get_tree().create_timer(5.0), "timeout")
	status_sprite.visible = false
	
	slot_area_shape.set_deferred("disabled", false)
	
	
