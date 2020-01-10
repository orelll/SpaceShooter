extends KinematicBody2D

export var startRotation = Vector2()
export var damage = 10
signal hit
var speed = 700;
var velocity
var screen_size
var exploded = false

func _ready():
	screen_size = get_tree().root.size
	rotation = rotation / 2
	velocity = Vector2(cos(rotation) * -speed, sin(rotation) * -speed).rotated(rotation)
	
	$AnimatedSprite.play("start")
	yield($AnimatedSprite, "animation_finished" )
	$AnimatedSprite.play("move")

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision != null  and !exploded:
		hitSomething(collision.collider)

func hitSomething(collider):
	velocity = Vector2(0,0)
	if collider.get_name() == 'target':
		
		var targetHealth = collider.get_node("Health")
		targetHealth.value -= damage
			
	exploded = true
	$AnimatedSprite.play("explosion")
	yield($AnimatedSprite, "animation_finished" )
	get_parent().remove_child(self)

func find_node_by_name(root, name):
	if(root.get_name() == name): 
		return root
	
	for child in root.get_children():
		if(child.get_name() == name):
			return child

		var found = find_node_by_name(child, name)
		if(found): 
			return found

	return null

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()