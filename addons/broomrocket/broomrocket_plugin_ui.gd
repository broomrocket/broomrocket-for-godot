@tool
class_name BroomrocketPluginUI
extends Control

var sentenceField: LineEdit
var sendButton: Button
var tabs: TabContainer
var local_library_path: TextEdit

const providers = [BroomrocketMeshProvider.ID.dummy, BroomrocketMeshProvider.ID.local, BroomrocketMeshProvider.ID.sketchfab]
var provider: BroomrocketMeshProvider.ID = BroomrocketMeshProvider.ID.dummy
var sentence: String = ""
var local_path: String = ""
var base_node

func _ready():
	var vertical: VBoxContainer = VBoxContainer.new()
	add_child(vertical)
	vertical.layout_mode = 1 # LAYOUT_MODE_ANCHORS
	vertical.anchors_preset = PRESET_FULL_RECT
	
	var firstLine: HBoxContainer = HBoxContainer.new()
	vertical.add_child(firstLine)
	firstLine.layout_mode = 1 # LAYOUT_MODE_ANCHORS
	firstLine.anchors_preset = PRESET_TOP_WIDE
	
	var sentenceLabel: Label = Label.new()
	sentenceLabel.text = "Sentence:"
	firstLine.add_child(sentenceLabel)
	
	sentenceField = LineEdit.new()
	firstLine.add_child(sentenceField)
	sentenceField.size_flags_horizontal = SIZE_EXPAND_FILL
	sentenceField.placeholder_text = "Place a house"
	sentenceField.text_changed.connect(_on_sentence_changed)
	sentenceField.text_submitted.connect(_on_submit)
	
	sendButton = Button.new()
	firstLine.add_child(sendButton)
	sendButton.text = "Send"
	sendButton.pressed.connect(_on_submit)
	
	tabs = TabContainer.new()
	vertical.add_child(tabs)
	tabs.tab_changed.connect(_tab_changed)
	tabs.layout_mode = 1 # LAYOUT_MODE_ANCHORS
	tabs.anchors_preset = PRESET_FULL_RECT

	var dummy: VBoxContainer = VBoxContainer.new()
	tabs.add_child(dummy)
	dummy.layout_mode = 1 # LAYOUT_MODE_ANCHORS
	dummy.anchors_preset = PRESET_FULL_RECT
	dummy.name = "Dummy"
	
	var dummy_label := Label.new()
	dummy.add_child(dummy_label)
	dummy_label.text = "This provider has no options."
	
	var local: VBoxContainer = VBoxContainer.new()
	tabs.add_child(local)
	local.layout_mode = 1 # LAYOUT_MODE_ANCHORS
	local.anchors_preset = PRESET_FULL_RECT
	local.name = "Local"
	
	var local_line := HBoxContainer.new()
	local.add_child(local_line)
	local_line.layout_mode = 1 # LAYOUT_MODE_ANCHORS
	local_line.anchors_preset = PRESET_TOP_WIDE
	
	var local_line_label := Label.new()
	local_line.add_child(local_line_label)
	local_line_label.text = "Library path:"
	
	local_library_path = TextEdit.new()
	local_line.add_child(local_library_path)
	local_library_path.text_changed.connect(_on_local_path_change)
	local_library_path.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var sketchfab: VBoxContainer = VBoxContainer.new()
	tabs.add_child(sketchfab)
	sketchfab.layout_mode = 1 # LAYOUT_MODE_ANCHORS
	sketchfab.anchors_preset = PRESET_FULL_RECT
	sketchfab.name = "Sketchfab"

func _on_submit():
	print("Broomrocket processing sentence: %s"%[sentence])
	var client = BroomrocketClient.new(
		BroomrocketNodeEngine.new(
			get_tree().get_edited_scene_root()
		)
	)
	var req: BroomrocketClientRequestData
	match provider:
		BroomrocketMeshProvider.ID.dummy:
			req = BroomrocketDummyMeshProviderClientRequestData.new(
				sentence
			)
		BroomrocketMeshProvider.ID.local:
			req = BroomrocketLocalMeshProviderClientRequestData.new(
				BroomrocketLocalMeshProviderParameters.new(
					local_path
				),
				sentence
			)
	
	var result = await client.run(
		req
	)
	if result.is_error():
		printerr(result.error.message)
	else:
		print("Processing complete.")

func _on_sentence_changed(new_text: String) -> void:
	sentence = new_text

func _tab_changed(tab: int) -> void:
	provider = providers[tab]

func _on_local_path_change() -> void:
	local_path = local_library_path.text
