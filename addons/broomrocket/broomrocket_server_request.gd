class_name BroomrocketServerRequest extends BroomrocketServerToClientMessage

enum Command{list_objects,load_gltf}

static var SERIALIZER = ObjectSerializer.new(
	"BroomrocketServerRequest",
	BroomrocketServerRequest,
	{
		"id": StringSerializer.new(),
		"data": BroomrocketServerRequestData.SERIALIZER
	}
)
