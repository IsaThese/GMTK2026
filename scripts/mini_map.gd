extends TileMapLayer

@export var ZoneNode: Node2D = null
@export var PlayerNode: Node2D = null
@export var SourceID: int = 1

@onready var PlayerSprite: Sprite2D = $MiniPlayer
var SourceMap: TileMapLayer = null
var SourceMapTopLeft: Vector2i = Vector2i.ZERO


func _ready() -> void:
	if PlayerNode == null and PlayerSprite != null:
		PlayerSprite.visible = false
	
	if ZoneNode:
		for child in ZoneNode.get_children():
			if child is TileMapLayer:
				SourceMap = child
				SourceMapTopLeft = SourceMap.get_used_rect().position
				for coords in SourceMap.get_used_cells():
					set_cell(coords - SourceMapTopLeft, SourceID, SourceMap.get_cell_atlas_coords(coords))
				return
	push_warning("Minimap", self, "does not have a valid zone")


func _process(_delta: float) -> void:
	if SourceMap and PlayerNode and PlayerSprite:
		var player_coords = SourceMap.to_local(PlayerNode.global_position)
		var local_player_coords = ((player_coords / Vector2(SourceMap.tile_set.tile_size)) - Vector2(SourceMapTopLeft)) * Vector2(tile_set.tile_size)
		PlayerSprite.position = local_player_coords
