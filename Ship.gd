# Ship.gd
extends Node

export (PackedScene) var DamagedWall
enum {TILE_WALL, TILE_WALL_BREAKING_LIGHT, TILE_WALL_BREAKING_HEAVY, TILE_WALL_BREAKING_SEVERE, TILE_FLOOR, TILE_DOOR}

const TICK_RATE = 2

var dying_walls = {}
var second_passed = 0

signal decay_walls

func _process(delta):
	second_passed += delta
	# var clean_up_these_wall = []
	# var neighboring_walls = []
#	if (second_passed > TICK_RATE):
#		for damaged_wall in dying_walls:
#			emit_signal("decay_walls")
			
#		second_passed = 0

#	for item in neighboring_walls:
#		if !has_floor_around(item):
#			remove_wall(item)
#			clean_up_these_wall.append(item)
#	
#	for item in clean_up_these_wall:
#		dying_walls.erase(item)

	# set hammer to the player position if it's out of bound
	if $TileMap.get_cellv($TileMap.world_to_map($Hammer.position)) != TILE_FLOOR:
		$Hammer.position = $Player.position
	

func _on_TileMap_wall_collapsed():
	var play_grid_position = $TileMap.world_to_map($Player.position)
	var tile_player_standing_on = $TileMap.get_cellv(play_grid_position)
	
	if tile_player_standing_on == 0:
		if $TileMap.get_cellv(play_grid_position + Vector2(1, 0)) == TILE_FLOOR:
			$Player.position = $TileMap.map_to_world(play_grid_position + Vector2(1, 0))
		elif $TileMap.get_cellv(play_grid_position + Vector2(-1, 0)) == TILE_FLOOR:
			$Player.position = $TileMap.map_to_world(play_grid_position + Vector2(-1, 0))
		elif $TileMap.get_cellv(play_grid_position + Vector2(0, 1)) == TILE_FLOOR:
			$Player.position = $TileMap.map_to_world(play_grid_position + Vector2(0, 1))
		elif $TileMap.get_cellv(play_grid_position + Vector2(0, -1)) == TILE_FLOOR:
			$Player.position = $TileMap.map_to_world(play_grid_position + Vector2(0, -1))
		else:
			$Player.game_over()
			get_tree().change_scene("res://GameOver.tscn")

func _on_Hammer_hammer_hit(hit_position):
	var grid_position = $TileMap.world_to_map(hit_position)
	if !dying_walls.has(grid_position):
		var damaged_wall = DamagedWall.instance()
		damaged_wall.set_grid_position(grid_position)
		damaged_wall.set_world_position($TileMap.map_to_world(grid_position))
		connect("decay_walls", damaged_wall, "process_decay")
		damaged_wall.connect("wall_broke", self, "collapse_wall")
		damaged_wall.connect("update_wall_state", self, "update_wall")
		damaged_wall.connect("wall_repaired", self, "repair_wall")
		dying_walls[grid_position] = damaged_wall
		add_child(damaged_wall)


func repair_wall(damaged_wall):
	$TileMap.set_cellv(damaged_wall.get_grid_position(), TILE_WALL)
	if dying_walls.has(damaged_wall.get_grid_position()):
		dying_walls.erase(damaged_wall.get_grid_position())
		

func update_wall(damaged_wall):
	$TileMap.set_cellv(damaged_wall.get_grid_position(), damaged_wall.condition)


func collapse_wall(broken_wall):
	$TileMap.collapse_wall(broken_wall.get_grid_position())