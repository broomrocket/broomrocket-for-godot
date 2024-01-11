class_name BroomrocketLoadGLTFServerRequestData extends BroomrocketServerRequestData

var gltf: BroomrocketGLTFData

static var CHILD_SERIALIZER = ObjectSerializer.new(
	"BroomrocketLoadGLTFServerRequestData",
	BroomrocketLoadGLTFServerRequestData,
	{
		"command": EnumSerializer.new(BroomrocketServerRequest.Command),
		"gltf": BroomrocketGLTFData.SERIALIZER
	}
)
