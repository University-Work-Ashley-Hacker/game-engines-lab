class_name Player extends Node2D

var rot_speed: float = 360
@export var move_component: MoveComponent
@export var bullet: PackedScene


var input_dir: float

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_try_shoot()

func _process(_delta: float) -> void:
	input_dir = Input.get_axis("left", "right")

func _physics_process(delta: float) -> void:
	global_transform = TransformUtils.rotated_around(global_transform, Vector2.ZERO, deg_to_rad(rot_speed * input_dir) * delta);

func _try_shoot() -> void:
	var instance := bullet.instantiate() as Node2D
	instance.global_transform = global_transform
	get_tree().get_root().add_child(instance)
