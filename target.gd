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
	$Health.value = 100
	changeAngle()
	show()
	$AnimatedSprite.play("default")
	
func _physics_process(delta):
	
	if OS.get_time().second % 2 == 0 and !angleChanged:
		changeAngle()
		angleChanged = true
	if OS.get_time().second % 2 == 1:
		angleChanged = false
	
	ProcessVelocity()
	
	var checkX = clamp(velocity.x, 0, screen_size.x)
	var checkY = clamp(velocity.y, 0, screen_size.y)
	
	if checkX != velocity.x:
		direction.x = direction.x * -1
		ProcessVelocity()
	
	if checkY != velocity.y:
		direction.y = direction.y * -1
		ProcessVelocity()
	
	var collision = move_and_collide(velocity)
	
	if collision != null:
		changeAngle()
		if collision.collider.name == 'Shot':
			GotHit(collision.collider)
			
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func ProcessVelocity():
	velocity = Vector2(sin(angle) * movementSpeed, cos(angle) * movementSpeed).rotated(rotation)

func changeAngle():
	angle = rng.randi_range(0, 360)
	print('setting  angle to:' + str(angle))

func GotHit(area):
	print('hit by ' + str(area.name))
	if $Health.value > area.damage:
		$Health.value -= area.damage
	else:
		var player = find_node_by_name(get_tree().get_root(), "Player")
		player.spawn_target()
		get_parent().queue_free()
	
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