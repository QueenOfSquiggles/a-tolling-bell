extends Object
class_name SaveData

enum SlotMode { USE_SLOT, GLOBAL }

var file_path: String
var data_buffer: Dictionary = {}
var slot_mode := SlotMode.USE_SLOT


static func open(file: String, slot: SlotMode = SlotMode.USE_SLOT) -> SaveData:
	var data := SaveData.new()
	data.file_path = file if slot == SlotMode.GLOBAL else GameManager.slot_path.path_join(file)
	var abs_path := ProjectSettings.globalize_path(data.file_path)
	var dir := abs_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)
	return data


func deserialize() -> bool:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return false
	var json_text := file.get_as_text()
	var data := JSON.parse_string(json_text) as Dictionary
	if data and not data.is_empty():
		data_buffer = data
		return true
	return false


func serialize() -> bool:
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		return false
	var json_text := JSON.stringify(data_buffer, "\t", true, true)
	file.store_string(json_text)
	return true
