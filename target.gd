extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	show() # Replace with function body.
	$AnimatedSprite.play("default")


func _on_target_area_entered(area):
	pass
