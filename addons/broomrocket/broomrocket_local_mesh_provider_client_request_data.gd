@tool
class_name BroomrocketLocalMeshProviderClientRequestData extends BroomrocketClientRequestData

var mesh_provider_parameters: BroomrocketLocalMeshProviderParameters

func _init(
	new_mesh_provider_parameters: BroomrocketLocalMeshProviderParameters = null,
	new_sentence: String = ""
):
	mesh_provider_parameters = new_mesh_provider_parameters
	sentence = new_sentence

