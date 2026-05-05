extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var is_selected = false

func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return
	var next = navigation_agent_2d.get_next_path_position()
	var dir = (next - global_position).normalized()
	velocity = dir * 100
	move_and_slide()
	navigation_agent_2d.velocity = velocity

func set_destination(pos: Vector2):
	navigation_agent_2d.target_position = pos

func set_selected(value: bool):
	is_selected = value
	$SelectionHighlight.visible = value
