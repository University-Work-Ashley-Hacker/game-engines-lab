@tool
extends EditorPlugin

var dock: EditorDock ##The configuration dock
var dock_scene: SceneBuilderDock

var spawn_2d_shortcut: Shortcut
var spawn_3d_shortcut: Shortcut

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	var key_2d: InputEventKey = InputEventKey.new()
	key_2d.keycode = KEY_2
	key_2d.alt_pressed = true
	key_2d.shift_pressed = true # Ctrl on Windows/Linux, Cmd on macOS
	
	spawn_2d_shortcut = Shortcut.new()
	spawn_2d_shortcut.events = [key_2d]
	
	var key_3d: InputEventKey = InputEventKey.new()
	key_3d.keycode = KEY_3
	key_3d.alt_pressed = true
	key_3d.shift_pressed = true # Ctrl on Windows/Linux, Cmd on macOS
	
	spawn_3d_shortcut = Shortcut.new()
	spawn_3d_shortcut.events = [key_3d]


func _shortcut_input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo() and spawn_2d_shortcut.matches_event(event):
		_create_nodes(false)
		get_viewport().set_input_as_handled()
	elif event.is_pressed() and not event.is_echo() and spawn_3d_shortcut.matches_event(event):
		_create_nodes(true)
		get_viewport().set_input_as_handled()


func _exit_tree() -> void:
	pass



func _build_group_3d() -> Node3D:
	var root: Node3D = Node3D.new()
	root.name = "Actor"

	var visuals: Node3D = Node3D.new()
	visuals.name = "Visuals"
	root.add_child(visuals)

	var collision: Node3D = Node3D.new()
	collision.name = "Body"
	root.add_child(collision)

	var management: Node = Node.new()
	management.name = "Management"
	root.add_child(management)

	return root

func _collect_descendants(node: Node, out: Array[Node]) -> void:
	for child: Node in node.get_children():
		out.append(child)
		_collect_descendants(child, out)

func _on_3D_pressed() -> void:
	_create_nodes(true)


func _on_2D_pressed() -> void:
	_create_nodes(false)

func _create_nodes(threeD: bool = false) -> void:
	var selected: Array[Node] = EditorInterface.get_selection().get_selected_nodes()
	var scene_root: Node = EditorInterface.get_edited_scene_root()
	if selected.is_empty() or scene_root == null:
		push_warning("Select a node in the scene tree first.")
		return
	
	var new_root
	
	var parent: Node = selected[0]
	if threeD: new_root = _build_group_3d()
	else: new_root = _build_group_2d()

	var all_nodes: Array[Node] = [new_root]
	_collect_descendants(new_root, all_nodes)

	var undo_redo: EditorUndoRedoManager = get_undo_redo()
	undo_redo.create_action("Spawn Group", UndoRedo.MERGE_DISABLE, scene_root)
	undo_redo.add_do_method(parent, "add_child", new_root, true)
	for n: Node in all_nodes:
		undo_redo.add_do_method(n, "set_owner", scene_root)
	undo_redo.add_do_reference(new_root)
	undo_redo.add_undo_method(parent, "remove_child", new_root)
	undo_redo.commit_action()

func _build_group_2d() -> Node2D:
	var root: Node2D = Node2D.new()
	root.name = "Actor"

	var visuals: Node2D = Node2D.new()
	visuals.name = "Visuals"
	root.add_child(visuals)

	var collision: Node2D = Node2D.new()
	collision.name = "Body"
	root.add_child(collision)

	var management: Node = Node.new()
	management.name = "Management"
	root.add_child(management)

	return root
