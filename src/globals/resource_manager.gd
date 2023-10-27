extends Node

# Holds all cashed resources
var resources = {
	# "resource_group" : {"resource_name" : [resource, resource_path],}
	# "" : {"troll" : [<ref>, res://troll.tcsn],},
}

var load_que = [
	# [resource_path, resource_name],
]

func que_resource() -> void:
	pass

func load_resource(resource_path: String, resource_name: String) -> void:
	if !ResourceLoader.exists(resource_path):
		print("resource_loader.gd | load_resource - file: " + resource_path + " does not exist !")
		return

	var path = resource_name.split("/")
	
	# check if group exist if not make one
	if !resources.has(path[0]):
		resources[path[0]] = {}
	
	# check if resource exist if not load it
	if !resources[path[0]].has(path[1]):
		resources[path[0]][path[1]] = [load(resource_path), path[1]]
		#print("resource_loader.gd | load_resource - file: " + resource_path + " loaded as: " + resource_name + " !")


func free_resource(resource_name: String) -> void:
	var path = resource_name.split("/")
	
	if !resources.has(path[0]):
		return
	
	if !resources[path[0]].has(path[1]):
		return
	
	resources[path[0]].erase(path[1])
	if resources[path[0]].is_empty():
		resources.erase(path[0])

func load_preset(preset: Array) -> void:
	for resource in preset:
		load_resource(resource[0], resource[1])

func que_preset() -> void:
	pass

func resource_exists(resource_name: String):
	var path = resource_name.split("/")
	
	if !resources.has(path[0]):
		return false
	
	if !resources[path[0]].has(path[1]):
		return false
	
	return true

func get_resource(resource_name: String):
	var path = resource_name.split("/")
	
	if !resource_exists(resource_name):
		return null
	
	return resources[path[0]][path[1]]

func get_instance(resource_name: String):
	var path = resource_name.split("/")
	
	if !resource_exists(resource_name):
		return null
	
	return resources[path[0]][path[1]].instantiate()
