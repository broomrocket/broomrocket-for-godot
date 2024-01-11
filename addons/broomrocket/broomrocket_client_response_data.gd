class_name BroomrocketClientResponseData extends RefCounted
static var SERIALIZER = OneOfSerializer.new(
	"command",
	false,
	{
		BroomrocketServerRequest.Command.list_objects: BroomrocketListObjectsClientResponseData.CHILD_SERIALIZER,
		BroomrocketServerRequest.Command.load_gltf: BroomrocketLoadGLTFClientResponseData.CHILD_SERIALIZER
	}
)
