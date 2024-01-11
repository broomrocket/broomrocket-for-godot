class_name BroomrocketLoadGLTFClientResponseData extends RefCounted

var object: BroomrocketLoadedMesh

static var CHILD_SERIALIZER = ObjectSerializer.new(
	"BroomrocketLoadGLTFClientResponseData",
	BroomrocketLoadGLTFClientResponseData,
	{
		"object": BroomrocketLoadedMesh.SERIALIZER
	}
)
