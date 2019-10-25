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
	#move_and_collide(velocity * delta)
	#velocity = move_and_slide(velocity)
	if position.x > screen_size.x or position.y > screen_size.y or position.x < -screen_size.x or position.y  < -screen_size.y:
		$AnimatedSprite.play("explosion")
		get_parent().remove_child(self)

func _on_Shot2_area_entered(area):
	if area.get_name() == 'Obstacle':
		velocity = Vector2(0,0)
		$AnimatedSprite.play("explosion")
		yield($AnimatedSprite, "animation_finished" )
		get_parent().remove_child(self)
		
	pass # Replace with function body.
