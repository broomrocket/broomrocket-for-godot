class_name BroomrocketVolume extends RefCounted

var min_x: float
var max_x: float
var min_y: float
var max_y: float
var min_z: float
var max_z: float

func _init(
	new_min_x: float = 0.0,
	new_max_x: float = 0.0,
	new_min_y: float = 0.0,
	new_max_y: float = 0.0,
	new_min_z: float = 0.0,
	new_max_z: float = 0.0
):
	min_x = new_min_x
	max_x = new_max_x
	min_y = new_min_y
	max_y = new_max_y
	min_z = new_min_z
	max_z = new_max_z

static var SERIALIZER = ObjectSerializer.new(
	"BroomrocketVolume",
	BroomrocketVolume,
	{
		"min_x": FloatSerializer.new(),
		"max_x": FloatSerializer.new(),
		"min_y": FloatSerializer.new(),
		"max_y": FloatSerializer.new(),
		"min_z": FloatSerializer.new(),
		"max_z": FloatSerializer.new(),
	}
)
