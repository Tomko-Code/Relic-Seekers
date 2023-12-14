extends PanelContainer

@onready var gold_label = $MarginContainer/VBoxContainer/GoldHbox/GoldDisplay
@onready var emerald_label = $MarginContainer/VBoxContainer/EmeraldHbox/EmeraldDisplay
@onready var player_inventory = GameData.save_file.player_inventory as PlayerInventory

func _ready():
	if player_inventory != null:
		player_inventory.gold_changed.connect(update_values)
		player_inventory.emeralds_changed.connect(update_values)
		update_values()
	else:
		gold_label.text = str(20)
		emerald_label.text = str(1)
	
func update_values():
	gold_label.text = "%03d" % player_inventory.gold
	emerald_label.text = "%03d" % player_inventory.emeralds
