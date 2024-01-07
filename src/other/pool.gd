class_name Pool

var total_objects = 0

var free_objects = []
var dirty_objects = 0
var taken_objects = []
var template

var is_script = false
var is_tscn = false

func _init(t):
	template = t
	if template is GDScript:
		is_script = true
	elif template is PackedScene:
		is_tscn = true


func release_pool():
	for object in taken_objects:
		_release_object(object)
	taken_objects.clear()

func free_pool():
	release_pool()
	taken_objects.clear()
	for object in free_objects:
		object.queue_free()
	free_objects.clear()


func get_object():
	var ret_object = null
	if free_objects.is_empty():
		if is_script: ret_object = template.new()
		elif is_tscn: ret_object = template.instantiate()
		else: ret_object = template.duplicate()
		total_objects += 1
	else:
		ret_object = free_objects.pop_back()
	if ret_object == null: push_error("Pool:get_object Allocation error")
	taken_objects.append(ret_object)
	return ret_object


func release_object(object):
	taken_objects.erase(object)
	_release_object(object)


func _release_object(object):
	if object is Node and object.is_inside_tree():
		object.get_parent().remove_child.call_deferred(object)
		_clean_object.call_deferred(object)
	#container.remove_child(object)
	#dirtyObjects += 1


#func cleanup_pool():
#	var invalid = []
#	for key in containers:
#		if !is_instance_valid(containers[key]):
#			invalid.push_back(key)
#	if invalid:
#		for key in invalid:
#			containers.erase(key)
#			takenObjects.erase(key)


func _clean_object(object):
	object.release()
	free_objects.push_back(object)


#func _disconnectAll(node):
#	var signals = node.get_signal_list();
#	for cur_signal in signals:
#		var conns = node.get_signal_connection_list(cur_signal.name);
#		for cur_conn in conns:
#			cur_conn['signal'].disconnect(cur_conn['callable'])
#	for child in node.get_children():
#		_disconnectAll(child)

