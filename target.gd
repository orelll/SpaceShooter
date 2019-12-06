extends KinematicBody2D

export var movementSpeed = 1
var movementSpeedMultiplier = 10

var rng = RandomNumberGenerator.new()
var angle 
var angleChanged = false
var direction = Vector2(1,1)
var screen_size = Vector2(500,500)
var newX
var newY

func _ready():
	$Health.value = 100
	#screen_size = get_viewport().size
	newY = rng.randi_range(0, screen_size.x)
	newX = rng.randi_range(0, screen_size.y)
	changeAngle()
	show()
	$AnimatedSprite.play("default")
	
func _physics_process(delta):
	#screen_size = get_tree().root.size
	
	if OS.get_time().second % 10 == 0 and !angleChanged:
		changeAngle()
		angleChanged = true
	if OS.get_time().second % 10 == 1:
		angleChanged = false
	
	
	newX = (position.x + 1)
	newY = (position.y + 1)
	#newX = clamp(newX, 0, screen_size.x)
	#newY = rng.randi_range(position.y -10, position.y + 10) * movementSpeed * movementSpeedMultiplier
	#newY = clamp(newX, 0, screen_size.x)
	var newPosition = Vector2(newX, newY).rotated(angle)# Vector2(0, 0)
	
	var collision = move_and_collide(newPosition)
	print('moving to position:' + str(newPosition))	
	print('current position: ' + str(position))
	if collision != null:
		changeAngle()
		if collision.collider.name == 'Shot':
			GotHit(collision.collider)
			
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func changeAngle():
	angle = rng.randi_range(0, 360)
	print('setting  angle to:' + str(angle))

func GotHit(area):
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