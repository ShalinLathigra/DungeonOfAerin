extends Sprite

var base_size: Vector2;
func _ready():
	base_size = texture.get_size();
	if scale.x != 1:
		region_rect.size.x = base_size.x * scale.x;
		scale.x = 1;
	if scale.y != 1:
		region_rect.size.y = base_size.y * scale.y;
		scale.y = 1;
