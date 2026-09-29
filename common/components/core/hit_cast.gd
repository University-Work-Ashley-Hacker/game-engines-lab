@icon("uid://c73j3uqi1mv5u")
@tool
class_name HitCast3D
extends RayCast3D

const HITBOX_GROUP: String = "hitbox"
@export var damage: int
@export var constant_damage: bool = false

var has_hit: bool = false

@export var active: bool:
	set(value):
		active = value
		set_deferred("enabled", value)

func _ready() -> void:
	_setup_collisions()
	if Engine.is_editor_hint(): return # Everything below only runs when the game is started
	

func _setup_collisions() -> void:
	add_to_group(HITBOX_GROUP)
	set_collision_mask_value(HurtboxComponent3D.HITHURTBOX_LAYER, true)
	set_collision_mask_value(1, false)

func _process(_delta: float) -> void:
	if not active: return
	
	var col := get_collider()
	
	if not is_colliding(): 
		has_hit = false
	
	if not constant_damage: if has_hit: return
	
	if col is HurtboxComponent3D:
		col.attack(damage)
		has_hit = true
