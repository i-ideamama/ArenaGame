extends RigidBody2D

var mouse_in_area := false
var initial_pos = null
var currently_aiming := false
var start_sync = false
var player_number

@export var replicated_position : Vector2
@export var replicated_rotation : float
@export var replicated_linear_velocity : Vector2
@export var replicated_angular_velocity : float

func _ready() -> void:
	pass
	#$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func modulate_color_to(modulate_to_color):
	$Sprite2D.modulate = modulate_to_color

func set_auth(mult_id):
	$MultiplayerSynchronizer.set_multiplayer_authority(mult_id)

func set_player_number(player_no):
	player_number = player_no

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()):
		replicated_position = position
		replicated_rotation = rotation
		replicated_linear_velocity = linear_velocity
		replicated_angular_velocity = angular_velocity
	else:
		position = replicated_position
		rotation = replicated_rotation
		linear_velocity = replicated_linear_velocity
		angular_velocity = replicated_angular_velocity

func _input(event):
	if(($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id())):
		if (event is InputEventMouseButton):
			if event.button_index==1:
				if mouse_in_area and event.is_pressed():
					initial_pos = get_global_mouse_position()
					currently_aiming = true
				if (event.is_released() and currently_aiming):
					if initial_pos!=null:
						shoot_with_force((initial_pos - get_global_mouse_position()).normalized())

func shoot_with_force(dxn):
	var force_mag = 1250
	self.apply_central_impulse(dxn*force_mag)
	currently_aiming = false
	print('shoot with  force')


func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false
