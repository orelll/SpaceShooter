extends KinematicBody2D

signal _hit
export var speed = 400
export (int) var HP = 100
export (int) var XP = 100
export (float) var rotation_speed = 1
var _velocity = Vector2()
var _rotation_dir = 0
var _readyToShot = 1
var _rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	get_tree().set_auto_accept_quit(false)
	hide()
	start(get_tree().get_root().get_viewport().size/2)
	set_background()
	set_GUI()
	spawn_target()

func get_save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"xp" : XP,
		"hp" : HP
	}
	return save_dict

func set_background():
	var found = load("res://background.tscn")
	var backgroundDuplicate = found.instance()
	var root = get_tree().get_root()
	root.call_deferred("add_child", backgroundDuplicate)

func set_GUI():
	var found = load("res://GUI.tscn")
	var guiDuplicate = found.instance()

	
	find_node_by_name(self, "CanvasLayer").call_deferred("add_child", guiDuplicate)

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
	var found = load("res://shot.tscn")
	var shotDuplicate = found.instance()
	shotDuplicate.position = position
	shotDuplicate.rotation = rotation
	var root  = get_tree().get_root()
	root.add_child(shotDuplicate)
	shotDuplicate.show()

func spawn_target():
	var target_position_X = _rng.randi_range(100, 250)
	var target_position_Y = _rng.randi_range(100, 250)
	
	target_position_X += position.x
	target_position_Y += position.y
	
	var root  = get_tree().get_root()
	var viewport_size = root.get_viewport().size
	target_position_X = clamp(target_position_X, 0, viewport_size.x)
	target_position_Y = clamp(target_position_Y, 0, viewport_size.y)
		
	var targetPrefab = load("res://target.tscn")
	var targetInstance = targetPrefab.instance()
	targetInstance.get_node("target").position = Vector2(target_position_X, target_position_Y)
	
	root.call_deferred("add_child",targetInstance) 
	targetInstance.show()
	
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
