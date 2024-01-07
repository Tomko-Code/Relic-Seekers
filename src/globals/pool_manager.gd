extends Node

#for managinge node templates, lists and such

var _pools = {}


func register_pool(template) -> int:
	var pool_id: int = randi()
	while _pools.has(pool_id):
		pool_id += 1
	if !_pools.has(pool_id):
		_pools[pool_id] = Pool.new(template)
	return pool_id
	

func get_object(pool_id: int):
	print("Projectiles: %s" % _pools[pool_id].total_objects)
	return _pools[pool_id].get_object()


func release_object(pool_id: int, object):
	_pools[pool_id].release_object(object)


func release_pool(pool_id: int):
	_pools[pool_id].release_pool()
	

func free_pool(pool_id: int):
	_pools[pool_id].free_pool()


func cleanup_pool(pool_id: int):
	_pools[pool_id].cleanup_pool()
