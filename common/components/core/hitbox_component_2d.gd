@icon("uid://c73j3uqi1mv5u")
@tool
class_name HitboxComponent2D
extends Area2D

const HITBOX_GROUP: String = "hitbox"
@export var damage: int

var _col: CollisionShape2D

signal dealt_damage(hit_object:Node)
signal collide_no_damage

@export var active: bool:
	set(value):
		active = value
		if _col: _col.set_deferred("disabled", !value)

func _ready() -> void:
	_setup_collisions()
	if not _col: _col = get_child(0)
	if Engine.is_editor_hint(): return # Everything below only runs when the game is started
	
	
	area_entered.connect(_on_collision)

func _setup_collisions() -> void:
	add_to_group(HITBOX_GROUP)
	set_collision_layer_value(HurtboxComponent2D.HITHURTBOX_LAYER, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(HurtboxComponent2D.HITHURTBOX_LAYER, true)
	set_collision_mask_value(1, false)

func _on_collision(area: Area2D) -> void:
	if not area.is_in_group(HurtboxComponent2D.HURTBOX_GROUP):
		collide_no_damage.emit()
		return
	var hurtbox: HurtboxComponent2D = area
	hurtbox.attack(damage)
	dealt_damage.emit(area)
