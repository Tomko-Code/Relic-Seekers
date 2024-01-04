class_name Tooltip
extends PanelContainer

var last_node: Control = null
var hover_both: bool = true

func _ready():
	mouse_exited.connect(_mouse_exited)
	disable()

func on_hover_show(node: Node, text_callback: Callable, _hover_both: bool = true):
	if not is_node_ready() or node == last_node:
		return
	
	for child in $Contents.get_children():
		child.queue_free()
	var text_array = text_callback.call()
	var text_node_array = []
	for item in text_array:
		var bbcode_label = RichTextLabel.new()
		bbcode_label.bbcode_enabled = true
		bbcode_label.text = item
		bbcode_label.fit_content = true
		bbcode_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		text_node_array.append(bbcode_label)
		var h_separator = HSeparator.new()
		text_node_array.append(h_separator)
	text_node_array.pop_back()
	for text_node in text_node_array:
		$Contents.add_child.call_deferred(text_node)
	
	# no idea why but otherwsie doesn't resize correctly (something to do with call_deferred)
	await get_tree().process_frame
	await get_tree().process_frame
	
	reset_size()
	
	if node is Control:
		node = node as Control
		var view_size = get_viewport_rect().size
		var x_pos = clamp(node.get_screen_position().x - size.x/2 + node.size.x/2, 0, view_size.x - size.x)
		var y_pos = clamp(node.get_screen_position().y - size.y, 0, view_size.y - size.y)
		position = Vector2(x_pos, y_pos)
	
	hover_both = _hover_both
	last_node = node
	enable()

func _process(delta):
	_mouse_exited()

func _mouse_exited():
	var is_hovering_tooltip = hover_both and Rect2(Vector2(), size).has_point(get_local_mouse_position())
	var is_hovering_node = last_node != null and Rect2(Vector2(), last_node.size).has_point(last_node.get_local_mouse_position())
	
	if not is_hovering_tooltip and not is_hovering_node:
		disable()

func enable():
	show()
	set_process(true)

func disable():
	set_process(false)
	last_node = null
	hide()
	
