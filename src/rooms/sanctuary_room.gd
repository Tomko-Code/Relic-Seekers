extends Room


func _enter_tree() -> void:
	"Init : Sanctuary"
	GameManager.game_camera.new_limit_left = 0
	GameManager.game_camera.new_limit_top = 0
	GameManager.game_camera.new_limit_right = 1000000
	GameManager.game_camera.new_limit_bottom = 1000000
	
	GameManager.game_camera.limit_left =  GameManager.game_camera.new_limit_left
	GameManager.game_camera.limit_right =  GameManager.game_camera.new_limit_right
	GameManager.game_camera.limit_bottom =  GameManager.game_camera.new_limit_bottom
	GameManager.game_camera.limit_top =  GameManager.game_camera.new_limit_top

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
