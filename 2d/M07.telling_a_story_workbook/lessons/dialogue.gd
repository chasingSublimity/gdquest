extends Control

@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression
@onready var sophia_voice: AudioStreamPlayer = %SophiaVoice
@onready var pink_voice: AudioStreamPlayer = %PinkVoice
@onready var next_button: Button = %NextButton
@onready var rich_text_label: RichTextLabel = %RichTextLabel

var bodies := {
	"sophia": preload("res://assets/sophia.png"),
	"pink": preload("res://assets/pink.png")
}

var expressions: Dictionary[String, Resource] = {
	"happy": preload("res://assets/emotion_happy.png"),
	"regular": preload("res://assets/emotion_regular.png"),
	"sad": preload("res://assets/emotion_sad.png"),
}
var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions.regular,
		"text": "Roses are [wave]red[/wave]",
		"character_name": "sophia"
	},
	{
		"expression": expressions.sad,
		"text": "Violets are blue",
		"character_name": "pink"
	},
	{
		"expression": expressions.regular,
		"text": "This code is shite",
		"character_name": "sophia"
	},
	{
		"expression": expressions.happy,
		"text": "And so are you!",
		"character_name": "sophia"
	}
]

var speaking_voice: Dictionary[String, AudioStreamPlayer] = {
	"sophia": sophia_voice,
	"pink": pink_voice
	
}

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
	
	var character_name = current_item.character_name
	rich_text_label.text = current_item.text
	expression.texture = current_item.expression
	body.texture = bodies[character_name]
	
	
	var tween := create_tween()
	var text_appearing_duration: float = rich_text_label.get_parsed_text().length() / 30.0
	rich_text_label.visible_ratio = 0.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	
	var voice_player: AudioStreamPlayer = sophia_voice if character_name == "sophia" else pink_voice

	var sound_max_offset := voice_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	
	voice_player.play(sound_start_position)
	tween.finished.connect(voice_player.stop)
	
	# animate character appearance
	slide_in()
	
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
	)

func slide_in() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	
	body.position.x = 200.0
	tween.tween_property(body, "position:x", 0.0, 0.6)
	
	body.modulate.a = 0.0
	tween.parallel().tween_property(body, "modulate:a", 1.0, 0.4)
	
