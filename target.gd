extends KinematicBody2D

export var movementSpeed = 1
var movementSpeedMultiplier = 2

var rng = RandomNumberGenerator.new()
var angle 
var angleChanged = false
var direction = Vector2(1,1)
var screen_size
var velocity = Vector2()

func _ready():
	update_screen_size()
	$Health.value = 100
	changeAngle()
	show()
	$AnimatedSprite.play("default")
	
func update_screen_size():
	screen_size = get_viewport().size
	
func _physics_process(delta):
	update_screen_size()
	
	if OS.get_time().second % 2 == 0 and !angleChanged:
		changeAngle()
		angleChanged = true
	if OS.get_time().second % 2 == 1:
		angleChanged = false

func ProcessVelocity():
	velocity = Vector2(sin(angle) * movementSpeed * movementSpeedMultiplier * direction.x, cos(angle) * movementSpeed * movementSpeedMultiplier * direction.y).rotated(rotation)

func changeAngle():
	angle = rng.randi_range(0, 360)

	
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