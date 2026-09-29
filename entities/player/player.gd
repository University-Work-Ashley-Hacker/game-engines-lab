class_name Player extends CharacterBody2D


const SPEED = 300.0
@export var move_component: MoveComponent
@export var pivot: Node2D

func _physics_process(_delta: float) -> void:
	var input_dir: float = Input.get_axis("left", "right")
