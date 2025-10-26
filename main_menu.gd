extends Node2D


func _ready() -> void:
	$CanvasLayer/AnimatedSprite2D.play("idle")


func _on_play_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Main.tscn")
