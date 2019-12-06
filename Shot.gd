extends KinematicBody2D

export var startRotation = Vector2()
export var damage = 10
signal hit
var speed = 700;
var velocity
var screen_size

func _ready():
	rotation = get_parent().rotation/2
	screen_size = get_tree().root.size
	$AnimatedSprite.play("default")
	velocity = Vector2(cos(rotation) * -speed, sin(rotation) * -speed).rotated(rotation)

func _physics_process(delta):
	if position.x >= screen_size.x or position.y >= screen_size.y or position.x <= -screen_size.x or position.y  <= -screen_size.y:
		$AnimatedSprite.play("explosion")
		yield($AnimatedSprite, "animation_finished" )
		get_parent().queue_free()
	else:
		var collision = move_and_collide(velocity*delta)
		if collision != null:
			hitSomething(collision.collider)

func hitSomething(area):
	if area.get_name() == 'target':
		$AnimatedSprite.play("explosion")
		yield($AnimatedSprite, "animation_finished" )
		velocity = Vector2(0,0)
		get_parent().queue_free()
		
