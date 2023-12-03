class_name Zone
extends Node

enum ZoneType{STATIC, GENERATED, GENERATED_PRESET}
@export var type: ZoneType
@export var zone_name: String = "null"

func on_zone_enter(zone_spawn:int = 0):
	pass

func on_zone_exit():
	pass
