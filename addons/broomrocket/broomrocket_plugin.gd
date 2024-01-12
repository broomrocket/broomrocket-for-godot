@tool
extends EditorPlugin

var dock: BroomrocketPluginUI 

func _enter_tree():
	dock = BroomrocketPluginUI.new()
	add_control_to_bottom_panel(dock, "Broomrocket")

func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()
	dock = null
