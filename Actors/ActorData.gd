extends Resource

class_name ActorData

export var max_health:int = 5
export var health:float = 5
export var health_regen_per_second:float = 0

export var max_stamina:float = 2
export var stamina_regen_per_second:float = 0.2
export var stamina:float = 2
export var super_stamina_cost:float = .8

export var boost_stamina_cost_per_second:float = 1
export var boost_speed_multiplier = 2

var invincible:bool = false
export var speed: int = 50
export var can_move: bool = true
export var auto_boost: bool
export var auto_boost_threshold: float

export var carry_orb: bool
export var orb_persistant: bool
export var orb_color: Color

export var carry_heart: bool

export var suffer_knockback_on_hammer_attacks: bool = false

export var upgraded_weapon: bool

export var take_damage_sfx_name: String = "hit"

var input_prefix = "none"
