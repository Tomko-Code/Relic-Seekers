# Resource Manager (Global)

This class is mostly for cashing resources, before game realy started. This is done by making dictionary of all cashed data. Best used for often reused scenes.  
  
In future it will be able to load data in thread.

### Load resources.
```
var load_preset = [
	["res://src/entities/projectiles/friendly_projectile.tscn", "projectile/friendly_projectile"],
    # [...], 
    # [...],
]

ResourceManager.load_preset(load_preset)
```
or one by one
```
ResourceManager.load_resource("res://src/entities/projectiles/friendly_projectile.tscn", "projectile/friendly_projectile")
```

### Load resources in Thread (NOT IMPLEMENTED).

```
var load_preset = [
	["res://src/entities/projectiles/friendly_projectile.tscn", "projectile/friendly_projectile"],
    # [...], 
    # [...],
]

ResourceManager.que_preset(load_preset)
```
or one by one
```
ResourceManager.que_resource("res://src/entities/projectiles/friendly_projectile.tscn", "projectile/friendly_projectile")
```

### Geting resource/instance
Both function will return null if resource is not cashed and will not try to load it.  
Note that load() is still okay to use.

```
func get_resource(resource_name: String) 
    # example : ResourceManager.get_resource("projectile/friendly_projectile")
```

```
func get_instance(resource_name: String) 
    # example : ResourceManager.get_instance("projectile/friendly_projectile")
```

#### Manual
You can ger resource form varible "resources"
```
# example : var trol_res = ResourceManager.resources["enemy"][troll][0] # resurce
# example : var trol_res = ResourceManager.resources["enemy"][troll][1] # path
```

### resource_exists(resource_name: String)
Returns true/false.