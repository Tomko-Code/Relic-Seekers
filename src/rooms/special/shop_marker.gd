class_name ShopMarker
extends Marker2D

var purchasable: PurchasableWrapper = null

func set_purchasable(object: PurchasableWrapper):
	if purchasable != null:
		purchasable.delete()
	purchasable = object
	purchasable.bought.connect(clear_purchasable)
	call_deferred("add_child", object)
	
func clear_purchasable():
	purchasable = null
