@tool
class_name BroomrocketClient
extends RefCounted

var _engine: AbstractBroomrocketEngine

func _init(engine: AbstractBroomrocketEngine):
	_engine = engine
	_gltf_loaded.connect(_on_gltf_loaded)

signal _gltf_loaded
var _last_load_gltf_response: BroomrocketLoadGLTFClientResponseData

func _on_gltf_loaded(resp: BroomrocketLoadGLTFClientResponseData):
	_last_load_gltf_response = resp

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
	var i := 0
	while stream.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		print("Connecting...")
		OS.delay_msec(50)
		stream.poll()
		i+=1
		# Max 3 seconds
		if i > 60:
			return Result.new(
				null,
				Error.new(
					ERR_CONNECTION_ERROR,
					"Connection timed out."
				)
			)
		
	if stream.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		return Result.new(
			null,
			Error.new(
				ERR_CONNECTION_ERROR,
				"Stream is not connected (%d)."%stream.get_status()
			)
		)
	print("Connected.")

	var initialRequest = BroomrocketClientRequest.new("1", req)
	var serializedRequest = BroomrocketProtocol.CLIENT_TO_SERVER_MESSAGE.serialize(initialRequest)
	if !serializedRequest.is_ok():
		return Result.new(
			null,
			serializedRequest.error
		)
	var payload = JSON.stringify(serializedRequest.value).to_utf8_buffer()
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(4)
	packet.encode_s32(0, len(payload))
	packet.append_array(payload)
	var errcode = stream.put_data(packet)
	if errcode != OK:
		return Result.new(
				null,
				Error.new(
					ERR_CONNECTION_ERROR,
					"Failed to send request (%d)."%errcode
				)
			)
	
	while true:
		print("Reading packet...")
		var header_data := stream.get_data(4)
		if header_data[0] != OK:
			return Result.new(
				null,
				Error.new(
					header_data[0],
					"Failed to read header (%d)."%header_data[0]
				)
			)
		var header_data_bytes: PackedByteArray = header_data[1]
		var header = header_data_bytes.decode_s32(0)
		if header <= 0:
			return Result.new(
				null,
				Error.new(
					ERR_CONNECTION_ERROR,
					"Invalid header data received (%d)."%header
				)
			)
		print("Header received, reading %d bytes..."%header)
		var msg_payload = stream.get_data(header)
		var msg_err = msg_payload[0]
		if msg_err != OK:
			return Result.new(
				null,
				Error.new(
					msg_err,
					"Failed to receive %d bytes (code: %d)."%[header, msg_err]
				)
			)
		var msg_payload_data = msg_payload[1]
		var data = JSON.parse_string(msg_payload_data.get_string_from_utf8())
		var unserialized = BroomrocketProtocol.SERVER_TO_CLIENT_MESSAGE.unserialize(data)
		if !unserialized.is_ok():
			return Result.new(
				null,
				unserialized.error
			)
		var msg: BroomrocketServerToClientMessage = unserialized.get_value()
		if is_instance_of(msg, BroomrocketServerResponse):
			print("Received response.")
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
			var response = BroomrocketClientResponse.new()
			match server_request.data.command:
				BroomrocketServerRequest.Command.load_gltf:
					print("Received GLTF load request...")
					var req_data: BroomrocketLoadGLTFServerRequestData = server_request.data
					_engine.load_gltf(req_data, _gltf_loaded)
					await _gltf_loaded
					response.data = _last_load_gltf_response
					print("GLTF loaded.")
				BroomrocketServerRequest.Command.list_objects:
					print("Received mesh list request...")
					var req_data: BroomrocketListObjectsServerRequestData = server_request.data
					response.data = _engine.list_objects(req_data)
					print("Meshes listed.")
				BroomrocketServerRequest.Command.move_mesh:
					print("Received mesh move request...")
					var req_data: BroomrocketMoveMeshServerRequestData = server_request.data
					response.data = _engine.move_mesh(req_data)
					print("Mesh moved.")
			response.id = server_request.id
			var serialized = BroomrocketProtocol.CLIENT_TO_SERVER_MESSAGE.serialize(response)
			if serialized.is_error():
				return Result.new(
					null,
					serialized.error
				)
			var stream_data = JSON.stringify(serialized.value).to_utf8_buffer()
			var buf: PackedByteArray = PackedByteArray()
			buf.resize(4)
			buf.encode_s32(0, len(stream_data))
			buf.append_array(stream_data)
			print("Sending %d bytes..."%[stream_data.size()])
			errcode = stream.put_data(buf)
			if errcode != OK:
				return Result.new(
					null,
					Error.new(
						errcode,
						"Failed to send packet (%d)"%errcode
					)
				)
			print("Packet sent.")
	# This will never happen but is needed to stop Godot from complaining.
	return Result.new(
		null,
		null
	)

class Result extends ErrorReturn:
	func get_value() -> BroomrocketClientResponseData:
		return value
