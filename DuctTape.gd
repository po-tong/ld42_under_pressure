# DuctTape.gd
extends Node

# buggie bug, for some reason it's decaying twice in one tick??
const DECAY_RATE = 1

var remaining_time = 1

signal duct_tape_expired(duct_tape)

func apply_decay():
	remaining_time -= DECAY_RATE
	if remaining_time <= 0:
		emit_signal("duct_tape_expired", self)
		queue_free()

func _on_DuctTape_tree_exited():
	queue_free()

func set_remaining_time():
	remaining_time = 1