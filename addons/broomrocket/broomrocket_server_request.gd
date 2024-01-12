@tool
class_name BroomrocketServerRequest extends BroomrocketServerToClientMessage

var data: BroomrocketServerRequestData

enum Command{list_objects,load_gltf,move_mesh}
