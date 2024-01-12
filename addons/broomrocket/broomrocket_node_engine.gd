@tool
class_name BroomrocketNodeEngine extends AbstractBroomrocketEngine

var node: Node

func _init(new_node: Node):
	node = new_node

func load_gltf(request: BroomrocketLoadGLTFServerRequestData, callback: Signal) -> void:
	_load_gltf.call_deferred(request, callback)

func _load_gltf(request: BroomrocketLoadGLTFServerRequestData, callback: Signal):
	var doc := GLTFDocument.new()
	var state := GLTFState.new()
	var gltf_data = request.gltf.files[request.gltf.gltf_file]
	print("Appending from buffer...")
	var err = doc.append_from_buffer(gltf_data, "", state)
	if err != OK:
		return
	var scene = doc.generate_scene(state)
	scene.name = request.gltf.gltf_file
	node.add_child(scene)
	_convert_imported_scene(scene)
	_set_owner(scene)
	var loaded_mesh = _get_loaded_mesh(scene)
	callback.emit(BroomrocketLoadGLTFClientResponseData.new(loaded_mesh))

func _convert_imported_scene(scene: Node):
	scene.visible = true
	if is_instance_of(scene, ImporterMeshInstance3D):
		var new_scene = MeshInstance3D.new()
		new_scene.mesh = scene.mesh.get_mesh()
		new_scene.skin = scene.skin
		new_scene.name = scene.name
		scene.replace_by(new_scene, true)
	for child in scene.get_children():
		_convert_imported_scene(child)
	
func _set_owner(scene):
	scene.set_owner(node)
	for child in scene.get_children():
		_set_owner(child)

func list_objects(request: BroomrocketListObjectsServerRequestData) -> BroomrocketListObjectsClientResponseData:
	var result: Array = []
	for child in node.get_children():
		if is_instance_of(child, Node3D):
			result.append(_get_loaded_mesh(child))
	return BroomrocketListObjectsClientResponseData.new(
		result
	)

func move_mesh(request: BroomrocketMoveMeshServerRequestData) -> BroomrocketMoveMeshClientResponseData:
	var child = node.find_child(request.name)
	if is_instance_of(child, Node3D):
		var child3d:Node3D = child
		child3d.global_position.x = request.translation.x
		child3d.global_position.y = request.translation.y
		child3d.global_position.z = request.translation.z
		return BroomrocketMoveMeshClientResponseData.new(
			_get_loaded_mesh(child3d)
		)
	return BroomrocketMoveMeshClientResponseData.new(
		null
	)

func _get_loaded_mesh(node: Node3D) -> BroomrocketLoadedMesh:
	return BroomrocketLoadedMesh.new(
		node.name,
		_get_volume(node),
		BroomrocketCoordinate.new(node.global_position.x, node.global_position.y, node.global_position.z)
	)

func _get_volume(node: Node) -> BroomrocketVolume:
	var min_x: float = INF
	var max_x: float = -INF
	var min_y: float = INF
	var max_y: float = -INF
	var min_z: float = INF
	var max_z: float = -INF
	for child in node.get_children(true):
		var volume = _get_volume(child)
		if volume.min_x < min_x:
			min_x = volume.min_x
		if volume.max_x > max_x:
			max_x = volume.max_x
		if volume.min_y < min_y:
			min_y = volume.min_y
		if volume.max_y > max_y:
			max_y = volume.max_y
		if volume.min_z < min_z:
			min_z = volume.min_z
		if volume.max_z > max_z:
			max_z = volume.max_z
	if is_instance_of(node, MeshInstance3D):
		var mesh_instance: MeshInstance3D = node
		var aabb := mesh_instance.mesh.get_aabb()
		var base_position = mesh_instance.global_position
		var mesh_min_x = base_position.x + aabb.position.x
		var mesh_min_y = base_position.y + aabb.position.y
		var mesh_min_z = base_position.z + aabb.position.z
		var mesh_max_x = base_position.x + aabb.position.x + aabb.size.x
		var mesh_max_y = base_position.y + aabb.position.y + aabb.size.y
		var mesh_max_z = base_position.z + aabb.position.z + aabb.size.z
		if mesh_min_x < min_x:
			min_x = mesh_min_x
		if mesh_max_x > max_x:
			max_x = mesh_max_x
		if mesh_min_y < min_y:
			min_y = mesh_min_y
		if mesh_max_y > max_y:
			max_y = mesh_max_y
		if mesh_min_z < min_z:
			min_z = mesh_min_z
		if mesh_max_z > max_z:
			max_z = mesh_max_z
	return BroomrocketVolume.new(
		min_x,
		max_x,
		min_y,
		max_y,
		min_z,
		max_z
	)
