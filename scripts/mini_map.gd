@tool

extends PanelContainer

@export var zone_node: Node2D = null
@export var player_node: Node2D = null
@export var target_node: Node2D = null
@export var source_id: int = 1

@export var map_size: Vector2 = Vector2.ZERO
var map_total_size: Vector2
var border_offset: Vector2 = Vector2.ZERO

@onready var player_sprite: Sprite2D = $MiniPlayer
@onready var target_sprite: Sprite2D = $MiniTarget
@onready var target_anim: AnimationPlayer = $TargetAnimationPlayer
@onready var dest_map: TileMapLayer = $MapBorder/Layer
var source_map: TileMapLayer = null
var source_map_top_left: Vector2i = Vector2i.ZERO


func _ready() -> void:
	var stylebox = get_theme_stylebox("panel") as StyleBoxFlat
	if stylebox != null:
		size = map_size + Vector2(stylebox.border_width_left + stylebox.border_width_right, stylebox.border_width_top + stylebox.border_width_bottom)
		border_offset = Vector2(stylebox.border_width_left, stylebox.border_width_top)

	if not Engine.is_editor_hint():
		if player_node == null and player_sprite != null:
			player_sprite.visible = false
		
		if target_node == null and target_sprite != null:
			target_sprite.visible = false
	
	if zone_node:
		update_minimap()
		return
	push_warning("Minimap", self, "does not have a valid zone")


func update_minimap():
	dest_map.clear()
	for child in zone_node.get_children():
		if child is TileMapLayer:
			source_map = child
			print_debug("Minimap from zone with area ", source_map.get_used_rect())
			map_total_size = source_map.get_used_rect().size * dest_map.tile_set.tile_size
			source_map_top_left = source_map.get_used_rect().position
			for coords in source_map.get_used_cells():
				dest_map.set_cell(coords - source_map_top_left, source_id, source_map.get_cell_atlas_coords(coords))


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not source_map:
		return

	# Adjust map offset based on player position
	if player_node:
		var max_rect = Rect2(Vector2.ZERO, map_total_size)
		var center = _get_mininode_position(player_node.global_position)
		var centered_rect = Rect2(center - map_size / 2, map_size)
		if not max_rect.encloses(centered_rect):
			if centered_rect.position.x < max_rect.position.x:
				centered_rect.position.x = max_rect.position.x
			elif centered_rect.end.x > max_rect.end.x:
				centered_rect.position.x += (max_rect.end.x - centered_rect.end.x)
			if centered_rect.position.y < max_rect.position.y:
				centered_rect.position.y = max_rect.position.y
			elif centered_rect.end.y > max_rect.end.y:
				centered_rect.position.y += (max_rect.end.y - centered_rect.end.y)
		dest_map.position = - centered_rect.position
	
	# Show player on minimap
	if player_node and player_sprite:
		player_sprite.position = _get_mininode_position(player_node.global_position) + dest_map.position + border_offset
	
	# Show target on minimap
	if target_node and target_sprite:
		var target_position = _get_mininode_position(target_node.global_position) + dest_map.position
		if Rect2(Vector2.ZERO, map_size).has_point(target_position):
			target_sprite.position = target_position + border_offset
			target_sprite.rotation = 0
			target_anim.play("bobbing")
		else:
			# If target is outside of shown area, show little arrow based on poi->target vector
			var poi = _get_mininode_position(player_node.global_position) + dest_map.position if player_node else map_size / 2
			var poi_vec = target_position - poi
			target_sprite.rotation = Vector2.DOWN.angle_to(poi_vec)
			if (-poi_vec.x) > poi.x:
				poi_vec *= (poi.x) / (-poi_vec.x)
			elif poi_vec.x > (map_size.x - poi.x):
				poi_vec *= (map_size.x - poi.x) / poi_vec.x
			if (-poi_vec.y) > poi.y:
				poi_vec *= (poi.y) / (-poi_vec.y)
			elif poi_vec.y > (map_size.y - poi.y):
				poi_vec *= (map_size.y - poi.y) / poi_vec.y
			target_sprite.position = poi + poi_vec + border_offset
			target_anim.play("RESET")


func _get_mininode_position(global_pos: Vector2):
	var source_coords = source_map.to_local(global_pos)
	return ((source_coords / Vector2(source_map.tile_set.tile_size)) - Vector2(source_map_top_left)) * Vector2(dest_map.tile_set.tile_size)
