# DuctTapeReady.gd
extends Sprite


func _on_HUD_update_duct_tape_cooldown(time_left):
	if time_left <= 0:
		time_left = 0
		$CooldownMask.visible = false
	
	$CooldownMask.visible = true
	$CooldownMask.scale.y = time_left