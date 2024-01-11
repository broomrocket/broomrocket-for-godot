class_name BroomrocketClientToServerMessage extends BroomrocketMessage

static var SERIALZIER = OneOfSerializer.new(
	"type",
	false,
	{
		BroomrocketMessage.Type.request: BroomrocketClientRequest.SERIALIZER,
		BroomrocketMessage.Type.response: BroomrocketServerResponse.SERIALIZER
	}
)
