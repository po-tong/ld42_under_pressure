# Player.gd
extends KinematicBody2D

const ACCELERATION = 50
const MAX_SPEED = 200
const DUCT_TAPE_COOLDOWN = 0.4
const CEMENT_COOLDOWN = 3

var motion = Vector2()
var cement_clock = 0
var duct_tape_clock = 0
var adjacent_block
var moving = false

signal game_over(final_score)

func _process(delta):
	if cement_clock >= 0:
		cement_clock -= delta
		
	if duct_tape_clock >= 0:
		duct_tape_clock -= delta

	$HUD.emit_signal("update_cement_cooldown", cement_clock/CEMENT_COOLDOWN)
	$HUD.emit_signal("update_duct_tape_cooldown", duct_tape_clock/DUCT_TAPE_COOLDOWN)
	

func _physics_process(delta):
	var collider	
	$RayCast2D.cast_to = get_local_mouse_position().normalized() * 50
	if $RayCast2D.is_colliding():
		collider = $RayCast2D.get_collider()

	if collider:
		collider.emit_signal("wall_selected")
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and duct_tape_clock <= 0:
			apply_duct_tape(collider)
		if Input.is_mouse_button_pressed(BUTTON_RIGHT) and cement_clock <= 0:
			apply_cement(collider)
	
	
	moving = false
	if Input.is_action_pressed("player_move_right"):
		moving = true
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$AnimatedSprite.flip_h = false
		if !Input.is_action_pressed("player_move_down") && !Input.is_action_pressed("player_move_up"):
			$AnimatedSprite.play("walk_h")

	elif Input.is_action_pressed("player_move_left"):
		moving = true
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$AnimatedSprite.flip_h = true
		if !Input.is_action_pressed("player_move_down") && !Input.is_action_pressed("player_move_up"):
			$AnimatedSprite.play("walk_h")
		
	if Input.is_action_pressed("player_move_down"):
		moving = true
		motion.y = min(motion.y+ACCELERATION, MAX_SPEED)
		$AnimatedSprite.play("walk_down")
	elif Input.is_action_pressed("player_move_up"):
		moving = true
		motion.y = max(motion.y-ACCELERATION, -MAX_SPEED)
		$AnimatedSprite.play("walk_up")

	if !moving:
		$AnimatedSprite.play("idle")
		
	motion.x = lerp(motion.x, 0, 0.2)
	motion.y = lerp(motion.y, 0, 0.2)
	
	motion = move_and_slide(motion)
	
	
func apply_duct_tape(target):
	duct_tape_clock = DUCT_TAPE_COOLDOWN
	$DuctTapeSound.play()
	target.emit_signal("player_apply_duct_tape")

	
func apply_cement(target):
	cement_clock = CEMENT_COOLDOWN
	$CementSound.play()
	target.emit_signal("player_apply_cement")

func game_over():
	global.score = $HUD.score
