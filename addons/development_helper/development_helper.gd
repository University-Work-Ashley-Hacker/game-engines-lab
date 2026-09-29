class_name DevelopmentHelper 
extends Node

const HelperParams: Script = preload("res://addons/development_helper/helper_paramaters.gd")

## Developer Help Settings
@export var params: HelperParams

@export var game_controller: GameController
@export var player: PackedScene
@export var lighting: PackedScene

func _ready() -> void:
	await game_controller.ready
	game_controller.load_scene_from_path(params.scene_to_load, params.identifier)
	
	if params.spawn_lighting:
		print("What")
		game_controller.load_scene(1, lighting, "Lighting")
	if params.spawn_player:
		var player: Node3D = game_controller.load_scene(1, player, "Player")
		print(params.player_spawn_pos)
		player.global_position = params.player_spawn_pos
