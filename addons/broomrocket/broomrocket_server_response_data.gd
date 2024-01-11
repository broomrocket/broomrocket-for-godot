class_name BroomrocketServerResponseData extends RefCounted

var status: Status
var message: String

static var SERIALIZER = ObjectSerializer.new(
	"BroomrocketServerResponseData",
	BroomrocketServerResponseData,
	{
		"status": EnumSerializer.new(Status),
		"message": StringSerializer.new()
	}
)

enum Status{ok,error}
