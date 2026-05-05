extends Node2D	

enum SpawnMode { AGENT, PATROLLER }

var current_spawn_mode = SpawnMode.AGENT
var selected_agent = null

var AgentScene = preload("res://scenes/agent_regular.tscn")
var PatrollerScene = preload("res://scenes/agent_patroller.tscn")

@onready var mode_label: Label = $ModeLabel

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		var world_pos = get_global_mouse_position()
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_spawn_agent(world_pos)
		
		elif event.button_index == MOUSE_BUTTON_LEFT:
			var clicked = _get_agent_at(world_pos)
			if clicked:
				_select(clicked)
			elif selected_agent:
				selected_agent.set_destination(world_pos)

func _spawn_agent(pos):
	var scene
	if current_spawn_mode == SpawnMode.AGENT:
		scene = AgentScene
	else:
		scene = PatrollerScene
	
	var agent = scene.instantiate()
	add_child(agent)
	agent.global_position = pos

func _get_agent_at(pos):
	for child in get_children():
		if child.has_method("set_destination"):
			if child.global_position.distance_to(pos) < 20:
				return child
	return null

func _select(agent):
	if agent == selected_agent:
		selected_agent.set_selected(false)
		selected_agent = null
	else:
		if selected_agent != null:
			selected_agent.set_selected(false)
		selected_agent = agent
		selected_agent.set_selected(true)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_mode"):
		if current_spawn_mode == SpawnMode.AGENT:
			current_spawn_mode = SpawnMode.PATROLLER
			mode_label.text = "MODE : PATROLLER"
		else:
			current_spawn_mode = SpawnMode.AGENT
			mode_label.text = "MODE : AGENT"
