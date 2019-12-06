extends KinematicBody2D

export var startRotation = Vector2()
export var damage = 10
signal hit
var speed = 700;
var velocity
var screen_size

func _ready():
	rotation = get_parent().rotation
	screen_size = get_tree().root.size
	$AnimatedSprite.play("default")
	velocity = Vector2(cos(rotation) * -speed, sin(rotation) * -speed).rotated(rotation)
	print('rotation: ' + str(rotation))
	print('velocity: ' + str(velocity))

func _physics_process(delta):
	if position.x >= screen_size.x or position.y >= screen_size.y or position.x <= -screen_size.x or position.y  <= -screen_size.y:
		velocity = Vector2(0,0)
		$AnimatedSprite.play("explosion")
		yield($AnimatedSprite, "animation_finished" )
		get_parent().queue_free()
	else:
		
		var collision = move_and_collide(velocity*delta)
		if collision != null:
			hitSomething(collision.collider)

func hitSomething(area):
	print(area.name)
	if area.get_name() == 'target':
		velocity = Vector2(0,0)
		$AnimatedSprite.play("explosion")
		yield($AnimatedSprite, "animation_finished" )
		get_parent().queue_free()
		
