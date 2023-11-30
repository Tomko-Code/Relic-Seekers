extends Node

enum all_directions {
	RIGHT,
	RIGHT_UP,
	UP,
	LEFT_UP,
	LEFT,
	LEFT_DOWN,
	DOWN,
	RIGHT_DOWN
}

enum collision_layers {
	PLAYER = 1,
	STATIC,
	ENEMY,
	PLAYER_ATTACKS,
	ENEMY_ATACKS,
	GATES,
	PICKAPABLE,
	INTERACTABLE,
}
