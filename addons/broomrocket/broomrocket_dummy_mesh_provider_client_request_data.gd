@tool
class_name BroomrocketDummyMeshProviderClientRequestData extends BroomrocketClientRequestData

var mesh_provider_parameters: BroomrocketDummyMeshProviderParameters

func _init(
	new_sentence: String = ""
):
	mesh_provider_parameters = BroomrocketDummyMeshProviderParameters.new()
	sentence = new_sentence
