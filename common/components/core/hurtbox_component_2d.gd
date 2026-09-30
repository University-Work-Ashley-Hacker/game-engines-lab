@icon("uid://fgokq5hn5m3l")
@tool
class_name HurtboxComponent2D
extends Area2D

const HURTBOX_GROUP: String = "hurtbox"
const HITHURTBOX_LAYER: int = 4

var _col: CollisionShape2D


@export var active: bool = true:
	set(value):
		active = value
		if not _col: _col = get_child(0)
		active_state_changed.emit(value)
		_col.set_deferred("disabled", !value)

@export var critical_hurtbox: bool = false
@export var critical_multiplier: float = 2

@export_group("Component Dependencies")
@export var health_component: HealthComponent

signal active_state_changed(state: bool)

func _ready() -> void:
	add_to_group(HURTBOX_GROUP)
	if not _col: _col = get_child(0)
	_setup_collisions()
	
	if Engine.is_editor_hint():
		_editor_spawn()
		return
	
	
	if not health_component:
		printerr(name + ": Health Component is not assigned")
		active = false
		return

func _editor_spawn() -> void:
	if not health_component: if $"..".has_node("%HealthComponent"): health_component = $"../%HealthComponent"

func _setup_collisions() -> void:
	add_to_group(HURTBOX_GROUP)
	set_collision_layer_value(HITHURTBOX_LAYER, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(HITHURTBOX_LAYER, true)
	set_collision_mask_value(1, false)

func attack(value: int) -> void:
	health_component.damage(value)
