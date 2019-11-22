extends Area2D

var speed = 600;
export var startRotation = Vector2()
var velocity = Vector2(-speed, 0).rotated(rotation)
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_tree().root.size#get_viewport().size
	$AnimatedSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	position += velocity * delta
	if position.x > screen_size.x or position.y > screen_size.y or position.x < -screen_size.x or position.y  < -screen_size.y:
		$AnimatedSprite.play("explosion")
		get_parent().remove_child(self)

func _on_Shot2_area_entered(area):
	if area.get_name() == 'target':
		velocity = Vector2(0,0)
		$AnimatedSprite.play("explosion")
		yield($AnimatedSprite, "animation_finished" )
		var target = find_node_by_name(get_tree().get_root(), "target")
		find_node_by_name(get_tree().get_root(), 'root').call_deferred("remove_child",target) 
		
		var player = find_node_by_name(get_tree().get_root(), "Player")
		player.spawn_target()
		get_parent().remove_child(self)

func find_node_by_name(root, name):

    if(root.get_name() == name): return root

    for child in root.get_children():
        if(child.get_name() == name):
            return child

        var found = find_node_by_name(child, name)

        if(found): return found

    return null
