extends KinematicBody2D

export var movementSpeed = 1
var movementSpeedMultiplier = 2

var _rng = RandomNumberGenerator.new()
var _angle 
var _angleChanged = false
var _direction = Vector2(1,1)
var _velocity = Vector2()
var player
var pointer
var _tools = Tools.new()

func _ready():
	pointer = _tools.find_node_by_name(_tools.get_root(self), "Pointer")
	$Health.value = 100
	changeAngle()
	show()
	$AnimatedSprite.play("default")
	pointer.z_index = 999
	pointer.visible = false
	
func _on_Notifier_viewport_exited(viewport):
	_direction.x = _direction.x * -1
	_direction.y = _direction.y * -1
	pointer.visible = true

func _on_Notifier_viewport_entered(viewport):
	pointer.visible = false

	
func _physics_process(delta):
	
	if OS.get_time().second % 2 == 0 and !_angleChanged:
		changeAngle()
		_angleChanged = true
		
	if OS.get_time().second % 2 == 1:
		_angleChanged = false
		
	Process_velocity()
#	
	var collision = move_and_collide(_velocity)
	
	if collision != null:
		changeAngle()
		
	process_pointer_position()

func Process_velocity():
	_velocity = Vector2(sin(_angle) * movementSpeed * movementSpeedMultiplier * _direction.x, cos(_angle) * movementSpeed * movementSpeedMultiplier * _direction.y).rotated(rotation)

func changeAngle():
	_angle = _rng.randi_range(0, 360)

func process_pointer_position():
	var player = _tools.get_player(self)
	if player.position == null:
		pass
	
	var _direction_vector = position - player.position
	pointer.position = player.position + _direction_vector.normalized() * Vector2(100,100)

func _on_Health_value_changed(value):
	if $Health.value <= 0:
		var player = _tools.find_node_by_name(_tools.get_root(self), _tools.get_player())
		player.spawn_target()
		get_parent().remove_child(self)