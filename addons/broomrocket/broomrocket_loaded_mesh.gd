class_name BroomrocketLoadedMesh extends RefCounted

var name: String
var volume: BroomrocketVolume
var translation: BroomrocketCoordinate

func _init(new_name: String, new_volume: BroomrocketVolume, new_translation: BroomrocketCoordinate):
	name = new_name
	volume = new_volume
	translation = new_translation

static var SERIALIZER = ObjectSerializer.new(
	"BroomrocketLoadedMesh",
	BroomrocketLoadedMesh,
	{
		"name": StringSerializer.new(),
		"volume": BroomrocketVolume.SERIALIZER,
		"translation": BroomrocketCoordinate.SERIALIZER
	}
)
