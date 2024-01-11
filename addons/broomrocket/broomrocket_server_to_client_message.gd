class_name BroomrocketServerToClientMessage extends BroomrocketMessage

static var SERIALZIER = OneOfSerializer.new(
	"type",
	false,
	{
		BroomrocketMessage.Type.request: BroomrocketServerRequest.SERIALIZER,
		BroomrocketMessage.Type.response: BroomrocketClientResponse.SERIALIZER
	}
)
