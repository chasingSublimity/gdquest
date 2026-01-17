extends Control

@onready var next_button: Button = %NextButton
@onready var rich_text_label: RichTextLabel = %RichTextLabel

var dialogue_items : Array[String] = [
	"Roses are red",
	"Violets are blue",
	"This code is shite",
	"And so are you!"
]

var current_item_index := 0

func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

func advance() -> void:
	current_item_index += 1
	if current_item_index > dialogue_items.size() - 1:
		get_tree().quit()
	else:
		show_text()

func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item
