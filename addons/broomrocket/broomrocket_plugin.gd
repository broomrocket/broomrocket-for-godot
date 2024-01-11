@tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("broomrocket_plugin_ui.tscn").instantiate()
	add_control_to_bottom_panel(dock, "Broomrocket")

func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()
