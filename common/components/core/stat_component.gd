@tool
class_name StatComponent
extends Node

@export var stats: Dictionary = {
	"max_health": 10,
	"health": 10,
	"move_speed": 20.0,
}

## Is emit when a value is changed.
signal on_prop_changed(prop: String, value: float)

func _ready() -> void:
	if Engine.is_editor_hint():
		unique_name_in_owner = true

func _property_type_checker(prop: String) -> Variant.Type:
	if prop not in stats.keys():
		printerr("Property '" + prop + "' not found")
		return TYPE_NIL

	# returns type
	return typeof(stats[prop]) as Variant.Type


## It is used to increase the value of an entity stat.
func increase_property(prop: String, value: float) -> void:
	# checks if the property is not a float
	#if _property_type_checker(prop) != TYPE_FLOAT or _property_type_checker(prop) != TYPE_INT:
	#	printerr("Cannot increase the property of a non integer/ non float")
	#	return

	# increase the property by value
	stats[prop] += value
	# emit prop changed signal
	on_prop_changed.emit(prop, stats[prop])


## Returns the multiplied value of a provided stat
func multiply_property(prop: String, value: float) -> void:
	# checks if the property is not a float
	if _property_type_checker(prop) != TYPE_FLOAT:
		printerr("Cannot increase the property of a non integer")
		return

	# multiply the property by value
	stats[prop] *= value
	# emit prop changed signal
	on_prop_changed.emit(prop, stats[prop])
