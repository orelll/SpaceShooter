extends Area2D

var speed = 600;
export var startRotation = Vector2()
var velocity = Vector2(-speed, 0).rotated(rotation)
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_tree().root.size#get_viewport().size
	$AnimatedSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	position += velocity * delta
	if position.x > screen_size.x or position.y > screen_size.y or position.x < -screen_size.x or position.y  < -screen_size.y:
		$AnimatedSprite.play("explosion")
		yield($AnimatedSprite, "animation_finished" )
		queue_free()