class_name BroomrocketDummyMeshProviderClientRequestData extends BroomrocketClientRequestData

var mesh_provider_parameters: BroomrocketDummyMeshProviderParameters

static var CHILD_SERIALIZER = ObjectSerializer.new(
	"BroomrocketDummyMeshProviderClientRequestData",
	BroomrocketDummyMeshProviderClientRequestData,
	{
		"mesh_provider_id": EnumSerializer.new(
			BroomrocketMeshProvider.ID,
		),
		"mesh_provider_parameters": BroomrocketDummyMeshProviderParameters.SERIALIZER,
		"sentence": StringSerializer.new()
	}
)
