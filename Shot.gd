extends KinematicBody2D

var speed = 400;
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
	#move_and_collide(velocity * delta)
	#velocity = move_and_slide(velocity)
	if position.x > screen_size.x or position.y > screen_size.y or position.x < -screen_size.x or position.y  < -screen_size.y:
		print('position:', position)
		$AnimatedSprite.play("explosion")
		get_parent().remove_child(self)