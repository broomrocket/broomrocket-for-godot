@tool
extends Control

@export
var text_field: LineEdit
@export
var send_button: Button

func _ready():
	text_field.text_submitted.connect(_on_submit)
	send_button.pressed.connect(_on_submit)

func _on_submit():
	text_field.editable = false
	send_button.disabled = true
