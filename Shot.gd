extends KinematicBody2D

export var startRotation = Vector2()
export var damage = 10
signal hit
var _speed = 700;
var _velocity
var _exploded = false

var _tools = Tools.new()

func _ready():
	rotation = rotation / 2
	_velocity = Vector2(cos(rotation) * -_speed, sin(rotation) * -_speed).rotated(rotation)
	
	$AnimatedSprite.play("start")
	yield($AnimatedSprite, "animation_finished" )
	$AnimatedSprite.play("move")

func _physics_process(delta):
	var collision = move_and_collide(_velocity*delta)
	if collision != null  and !_exploded:
		hitSomething(collision.collider)

func hitSomething(collider):
	_velocity = Vector2(0,0)
	if collider.get_name() == 'target':
		
		var targetHealth = collider.get_node("Health")
		targetHealth.value -= damage
			
	_exploded = true
	$AnimatedSprite.play("explosion")
	yield($AnimatedSprite, "animation_finished" )
	get_parent().remove_child(self)

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()