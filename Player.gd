extends KinematicBody2D

signal hit
var root
export var speed = 400
export (float) var rotation_speed = 1
var screen_size
var velocity = Vector2()
var rotation_dir = 0
var readyToShot = 1
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	screen_size = get_viewport().size
	root = get_tree().get_root()
	hide()
	var pos = Vector2(screen_size.x / 2, screen_size.y / 2)
	start(pos)
	set_background()
	set_GUI()
	spawn_target()
	
func set_background():
	var found = load("res://background.tscn")
	var backgroundDuplicate = found.instance()
	root.call_deferred("add_child", backgroundDuplicate)

func set_GUI():
	var found = load("res://GUI.tscn")
	var guiDuplicate = found.instance()
	root.call_deferred("add_child", guiDuplicate)

func start(pos):
    position = pos
    show()
    $HitBox.disabled = false
	
func get_input():
	var pressed = 0
	
	velocity = Vector2()
	if Input.is_action_pressed('ui_down'):
		pressed = 1
		velocity = Vector2(speed, 0).rotated(rotation)
		$ExhaustFront.play("move")
	else:
		$ExhaustFront.play("stop")
		
	if Input.is_action_pressed('ui_up'):
		pressed = 1
		velocity = Vector2(-speed, 0).rotated(rotation)
		$Exhaust.play("move")
	else:
		$Exhaust.play("stop")
		
	if Input.is_action_pressed('ui_right'):
		$LowerMover.play("move")
		pressed = 1
		rotation_dir += 0.1
	else:
		$LowerMover.play("stop")
		
	if Input.is_action_pressed('ui_left'):
		$UpperMover.play("move")
		pressed = 1
		rotation_dir -= 0.1
	else:
		$UpperMover.play("stop")
	
	if Input.is_action_just_pressed('ui_accept') && readyToShot == 1:
		shot()
		readyToShot = 0
	if Input.is_action_just_released('ui_accept'):
		readyToShot = 1
	if pressed == 0:
		if rotation > 0:
			rotation_dir -= 0.1
		if rotation_dir < 0:
			rotation_dir += 0.1
		
	
func _physics_process(delta):
	screen_size = get_viewport().size
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
	
func shot():
	root = get_tree().get_root()
	var found = load("res://Shot.tscn")
	var shotDuplicate = found.instance()
	shotDuplicate.position = position
	shotDuplicate.rotation = rotation
	root.add_child(shotDuplicate)
	shotDuplicate.show()

func spawn_target():
	var target_position_X = rng.randi_range(100, 250)
	var target_position_Y = rng.randi_range(100, 250)
	
	target_position_X += position.x
	target_position_Y += position.y
	
	target_position_X= clamp(target_position_X, 0, screen_size.x)
	target_position_Y= clamp(target_position_Y, 0, screen_size.y)
	var root = get_tree().get_root()
		
	var targetPrefab = load("res://target.tscn")
	var targetInstance = targetPrefab.instance()
	targetInstance.get_node("target").position = Vector2(target_position_X, target_position_Y)
	
	root.call_deferred("add_child",targetInstance) 
	targetInstance.show()
	print(str(targetInstance.position))

