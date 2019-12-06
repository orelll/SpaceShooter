extends KinematicBody2D

export var movementSpeed = 1
var movementSpeedMultiplier = 10

var rng = RandomNumberGenerator.new()
var angle 
var angleChanged = false
var direction = Vector2(1,1)
var screen_size = Vector2(500,500)
var velocity = Vector2()

func _ready():
	show()
	$AnimatedSprite.play("default")
	
func _physics_process(delta):
	pass

	
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