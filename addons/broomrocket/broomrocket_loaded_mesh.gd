@tool
class_name BroomrocketLoadedMesh extends RefCounted

var name: String
var volume: BroomrocketVolume
var translation: BroomrocketCoordinate

func _init(new_name: String = "", new_volume: BroomrocketVolume = null, new_translation: BroomrocketCoordinate = null):
	name = new_name
	volume = new_volume
	translation = new_translation
