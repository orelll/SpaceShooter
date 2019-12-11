#extends AnimatedSprite
#
#func _ready():
#	get_tree().get_root().connect("size_changed", self, "on_resize")
#
#func on_resize():
#	var viewportWidth = get_viewport().size.x
#	var viewportHeight = get_viewport().size.y
#	var scale = viewportWidth / this.texture.get_size().x
#
#	$ParallaxBackground/ParallaxLayer/AnimatedSprite.set_position(Vector2(viewportWidth/2, viewportHeight/2))
#	$ParallaxBackground/ParallaxLayer/AnimatedSprite.set_scale(Vector2(scale, scale))
