extends RefCounted
class_name TeleportData

enum TELEPORT_TYPES { NULL, CIRCLE, STONE}

@export var type:TELEPORT_TYPES = TELEPORT_TYPES.NULL
var inside_room:RoomData = null
