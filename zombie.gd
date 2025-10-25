extends CharacterBody2D

@export var speed := 100
@export var attack_range := 50
@export var player: CharacterBody2D
@export var cooldown := 0.8

var is_animating_attack := false
var can_attack := true

func die() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if not player:
		$AnimatedSprite2D.play("idle")
		return
	var dx = player.global_position.x - global_position.x
	var h_distance = abs(dx)
	var dir_x := 0.0
	if h_distance > 0.0:
		dir_x = dx / h_distance
	if not is_animating_attack:
		if h_distance > attack_range:
			velocity.x = dir_x * speed
			$AnimatedSprite2D.play("walk")
		elif h_distance <= attack_range and can_attack:
			velocity = Vector2.ZERO
			attack()
		else:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("idle")
	else:
		velocity = Vector2.ZERO
	velocity.y = 0
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		if player:
			$AnimatedSprite2D.flip_h = (player.global_position.x - global_position.x) < 0
	move_and_slide()

func attack() -> void:
	is_animating_attack = true
	can_attack = false
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	is_animating_attack = false
	await get_tree().create_timer(cooldown).timeout
	can_attack = true
