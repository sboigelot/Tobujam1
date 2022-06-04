extends Mechanism

class_name SpikeTrap

export var activated:bool = false
export var damage:int = 1
export var knockback_force:int = 100
export var knockback_time:float = 0.3
export var close_timer:float = 3
export var hurt_mob:bool = true

export(NodePath) var np_down_sprite
export(NodePath) var np_up_sprite
export(NodePath) var np_static_body_shape

onready var down_sprite = get_node(np_down_sprite) as Sprite
onready var up_sprite = get_node(np_up_sprite) as Sprite
onready var static_body_shape = get_node(np_static_body_shape) as CollisionShape2D

func _ready():
	update_state()

func open():
	activated = true
	update_state()

func close():
	activated = false
	update_state()
	
func update_state():
	down_sprite.visible = not activated
	up_sprite.visible = activated
	static_body_shape.set_deferred("disabled", not activated)

func _on_SpikeArea2D_body_entered(body):
	if (body.is_in_group("player") or
		(body.is_in_group("mob") and hurt_mob)):
		body.take_damage(damage)
		body.knockback(global_position, knockback_force, knockback_time)
		
		activated = false
		update_state()

		yield(get_tree().create_timer(close_timer), "timeout")
		activated = true
		update_state()
