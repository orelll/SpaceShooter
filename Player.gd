extends KinematicBody2D

signal hit
export var speed = 400
export (float) var rotation_speed = 1
var screen_size
var velocity = Vector2()
var rotation_dir = 0
var readyToShot = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	hide()
	var pos = Vector2(screen_size.x / 2, screen_size.y / 2)
	start(pos)
	
func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
	
func get_input():
	var pressed = 0
    # Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()
	if Input.is_action_pressed('ui_down'):
		pressed = 1
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed('ui_up'):
		pressed = 1
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed('ui_right'):
		pressed = 1
		rotation_dir += 0.1
	if Input.is_action_pressed('ui_left'):
		pressed = 1
		rotation_dir -= 0.1
	
	if pressed == 0:
		if rotation_dir > 0:
			rotation_dir -= 0.1
		if rotation_dir < 0:
			rotation_dir += 0.1
	
func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
