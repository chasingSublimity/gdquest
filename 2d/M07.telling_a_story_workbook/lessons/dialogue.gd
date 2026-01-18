extends Control

@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var next_button: Button = %NextButton
@onready var rich_text_label: RichTextLabel = %RichTextLabel

var expressions: Dictionary[String, Resource] = {
	"happy": preload("res://assets/emotion_happy.png"),
	"regular": preload("res://assets/emotion_regular.png"),
	"sad": preload("res://assets/emotion_sad.png"),
}
var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions.regular,
		"text": "Roses are red",
	},
	{
		"expression": expressions.sad,
		"text": "Violets are blue",
	},
	{
		"expression": expressions.regular,
		"text": "This code is shite",
	},
	{
		"expression": expressions.happy,
		"text": "And so are you!",
	}
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
	var tween := create_tween()
	var current_item := dialogue_items[current_item_index]
	
	rich_text_label.visible_ratio = 0.0
	
	rich_text_label.text = current_item.text
	expression.texture = current_item.expression
	
	var text_appearing_duration := 1.2
	
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)

	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)
