@tool
class_name BroomrocketProtocol

static var VOLUME = ObjectSerializer.new(
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

static var COORDINATE = ObjectSerializer.new(
	"BroomrocketCoordinate",
	BroomrocketCoordinate,
	{
		"x": FloatSerializer.new(),
		"y": FloatSerializer.new(),
		"z": FloatSerializer.new()
	}
)

static var GLTF_DATA = ObjectSerializer.new(
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

static var LOADED_MESH = ObjectSerializer.new(
	"BroomrocketLoadedMesh",
	BroomrocketLoadedMesh,
	{
		"name": StringSerializer.new(),
		"volume": VOLUME,
		"translation": COORDINATE
	}
)

# region Client requests/responses

static var DUMMY_MESH_PROVIDER_PARAMETERS = ObjectSerializer.new(
	"BroomrocketDummyMeshProviderParameters",
	BroomrocketDummyMeshProviderParameters,
	{}
)

static var LOCAL_MESH_PROVIDER_PARAMETERS = ObjectSerializer.new(
	"BroomrocketLocalMeshProviderParameters",
	BroomrocketLocalMeshProviderParameters,
	{
		"root": StringSerializer.new()
	}
)

static var DUMMY_MESH_PROVIDER_CLIENT_REQUEST_DATA = ObjectSerializer.new(
	"BroomrocketDummyMeshProviderClientRequestData",
	BroomrocketDummyMeshProviderClientRequestData,
	{
		"mesh_provider_parameters": DUMMY_MESH_PROVIDER_PARAMETERS,
		"sentence": StringSerializer.new()
	}
)

static var LOCAL_MESH_PROVIDER_CLIENT_REQUEST_DATA = ObjectSerializer.new(
	"BroomrocketLocalMeshProviderClientRequestData",
	BroomrocketLocalMeshProviderClientRequestData,
	{
		"mesh_provider_parameters": LOCAL_MESH_PROVIDER_PARAMETERS,
		"sentence": StringSerializer.new()
	}
)


static var CLIENT_REQUEST_DATA = OneOfSerializer.new(
	"mesh_provider_id",
	EnumSerializer.new(BroomrocketMeshProvider.ID),
	false,
	{
		BroomrocketMeshProvider.ID.dummy: DUMMY_MESH_PROVIDER_CLIENT_REQUEST_DATA,
		BroomrocketMeshProvider.ID.local: LOCAL_MESH_PROVIDER_CLIENT_REQUEST_DATA
	}
)

static var CLIENT_REQUEST = ObjectSerializer.new(
	"BroomrocketClientRequest",
	BroomrocketClientRequest,
	{
		"id": StringSerializer.new(),
		"data": CLIENT_REQUEST_DATA
	}
)

static var LIST_OBJECTS_CLIENT_RESPONSE_DATA = ObjectSerializer.new(
	"BroomrocketListObjectsClientResponseData",
	BroomrocketListObjectsClientResponseData,
	{
		"objects": ArraySerializer.new(
			LOADED_MESH
		)
	}
)

static var LOAD_GLTF_CLIENT_RESPONSE_DATA = ObjectSerializer.new(
	"BroomrocketLoadGLTFClientResponseData",
	BroomrocketLoadGLTFClientResponseData,
	{
		"object": LOADED_MESH
	}
)

static var MOVE_MESH_CLIENT_RESPONSE_DATA = ObjectSerializer.new(
	"BroomrocketMoveMeshClientResponseData",
	BroomrocketMoveMeshClientResponseData,
	{
		"object": LOADED_MESH
	}
)

static var CLIENT_RESPONSE_DATA = OneOfSerializer.new(
	"command",
	EnumSerializer.new(BroomrocketServerRequest.Command),
	false,
	{
		BroomrocketServerRequest.Command.list_objects: LIST_OBJECTS_CLIENT_RESPONSE_DATA,
		BroomrocketServerRequest.Command.load_gltf: LOAD_GLTF_CLIENT_RESPONSE_DATA,
		BroomrocketServerRequest.Command.move_mesh: MOVE_MESH_CLIENT_RESPONSE_DATA
	}
)

static var CLIENT_RESPONSE = ObjectSerializer.new(
	"BroomrocketClientResponse",
	BroomrocketClientResponse,
	{
		"id": StringSerializer.new(),
		"data": CLIENT_RESPONSE_DATA
	}
)

# endregion

# region Server requests/responses

static var LIST_OBJECTS_SERVER_REQUEST_DATA = ObjectSerializer.new(
	"BroomrocketListObjectsServerRequestData",
	BroomrocketListObjectsServerRequestData,
	{
		"command": EnumSerializer.new(BroomrocketServerRequest.Command)
	}
)

static var LOAD_GLTF_SERVER_REQUEST_DATA = ObjectSerializer.new(
	"BroomrocketLoadGLTFServerRequestData",
	BroomrocketLoadGLTFServerRequestData,
	{
		"command": EnumSerializer.new(BroomrocketServerRequest.Command),
		"gltf": GLTF_DATA
	}
)

static var MOVE_MESH_SERVER_REQUEST_DATA = ObjectSerializer.new(
	"BroomrocketMoveMeshServerRequestData",
	BroomrocketMoveMeshServerRequestData,
	{
		"command": EnumSerializer.new(BroomrocketServerRequest.Command),
		"name": StringSerializer.new(),
		"translation": COORDINATE
	}
)

static var SERVER_REQUEST_DATA = OneOfSerializer.new(
	"command",
	EnumSerializer.new(BroomrocketServerRequest.Command),
	true,
	{
		BroomrocketServerRequest.Command.list_objects: LIST_OBJECTS_SERVER_REQUEST_DATA,
		BroomrocketServerRequest.Command.load_gltf: LOAD_GLTF_SERVER_REQUEST_DATA,
		BroomrocketServerRequest.Command.move_mesh: MOVE_MESH_SERVER_REQUEST_DATA
	}
)

static var SERVER_REQUEST = ObjectSerializer.new(
	"BroomrocketServerRequest",
	BroomrocketServerRequest,
	{
		"id": StringSerializer.new(),
		"data": SERVER_REQUEST_DATA
	}
)

static var SERVER_RESPONSE_DATA = ObjectSerializer.new(
	"BroomrocketServerResponseData",
	BroomrocketServerResponseData,
	{
		"status": EnumSerializer.new(BroomrocketServerResponseData.Status),
		"message": StringSerializer.new()
	}
)

static var SERVER_RESPONSE = ObjectSerializer.new(
	"BroomrocketServerResponse",
	BroomrocketServerResponse,
	{
		"id": StringSerializer.new(),
		"data": SERVER_RESPONSE_DATA
	}
)

# endregion

static var SERVER_TO_CLIENT_MESSAGE = OneOfSerializer.new(
	"type",
	EnumSerializer.new(BroomrocketMessage.Type),
	false,
	{
		BroomrocketMessage.Type.request: SERVER_REQUEST,
		BroomrocketMessage.Type.response: SERVER_RESPONSE
	}
)

static var CLIENT_TO_SERVER_MESSAGE = OneOfSerializer.new(
	"type",
	EnumSerializer.new(BroomrocketMessage.Type),
	false,
	{
		BroomrocketMessage.Type.request: CLIENT_REQUEST,
		BroomrocketMessage.Type.response: CLIENT_RESPONSE
	}
)
