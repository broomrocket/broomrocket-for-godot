class_name BroomrocketListObjectsClientResponseData extends RefCounted

var objects: Array

static var CHILD_SERIALIZER = ObjectSerializer.new(
	"BroomrocketListObjectsClientResponseData",
	BroomrocketListObjectsClientResponseData,
	{
		"objects": ArraySerializer.new(
			BroomrocketLoadedMesh.SERIALIZER
		)
	}
)
