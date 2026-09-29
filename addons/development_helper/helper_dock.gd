@tool
class_name HelperDock 
extends PanelContainer

signal run
## Developer Help Settings
@export var params: HelperParams

@export_category("Paramaters")

@export_category("References")

@export_category("Dependencies")
@export_group("Scene")
@export var scene_path_line_edit: LineEdit
@export var scene_path_pick_button: Button
@export var select_current_scene_path_button: Button
@export var scene_identifier_line_edit: LineEdit
@export_group("Spawn")
@export var spawn_player_toggle: Button
@export var spawn_lighting_toggle: Button
@export var player_spawn_pos_menu: Control
@export var spawn_x: SpinBox
@export var spawn_y: SpinBox
@export var spawn_z: SpinBox
@export_group("Run")
@export var run_button: Button

var file_dialog: EditorFileDialog

var plugin: EditorPlugin

func _enter_tree() -> void:
	scene_identifier_line_edit.text = params.identifier
	spawn_player_toggle.set_pressed_no_signal(params.spawn_player)
	spawn_lighting_toggle.set_pressed_no_signal(params.spawn_lighting)
	
	_connect_signals()
	
	player_spawn_pos_menu.visible = params.spawn_player
	
	file_dialog = EditorFileDialog.new()
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	file_dialog.add_filter("*.tscn, *.scn", "Scenes")
	file_dialog.file_selected.connect(_on_file_selected)
	add_child(file_dialog)

func _on_file_selected(path: String) -> void:
	scene_path_line_edit.text = path
	params.scene_to_load = path
	ResourceSaver.save(params)
	print("Selected scene: ", path)


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F10:
			_on_run_pressed()
			get_viewport().set_input_as_handled()

func _connect_signals() -> void:
	run_button.pressed.connect(_on_run_pressed)
	select_current_scene_path_button.pressed.connect(_on_select_current_pressed)
	
	scene_path_pick_button.pressed.connect(_on_pick_pressed)
	
	scene_identifier_line_edit.text_changed.connect(func(new_text: String): params.identifier = new_text)
	scene_path_line_edit.text_changed.connect(func(new_text: String): params.scene_to_load = new_text)
	
	spawn_player_toggle.toggled.connect(_spawn_player_toggled)
	spawn_lighting_toggle.toggled.connect(func(state: bool): params.spawn_lighting = state)
	
	spawn_x.value_changed.connect(func(value: float): params.player_spawn_pos.x = value)
	spawn_y.value_changed.connect(func(value: float): params.player_spawn_pos.y = value)
	spawn_z.value_changed.connect(func(value: float): params.player_spawn_pos.z = value)

func _spawn_player_toggled(state: bool) -> void:
	params.spawn_player = state
	player_spawn_pos_menu.visible = state
	if state:
		params.player_spawn_pos.x = spawn_x.value
		params.player_spawn_pos.y = spawn_y.value
		params.player_spawn_pos.z = spawn_z.value
	else:
		params.player_spawn_pos = Vector3.ZERO

func _on_run_pressed() -> void:
	ResourceSaver.save(params, "res://addons/development_helper/params.tres")
	print("RUN")
	run.emit()


func _on_pick_pressed() -> void:
	print("TRUEs")
	file_dialog.popup_centered_ratio(0.6)


func _on_select_current_pressed() -> void:
	_on_file_selected(plugin.get_current_opened_scene())
