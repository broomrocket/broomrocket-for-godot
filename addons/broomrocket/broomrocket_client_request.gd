class_name BroomrocketClientRequest extends BroomrocketClientToServerMessage

var data: BroomrocketClientRequestData

func _init(_data: BroomrocketClientRequestData = null):
	self.data = _data

static var SERIALIZER = ObjectSerializer.new(
	"BroomrocketClientRequest",
	BroomrocketClientRequest,
	{
		"id": StringSerializer.new(),
		"data": BroomrocketClientRequestData.SERIALIZER
	}
)

