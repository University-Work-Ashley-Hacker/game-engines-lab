@icon("uid://b3efa4fddfsto")
@tool
class_name HealthComponent
extends Node

@export_category("Parameters")
@export var _debug_print: bool = false

@export_category("Dependencies")
@export var stat_component: StatComponent


# These only return the private variable and cannot be set
var health: int:
	get:
		return _health
var max_health: int:
	get:
		return _max_health

# Entity health property
var _health : int:
	set(value):
		_health = value
		health_changed.emit(_health)
# Entity maximum health property
var _max_health : int:
	set(value):
		_max_health = value
		max_health_changed.emit(_max_health)

## Is emit when damage occurs
signal damage_taken(value: int)
## Is emit when health is changed
signal health_changed(health: int)
## Is emit when max health is changed
signal max_health_changed(max_health: int)
## Is emit when health is depleted
signal health_depleted
## Is emit when the entity is healed
signal healed(amount: int)
## Is emit when entity is healed up to max_health
signal health_recovered(max_health: int)


func _ready() -> void:
	if Engine.is_editor_hint():
		_editor_spawn()
		return
	
	stat_component.on_prop_changed.connect(_on_stat_updated)
	_health = stat_component.stats.health
	_max_health = stat_component.stats.max_health

func _editor_spawn() -> void:
	unique_name_in_owner = true
	if not stat_component: if has_node("../%StatComponent"): stat_component = $"../%StatComponent"

## Reduces the health by the provided value
func damage(value : int) -> void:
	_health = clamp(_health - value, 0, _max_health)
	damage_taken.emit(value)
	_print("Damaged" + str(value))
	
	
	if _health <= 0:
		_print("Health Depleted" + str(value))
		health_depleted.emit()

## Increase the health by the provided value
func heal(value: int) -> void:
	_health = clamp(_health + value, 0, _max_health)
	healed.emit(value)
	_print("Healed" + str(value))
	
	if _health == _max_health:
		health_recovered.emit(_health)
		_print("Full Recover")

## Adds value to max_health property, positive for increase, negative for decrease
func change_max_health(value : int) -> void:
	_max_health = max(_max_health + value, 0)
	max_health_changed.emit(_max_health)


func _on_stat_updated(prop: String, value: int) -> void:
	match prop:
		"health":
			_health = value
		"max_health":
			_max_health = value

func _print(text: String) -> void:
	if not _debug_print: return
	print_rich("[b][color=red]HealthComponent: [/color][/b]" + text)
