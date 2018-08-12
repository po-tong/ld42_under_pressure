extends TileMap

enum {WALL_HIT, WALL_BREAKING_LIGHT, WALL_BREAKING_HEAVY, WALL_BREAKING_SEVERE, WALL_BROKEN}
enum {TILE_WALL, TILE_WALL_BREAKING_LIGHT, TILE_WALL_BREAKING_HEAVY, TILE_WALL_BREAKING_SEVERE, TILE_FLOOR, TILE_DOOR}

const RATE_OF_DECAY = 2
const DECAY_STEP = 1
const CHANGE_TO_DEGRADE = 1

var dying_walls = {}
var second_passed = 0

signal wall_collapsed


func collapse_wall(wall_position):
	var neighboring_walls = []
	
	for x in [wall_position.x-1, wall_position.x, wall_position.x+1]:
		for y in [wall_position.y-1, wall_position.y, wall_position.y+1]:	
			var tile_type = get_cell(x, y)
			if tile_type == TILE_FLOOR:
				set_cell(x, y, TILE_WALL)
			elif tile_type == TILE_WALL:
				neighboring_walls.append(Vector2(x, y))
			
	remove_wall(wall_position)
	emit_signal("wall_collapsed")
	
	return neighboring_walls


func get_neighboring_walls(wall_position):
	var neighboring_walls = []
	for x in [wall_position.x-1, wall_position.x, wall_position.x+1]:
		for y in [wall_position.y-1, wall_position.y, wall_position.y+1]:	
			if get_cell(x, y) == TILE_WALL:
				neighboring_walls.append(Vector2(x, y))
				
	return neighboring_walls
	


func has_floor_around(wall_position):
	var has_floor = false
	for x in [wall_position.x-1, wall_position.x, wall_position.x+1]:
		for y in [wall_position.y-1, wall_position.y, wall_position.y+1]:	
			if get_cell(x, y) == TILE_FLOOR:
				has_floor = true
	return has_floor


func remove_wall(wall_position):
	set_cellv(wall_position, -1)
	
