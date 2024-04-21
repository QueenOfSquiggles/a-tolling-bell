extends VBoxContainer

@onready var inv := %InventoryGuiDisplay
@onready var label_name: Label = $LabelName
@onready var label_description: Label = $LabelDescription

# Load type for accessing signals
const CtrlInventoryGridBasic = preload("res://addons/gloot/ui/ctrl_inventory_grid_basic.gd")


func _ready() -> void:
	visible = false
	await RenderingServer.frame_post_draw
	var basic: CtrlInventoryGridBasic = inv._ctrl_inventory_grid_basic
	basic.selection_changed.connect(_on_selection)
	basic.inventory_item_activated.connect(_on_item_activated)
	basic.inventory_item_context_activated.connect(_on_item_context_activated)


func _on_selection() -> void:
	var item: InventoryItem = inv.get_selected_inventory_item()
	if not item:
		visible = false
		return
	visible = true
	label_name.text = tr(item.prototype_id + ".name")
	label_description.text = tr(item.prototype_id + ".desc")


func _on_item_activated(item: Variant) -> void:
	print("Item activated: %s" % str(item))


func _on_item_context_activated(item: Variant) -> void:
	print("Item context: %s" % str(item))


func _on_item_mouse_entered(item: Variant) -> void:
	print("Item on mouse: %s" % str(item))
