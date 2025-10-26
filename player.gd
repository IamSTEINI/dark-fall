extends CharacterBody2D

@export var speed := 200
@export var jump_velocity := -400
@export var wave: int = 1
var dead = false
@export var kills = 0

func die() -> void:
	if dead:
		return
	dead = true
	$CollisionShape2D.disabled = true
	$CanvasLayer/text.text = "You died!"
	$Defeat.play()
	await $Defeat.finished
	$Defeat.stop()
	
	get_tree().reload_current_scene()

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
	
	if !dead:
		$CanvasLayer/text.text = "Wave "+str(wave)
	
	$CanvasLayer/kills.text = str(kills)+" Kills"
	
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
	$CanvasLayer/left.text = str(self.get_parent().get_node("Zombies").get_child_count()) + "/"+str(wave)+" left"
	move_and_slide()
