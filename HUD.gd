extends CanvasLayer

signal update_duct_tape_cooldown(time_left)
signal update_cement_cooldown(time_left)


var score = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$ScoreTimer.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_ScoreTimer_timeout():
	score += 1
	$ScoreLabel.text = "Time: " + str(score)
	pass # replace with function body

