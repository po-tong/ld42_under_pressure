# Hammer.gd
extends KinematicBody2D

signal hammer_hit(hit_position)

const MIN_SPEED = 30
const MAX_SPEED = 100
const ENGLISH_FACTOR = 20 # plus/minus 10, we will do a shift on the randf later

var speed_x = 60
var speed_y = 80
var motion = Vector2()
var direction = Vector2(1, 1)

func _ready():
	randomize()
	speed_x = (randf() * (MAX_SPEED - MIN_SPEED)) + MIN_SPEED
	if randf() >= 0.5:
		speed_x = -speed_x
	speed_y = (randf() * (MAX_SPEED - MIN_SPEED)) + MIN_SPEED
	if randf() <= 0.5:
		speed_y = -speed_y
	

func _physics_process(delta):
	
	motion.x = direction.x * speed_x * delta	
	motion.y = direction.y * speed_y * delta
	var move_result = move_and_collide(motion)
	if (move_result):
		var my_position = get_position()
		
		var quadrant_hit = move_result.position - get_position()
		var correction = Vector2(0, 0)
		# a little correction on the hit detection, the safety margin was causing
		# the hammer to hit the block before, this correction makes sure it looks a lil further ahead
		# this should probably be a vector with const magnitude with angle adjusted based on hit position
		# but this works well enough for now
		if (quadrant_hit.x > 0):
			correction.x += 2
		elif (quadrant_hit.x < 0):
			correction.x -= 2
			
		if (quadrant_hit.y > 0):
			correction.y += 2
		elif (quadrant_hit.y < 0):
			correction.y -= 2
		
		emit_signal("hammer_hit", move_result.position + correction)
		# bouncing off wall after hit
		if move_result.normal.x != 0:
			direction.x = -direction.x
		if move_result.normal.y != 0:
			direction.y = -direction.y
			
		#and we give it a lil "english"
		var english_x = (randf() * ENGLISH_FACTOR) - (ENGLISH_FACTOR / 2)
		var english_y = (randf() * ENGLISH_FACTOR) - (ENGLISH_FACTOR / 2)
		
		speed_x += english_x
		speed_y += english_y
		
		# and clamp the speed, in case it gets out of hand
		if speed_x > MAX_SPEED or speed_x < MIN_SPEED:
			speed_x = (MAX_SPEED + MIN_SPEED) / 2
		if speed_y > MAX_SPEED or speed_y < MIN_SPEED:
			speed_y = (MAX_SPEED + MIN_SPEED) / 2