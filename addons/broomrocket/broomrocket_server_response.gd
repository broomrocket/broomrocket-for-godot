class_name BroomrocketServerResponse extends BroomrocketServerToClientMessage

var data: BroomrocketServerResponseData

static var SERIALIZER = ObjectSerializer.new(
	"BroomrocketServerResponse",
	BroomrocketServerResponse,
	{
		"id": StringSerializer.new(),
		"data": BroomrocketServerResponseData.SERIALIZER
	}
)
