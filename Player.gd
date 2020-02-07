extends KinematicBody2D

signal _hit
export var speed = 400
export (int) var hp = 0
export (int) var xp = 0
export (int) var energy = 0
export (int) var energy_max = 100
export (int) var energy_restore_speed = 1
export (float) var rotation_speed = 1
var recover_timer
var enabler_timer

var _gun_in_use = false
var _velocity = Vector2()
var _rotation_dir = 0
var _readyToShot = 1
var _rng = RandomNumberGenerator.new()

var _tools = Tools.new()

func _ready():
	
#	stwórz funkcję dla przygotowania enabler_timer
#	stwórz funkcję dla przygotowania recover_timer

	get_tree().set_auto_accept_quit(false)
	hide()
	start(_tools.viewport_size(self)/2)
	set_background()
	spawn_target()
	set_GUI()


func set_background():
	var found = _tools.load_scene("background")
	var backgroundDuplicate = found.instance()
	_tools.get_root(self).call_deferred("add_child", backgroundDuplicate)

func set_GUI():
	var found = load("res://GUI.tscn")
	var guiDuplicate = found.instance()
	var canvas = _tools.find_node_by_name(self, "CanvasLayer")
	canvas.call_deferred("add_child", guiDuplicate)

	
func start(pos):
	position = pos
	show()
	$HitBox.disabled = false
	
func get_input():
	var pressed = 0
	
	_velocity = Vector2()
	if Input.is_action_pressed('ui_down'):
		pressed = 1
		_velocity = Vector2(speed, 0).rotated(rotation)
		$ExhaustFront.play("move")
	else:
		$ExhaustFront.play("stop")
		
	if Input.is_action_pressed('ui_up'):
		pressed = 1
		_velocity = Vector2(-speed, 0).rotated(rotation)
		$Exhaust.play("move")
	else:
		$Exhaust.play("stop")
		
	if Input.is_action_pressed('ui_right'):
		$LowerMover.play("move")
		pressed = 1
		_rotation_dir += 0.1
	else:
		$LowerMover.play("stop")
		
	if Input.is_action_pressed('ui_left'):
		$UpperMover.play("move")
		pressed = 1
		_rotation_dir -= 0.1
	else:
		$UpperMover.play("stop")
	
	if Input.is_action_just_pressed('ui_accept') && _readyToShot == 1:
		shot()
		_readyToShot = 0
	if Input.is_action_just_released('ui_accept'):
		_readyToShot = 1
	if pressed == 0:
		if rotation > 0:
			_rotation_dir -= 0.1
		if _rotation_dir < 0:
			_rotation_dir += 0.1
		
	
func _physics_process(delta):
	get_input()
	rotation += _rotation_dir * rotation_speed * delta
	_velocity = move_and_slide(_velocity)
	
func shot():
#	ustaw _gun_in_use
#	zatrzymaj  timer. który?
	var found = _tools.load_scene("Shot")
	var shotDuplicate = found.instance()
	
#	sprawdź czy masz dość energii
	shotDuplicate.position = position
	shotDuplicate.rotation = rotation
	_tools.get_root(self).add_child(shotDuplicate)
	shotDuplicate.show()
	change_energy(-shotDuplicate.energy_cost)
		
#	uruchom zatrzymany timer

func spawn_target():
	var target_position_X = _rng.randi_range(100, 250)
	var target_position_Y = _rng.randi_range(100, 250)
	
	target_position_X += position.x
	target_position_Y += position.y
	
	var viewport_size = _tools.viewport_size(self)
	target_position_X = clamp(target_position_X, 0, viewport_size.x)
	target_position_Y = clamp(target_position_Y, 0, viewport_size.y)
	var _root = _tools.get_root(self)
		
	var targetPrefab = _tools.load_scene("target")
	var targetInstance = targetPrefab.instance()
	targetInstance.get_node("target").position = Vector2(target_position_X, target_position_Y)
	
	_root.call_deferred("add_child",targetInstance) 
	targetInstance.show()

func change_energy(delta, override = false):
#	sprawdź czy jest override, ustaw wartość i wywołaj value na danym gauge
	pass