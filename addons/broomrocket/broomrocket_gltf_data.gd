class_name BroomrocketGLTFData extends RefCounted
	
var files: Dictionary
var gltf_file: String
var license_file: String

func _init(new_files: Dictionary = {}, new_gltf_file: String = "", new_license_file: String = ""):
	files = new_files
	gltf_file = new_gltf_file
	license_file = new_license_file

static var SERIALIZER = ObjectSerializer.new(
	"BroomrocketGLTFData",
	BroomrocketGLTFData,
	{
		"files": DictionarySerializer.new(
			StringSerializer.new(),
			BinarySerializer.new(BinarySerializer.Base64ContentEncoder.new())
		),
		"gltf_file": StringSerializer.new(),
		"license_file": OptionalSerializer.new(StringSerializer.new())
	}
)
