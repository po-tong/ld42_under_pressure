# DamagedWall.gd
extends Node2D

export (PackedScene) var DuctTape

enum {NOT_DAMAGED, LIGHTLY_DAMAGED, HEAVILY_DAMAGED, SEVERELY_DAMAGED, BROKEN}

const NORMAL_DECAY_RATE = 5
const SEVERE_DECAY_RATE = 2
const DECAY_CHANCE = 0.30
const TICK_RATE = 1.5

var is_duct_taped = false
var condition = LIGHTLY_DAMAGED
var damage = 0
var grid_id = Vector2()
var is_selected = false
var has_selected_signal = false
var seconds_passed = 0

signal decay_duct_tape
signal update_wall_state(damaged_wall)
signal wall_broke(damaged_wall)
signal wall_repaired(damaged_wall)

func _ready():
	$Sparks.restart()
	$CrackingSound.play()
	randomize()

func _process(delta):
#	$_debug_seconds_passed.text = str(seconds_passed)
#	$_debug_damage.text = str(damage)
	seconds_passed += delta
	is_selected = false
	if has_selected_signal:
		is_selected = true
		has_selected_signal = false
		
	$SelectedSprite.visible = is_selected

	if seconds_passed >= TICK_RATE:
		process_decay()
		seconds_passed = 0

func process_decay():
	var initial_condition = condition
	if condition == LIGHTLY_DAMAGED or condition == HEAVILY_DAMAGED:
		# lightly and heavily damaged walls decay randomly
		if !is_duct_taped:
			if randf() < DECAY_CHANCE:
				damage += NORMAL_DECAY_RATE
		else:
			if randf() < (DECAY_CHANCE * 2):
				emit_signal("decay_duct_tape")
				
	elif condition == SEVERELY_DAMAGED:
		# severe damaged walls decay everytime
		if !is_duct_taped:
			damage += SEVERE_DECAY_RATE
		else:
			emit_signal("decay_duct_tape")
	
	if damage >= 100:
		self.emit_signal("wall_broke", self)
		queue_free()
		condition = BROKEN
	elif damage >= 80:
		condition = SEVERELY_DAMAGED
	elif damage >= 40:
		condition = HEAVILY_DAMAGED
	elif damage >= 20:
		condition = LIGHTLY_DAMAGED
		
	if condition > initial_condition:
		$Sparks.emitting = true
		
	emit_signal("update_wall_state", self)
	
func apply_duct_tape():
	$DuctTapeSprite.visible = true
	seconds_passed = 0
	var duct_tape = DuctTape.instance()
	add_child(duct_tape)
	connect("decay_duct_tape", duct_tape, "apply_decay")
	duct_tape.connect("duct_tape_expired", self, "remove_duct_tape")
	duct_tape.set_remaining_time()
	is_duct_taped = true
	
	
func apply_cement():
	emit_signal("wall_repaired", self)
	queue_free()
	
func remove_duct_tape(duct_tape):
	$DuctTapeSprite.visible = false
	is_duct_taped = false
	remove_child(duct_tape)
	
	
func get_condition():
	return condition
	
func set_grid_position(grid_position):
	grid_id = grid_position
	
func get_grid_position():
	return grid_id

func set_world_position(world_position):
	position = world_position


func _on_Area2D_player_apply_cement():
	apply_cement()
	

func _on_Area2D_player_apply_duct_tape():
	apply_duct_tape()
	

func _on_Area2D_wall_selected():
	has_selected_signal = true
