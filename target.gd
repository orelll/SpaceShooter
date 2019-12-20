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

func _on_screen_exited():
	direction.x = direction.x * -1
	direction.y = direction.y * -1
	print('exited screen! Direction: ' + str(direction))

	
func update_screen_size():
	screen_size = get_viewport().size
	
func _physics_process(delta):
	update_screen_size()
	
	if OS.get_time().second % 2 == 0 and !angleChanged:
		changeAngle()
		angleChanged = true
	if OS.get_time().second % 2 == 1:
		angleChanged = false
	ProcessVelocity()
#	velocity = Vector2(0,0)
	#print('processing target ' + str(velocity))
	var collision = move_and_collide(velocity)
	
	if collision != null:
		changeAngle()


func ProcessVelocity():
	velocity = Vector2(sin(angle) * movementSpeed * movementSpeedMultiplier * direction.x, cos(angle) * movementSpeed * movementSpeedMultiplier * direction.y).rotated(rotation)

func changeAngle():
	angle = rng.randi_range(0, 360)

func _on_Notifier_viewport_exited(viewport):
	_on_screen_exited()


func _on_Health_value_changed(value):
	print('health changed to: ' + str(value))
	if $Health.value <= 0:
		var player = find_node_by_name(get_tree().get_root(), "Player")
		player.spawn_target()
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