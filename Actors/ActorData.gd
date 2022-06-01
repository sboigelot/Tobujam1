extends Resource

class_name ActorData

export var max_health:int = 5
export var health:int = 5

export var max_stamina:float = 2
export var stamina_regen_per_second:float = 0.2
export var stamina:float = 2
export var super_stamina_cost:float = 1.2

export var boost_stamina_cost_per_second:float = 1
export var boost_speed_multiplier = 2

var invincible:bool = false
export var speed: int = 50

export var carry_orb: bool
export var orb_persistant: bool
export var orb_color: Color

var input_prefix = "none"
