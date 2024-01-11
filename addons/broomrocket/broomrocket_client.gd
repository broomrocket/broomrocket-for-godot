@tool
class_name BroomrocketClient
extends RefCounted

var _engine: BroomrocketEngine

func _init(engine: BroomrocketEngine):
	_engine = engine

func run(req: BroomrocketClientRequestData) -> Result:
	var stream = StreamPeerTCP.new()
	var result = stream.connect_to_host("127.0.0.1", 3333)
	if result != OK:
		return Result.new(
			null,
			Error.new(
				result,
				"Connection to Broomrocket server at 127.0.0.1:3333 failed."
			)
		)
	
	var initialRequest = BroomrocketClientRequest.new(req)
	var serializedRequest = BroomrocketClientRequest.SERIALIZER.serialize(initialRequest)
	if !serializedRequest.is_ok():
		return Result.new(
			null,
			serializedRequest.error
		)
	var payload = JSON.stringify(serializedRequest).to_utf8_buffer()
	stream.put_32(len(payload))
	stream.put_data(payload)
	
	while true:
		var header = stream.get_u32()
		var msg_payload = stream.get_data(header)
		var data = JSON.parse_string(msg_payload)
		var unserialized = BroomrocketServerToClientMessage.SERIALZIER.unserialize(data)
		if !unserialized.is_ok():
			return Result.new(
				null,
				unserialized.error
			)
		var msg: BroomrocketServerToClientMessage = unserialized.get_value()
		if is_instance_of(msg, BroomrocketServerResponse):
			var client_response: BroomrocketServerResponse = msg
			var err: Error = null
			var msg_data: BroomrocketServerResponseData = client_response.data
			if msg_data.status == BroomrocketServerResponseData.Status.error:
				err = Error.new(
					ERR_QUERY_FAILED,
					msg_data.message
				)
			return Result.new(
				msg.data,
				err
			)
		else:
			var server_request: BroomrocketServerRequest = msg
			var response = BroomrocketServerResponse.new()
			match server_request.data.command:
				BroomrocketServerRequest.Command.load_gltf:
					var req_data: BroomrocketLoadGLTFServerRequestData = server_request.data
					response.data = _engine.load_gltf(req_data)
				BroomrocketServerRequest.Command.list_objects:
					var req_data: BroomrocketListObjectsServerRequestData = server_request.data
					response.data = _engine.list_objects(req_data)
			var serialized = BroomrocketServerResponse.SERIALIZER.serialize(response)
			if serialized.is_error():
				return Result.new(
					null,
					serialized.error
				)
			var stream_data = serialized.value.to_utf8_buffer()
			stream.put_32(len(stream_data))
			stream.put_data(stream_data)
	# This will never happen but is needed to stop Godot from complaining.
	return Result.new(
		null,
		null
	)

class Result extends ErrorReturn:
	func get_value() -> BroomrocketClientResponseData:
		return value
