class_name BroomrocketLocalMeshProviderClientRequestData extends BroomrocketClientRequestData

var mesh_provider_parameters: BroomrocketLocalMeshProviderParameters

static var CHILD_SERIALIZER = ObjectSerializer.new(
	"BroomrocketLocalMeshProviderClientRequestData",
	BroomrocketLocalMeshProviderClientRequestData,
	{
		"mesh_provider_id": EnumSerializer.new(
			BroomrocketMeshProvider.ID,
		),
		"mesh_provider_parameters": BroomrocketLocalMeshProviderParameters.SERIALIZER,
		"sentence": StringSerializer.new()
	}
)
