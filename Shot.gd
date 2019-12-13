extends KinematicBody2D

export var startRotation = Vector2()
export var damage = 10
signal hit
var speed = 700;
var velocity
var screen_size

func _ready():
	screen_size = get_tree().root.size
	rotation = rotation / 2
	velocity = Vector2(cos(rotation) * -speed, sin(rotation) * -speed).rotated(rotation)
	
	$AnimatedSprite.play("start")
	yield($AnimatedSprite, "animation_finished" )
	$AnimatedSprite.play("move")

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision != null:
		hitSomething(collision.collider)

func hitSomething(area):
	if area.get_name() == 'target':
		velocity = Vector2(0,0)
		$AnimatedSprite.play("explosion")
		yield($AnimatedSprite, "animation_finished" )
		queue_free()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
