extends CharacterBody3D

var player = null
const SPEED = 4.0
@export var player_path: NodePath
@onready var nav_agent = $NavigationAgent3D
var health = 5
var state_machine

func _ready():
	player = get_node(player_path)

func _process(delta):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	rotation.y = lerp_angle(rotation.y, atan2(-velocity.x * -50, -velocity.z), delta * 10.0)
	move_and_slide()
	
func _on_area_3d_body_part_hit(dam):
	health -= dam
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://endscreen.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
