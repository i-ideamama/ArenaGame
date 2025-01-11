extends Node2D

@export var PlayerScene : PackedScene
var players_per_team = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in FbGameManager.Players:
		
		
		for j in players_per_team:
			
				
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
				if (spawn.name==str(FbGameManager.setup_index)):
					var current_player  = PlayerScene.instantiate()
					add_child(current_player)
					if(FbGameManager.setup_index>=3):
						current_player.set_player_number(1)
						current_player.modulate_color_to(Color(1,1,1))
					else:
						current_player.set_player_number(0)
						current_player.modulate_color_to(Color(0,0,1))
					current_player.global_position = spawn.global_position
					current_player.set_auth(FbGameManager.Players[i].id)
			FbGameManager.setup_index+=1


func _on_goal_1_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		FbGameManager.player_1_score += 1
		print("goal was scored in player_1's goal")
		print(FbGameManager.player_1_score)


func _on_goal_2_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		FbGameManager.player_2_score += 1
		print("goal was scored in player_2's goal")
		print(FbGameManager.player_2_score)
