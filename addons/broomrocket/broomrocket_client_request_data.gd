class_name BroomrocketClientRequestData extends RefCounted

var mesh_provider_id: BroomrocketMeshProvider.ID
var sentence: String

static var SERIALIZER = OneOfSerializer.new(
	"mesh_provider_id",
	false,
	{
		BroomrocketMeshProvider.ID.dummy: BroomrocketDummyMeshProviderClientRequestData.CHILD_SERIALIZER,
		BroomrocketMeshProvider.ID.local: BroomrocketLocalMeshProviderClientRequestData.CHILD_SERIALIZER
	}
)
