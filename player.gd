extends CharacterBody2D

@export var speed := 200
@export var jump_velocity := -400
var jumps_left := 2

func die() -> void:
	pass

func _physics_process(delta: float) -> void:
	var input_dir := 0
	if not Input.is_action_pressed("sneak") and not Input.is_action_pressed("sleep"):
		if Input.is_action_pressed("walk_left"):
			input_dir -= 1
		if Input.is_action_pressed("walk_right"):
			input_dir += 1

	velocity.x = input_dir * speed

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_pressed("sneak"):
		$AnimatedSprite2D.play("sneak")
		$Foodsteps.stop()
	elif Input.is_action_pressed("sleep"):
		$AnimatedSprite2D.play("sleep")
		$Foodsteps.stop()
	elif velocity.y != 0:
		$AnimatedSprite2D.play("jump")
		$Foodsteps.stop()
	elif velocity.x != 0:
		$AnimatedSprite2D.play("walk")
		if is_on_floor() and not $Foodsteps.playing:
			$Foodsteps.play()
	else:
		$AnimatedSprite2D.play("idle")
		$Foodsteps.stop()

	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

	velocity.y += 1000 * delta
	move_and_slide()
