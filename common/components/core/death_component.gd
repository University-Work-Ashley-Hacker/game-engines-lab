@tool
class_name DeathComponent extends Node

@export_category("Paramaters")
## Destroy the actor node when the health component is depleted
@export var destroy: bool = true

@export_category("External Dependencies")
@export var actor: Node ## The node that get's deleted if destroy is true

## Spawn a packed scene on death [br]
## Leaving this blank won't spawn anything
@export var spawn_on_death: Array[PackedScene]

@export_group("Component Dependencies")
@export var health_component: HealthComponent

func _editor_spawn() -> void:
	unique_name_in_owner = true
	if not health_component: if has_node("../%HealthComponent"): health_component = $"../%HealthComponent"

func _ready() -> void:
	if Engine.is_editor_hint():
		_editor_spawn()
		return
	
	health_component.health_depleted.connect(_on_health_depleted)


func _on_health_depleted() -> void:
	if spawn_on_death.size() > 0:
		for scene in spawn_on_death:
			var instance := scene.instantiate()
			_set_instance_transform(instance, actor)
			actor.get_node("..").add_child(instance)
	
	if destroy: actor.queue_free()

func _set_instance_transform(_instance: Node, _actor: Node) -> void:
	if _instance.get("position") != null && _actor.get("position") != null: 
		_instance.position = _actor.position
	if _instance.get("rotation") != null && _actor.get("rotation") != null: 
		_instance.rotation = _actor.rotation
