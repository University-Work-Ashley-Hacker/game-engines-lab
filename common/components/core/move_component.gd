@tool
class_name MoveComponent
extends Node

@export_group("Dependencies")
## The node you want to control
@export var actor: Node2D
## The velocity of the actor
@export var velocity: Vector2

@export var stat_component: StatComponent

func _ready() -> void:
	if Engine.is_editor_hint():
		_editor_spawn()

func _editor_spawn() -> void:
	if not stat_component: if has_node("../%StatComponent"): stat_component = $"../%StatComponent"
	unique_name_in_owner = true

func _physics_process(delta: float) -> void:
	var vel_cal: Vector2
	
	vel_cal = velocity * delta
	
	if actor is CharacterBody2D:
		actor.velocity = vel_cal * 50
		actor.move_and_slide()
	else:
		actor.translate(vel_cal)
