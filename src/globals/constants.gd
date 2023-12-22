extends Node

const FLOOR_TILE_SIZE:Vector2 = Vector2(64, 64)
const WALL_TILE_SIZE:Vector2 = Vector2(320, 320)
const CHUNK_SIZE:Vector2 = Vector2(WALL_TILE_SIZE.x * 5, WALL_TILE_SIZE.y * 4)

enum damage_types {
	MAGIC,
	FIRE,
	ICE,
	LIGHTNING,
	POISON,
}

enum entity_effects {
	BURNING,
}

func damage_type_to_effect(damage_type: damage_types):
	match damage_type:
		damage_types.FIRE:
			return entity_effects.BURNING

enum effect_types {
	POSITIVE,
	NEGATIVE,
	NEUTRAL
}

enum spell_archetypes {
	PROJECTILE,
	ACTIVE,
}

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

enum cross_directions {
	RIGHT = 0,
	UP = 2,
	LEFT = 4,
	DOWN = 6,
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

enum STARTING_OPTIONS { NORMAL, COMBAT }
