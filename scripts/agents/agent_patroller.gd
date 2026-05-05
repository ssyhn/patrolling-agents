extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var is_selected = false
var patrol_points : Array[Vector2] = []
var target_idx = 0

func _physics_process(delta: float) -> void:
	if patrol_points.size() < 2:
		return
	if navigation_agent_2d.is_navigation_finished():
		target_idx = 1 - target_idx
		navigation_agent_2d.target_position = patrol_points[target_idx]
	var next = navigation_agent_2d.get_next_path_position()
	var dir = (next - global_position).normalized()
	velocity = dir * 100
	move_and_slide()
	navigation_agent_2d.velocity = velocity

func set_destination(pos: Vector2):
	patrol_points.append(pos)
	if patrol_points.size() > 2: # if there are existing patrol points, clear the array
		patrol_points = [pos] 
		target_idx = 0
	if patrol_points.size() == 2:
		navigation_agent_2d.target_position = patrol_points[0]

func set_selected(value: bool):
	is_selected = value
	$SelectionHighlight.visible = value
