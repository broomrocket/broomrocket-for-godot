class_name BroomrocketClientResponse extends BroomrocketClientToServerMessage

var data: BroomrocketClientResponseData

static var SERIALIZER = ObjectSerializer.new(
	"BroomrocketClientResponse",
	BroomrocketClientResponse,
	{
		"id": StringSerializer.new(),
		"data": BroomrocketClientResponseData.SERIALIZER
	}
)
