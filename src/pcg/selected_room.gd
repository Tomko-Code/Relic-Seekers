extends VBoxContainer
class_name SelectedRoom

signal toggle_panel(value)

@export var settings:Control
@export var slect_button:Button
@export var connection_list:Control

# Room related info
var room_base_name:String = ""
var room_name:String = ""
var shape:String = ""
var custom_data:RoomData = RoomData.new() 
var room_res
var room:Room = null
var rooms:Node2D

func set_up(value:String, level:Level):
	if value == "":
		return
	
	custom_data.set_up(value, level)
	
	room_res = GameData.rooms_data[value]["res"]
	room = room_res.instantiate()
	
	for conn in custom_data.connection_arry:
		var lable:Label = Label.new()
		lable.text = "inside: " +str(conn.inside_cord) + "\ndirection: " + str(conn.direction)
		connection_list.add_child(lable)

func _enter_tree():
	room.queue_free()

func _on_button_pressed():
	emit_signal("toggle_panel", self)
	settings.visible = !settings.visible
	
	if settings.visible:
		rooms.add_child(room)
