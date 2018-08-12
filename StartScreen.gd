# StartScreen.gd
extends CanvasLayer


func _on_StartGame_pressed():
	get_tree().change_scene("res://Ship.tscn")
	

func _on_ExitGame_pressed():
	get_tree().quit()