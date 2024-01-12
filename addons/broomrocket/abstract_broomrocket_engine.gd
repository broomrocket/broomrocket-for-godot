@tool
class_name AbstractBroomrocketEngine extends RefCounted

func load_gltf(request: BroomrocketLoadGLTFServerRequestData, callback: Signal) -> void:
	assert(false, "load_gltf not implemented")

func list_objects(request: BroomrocketListObjectsServerRequestData) -> BroomrocketListObjectsClientResponseData:
	assert(false, "list_objects not implemented")
	return null

func move_mesh(request: BroomrocketMoveMeshServerRequestData) -> BroomrocketMoveMeshClientResponseData:
	assert(false, "move_mesh not implemented")
	return null
