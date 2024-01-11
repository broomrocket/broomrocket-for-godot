class_name BroomrocketServerRequestData extends RefCounted

var command: BroomrocketServerRequest.Command

static var SERIALIZER = OneOfSerializer.new(
	"command",
	true,
	{
		BroomrocketServerRequest.Command.list_objects: BroomrocketListObjectsServerRequestData.CHILD_SERIALIZER,
		BroomrocketServerRequest.Command.load_gltf: BroomrocketLoadGLTFServerRequestData.CHILD_SERIALIZER
	}
)
