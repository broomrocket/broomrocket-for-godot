class_name BroomrocketListObjectsServerRequestData extends BroomrocketServerRequestData

static var CHILD_SERIALIZER = ObjectSerializer.new(
	"BroomrocketListObjectsServerRequestData",
	BroomrocketListObjectsServerRequestData,
	{
		"command": EnumSerializer.new(BroomrocketServerRequest.Command)
	}
)
