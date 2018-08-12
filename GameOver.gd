# GameOver.gd
extends CanvasLayer

func _ready():
	var final_score = global.score
	var score_text = "You were trapped for " + str(final_score) + " second"
	if final_score > 1:
		score_text += "s"
	$VBoxContainer/FinalScoreLabel2.text = score_text


func _on_RestartButton_pressed():
	get_tree().change_scene("res://Ship.tscn")


func _on_ExitButon_pressed():
	get_tree().quit()