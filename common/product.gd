@tool
class_name Product
extends Node

@export var weight: float = 1

func _ready() -> void:
	if Engine.is_editor_hint():
		_editor_spawn()

func _editor_spawn() -> void:
	unique_name_in_owner = true
