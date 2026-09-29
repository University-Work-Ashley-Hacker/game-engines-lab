@tool
extends EditorPlugin

@export_category("Paramaters")

@export_category("References")

@export_category("Dependencies")

@onready var params: HelperParams = load("uid://b8tislf6yqhxx")

var dh_run_texture: Texture = load("uid://brkmpqbgmg80k")

var dock: EditorDock ##The configuration dock
var dock_scene: HelperDock

var toolbar_button: Button


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	dock_scene = preload("res://addons/development_helper/helper_dock.tscn").instantiate() as HelperDock
	
	dock = EditorDock.new()
	dock.add_child(dock_scene)
	
	dock.title = "DH"
	
	dock.default_slot = EditorDock.DOCK_SLOT_RIGHT_UL	
	
	add_dock(dock)
	dock_scene.run.connect(_on_run)
	dock_scene.plugin = self
	
	toolbar_button = Button.new()
	toolbar_button.icon = get_editor_interface().get_base_control().get_theme_icon("Play", "EditorIcons")
	toolbar_button.text = "DH"
	toolbar_button.focus_mode = Control.FOCUS_NONE
	toolbar_button.flat = true
	toolbar_button.pressed.connect(_on_run)
	add_control_to_container(CONTAINER_TOOLBAR, toolbar_button)

	
	


func _exit_tree() -> void:
	dock_scene.run.disconnect(_on_run)
	remove_dock(dock)
	dock.queue_free()
	if toolbar_button:
		remove_control_from_container(CONTAINER_TOOLBAR, toolbar_button)
		toolbar_button.queue_free()



func _on_run() -> void:
	var editor_interface: EditorInterface = get_editor_interface()
	var root = editor_interface.get_edited_scene_root()
	var scene_to_load: String = dock_scene.scene_path_line_edit.text
	if scene_to_load == "": scene_to_load = "res://stages/_dev_stage/dev_stage.tscn"
	params.scene_to_load = scene_to_load
	editor_interface.play_custom_scene("res://addons/development_helper/dev.tscn")

func get_current_opened_scene() -> String:
	var editor_interface: EditorInterface = get_editor_interface()
	return editor_interface.get_edited_scene_root().scene_file_path
