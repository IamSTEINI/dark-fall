extends RichTextLabel

var speed := 0.03
var original := ""
var index := 0
var typing := false

func _ready():
	original = text
	text = ""
	start()

func start():
	$"../../Typewriter".play()
	typing = true
	index = 0
	retype()

func retype():
	if not typing:
		return
	if index < original.length():
		text += original[index]
		index += 1
		if get_tree() != null:
			await get_tree().create_timer(speed).timeout
		retype()
	else:
		$"../../Typewriter".stop()
		$"../Play".show()
		$"../AnimatedSprite2D".show()
