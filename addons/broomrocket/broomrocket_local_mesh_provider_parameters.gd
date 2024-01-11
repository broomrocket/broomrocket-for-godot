class_name BroomrocketLocalMeshProviderParameters extends RefCounted

var root: String

static var SERIALIZER = ObjectSerializer.new(
	"BroomrocketLocalMeshProviderParameters",
	BroomrocketLocalMeshProviderParameters,
	{
		"root": StringSerializer.new()
	}
)
