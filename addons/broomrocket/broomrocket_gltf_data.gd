@tool
class_name BroomrocketGLTFData extends RefCounted
	
var files: Dictionary
var gltf_file: String
var license_file: String

func _init(new_files: Dictionary = {}, new_gltf_file: String = "", new_license_file: String = ""):
	files = new_files
	gltf_file = new_gltf_file
	license_file = new_license_file


