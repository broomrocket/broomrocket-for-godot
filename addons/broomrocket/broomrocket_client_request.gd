@tool
class_name BroomrocketClientRequest extends BroomrocketClientToServerMessage

var data: BroomrocketClientRequestData

func _init(new_id: String = "", new_data: BroomrocketClientRequestData = null):
	self.data = new_data
	self.id = new_id


