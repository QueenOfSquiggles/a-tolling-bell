extends Node

const STEAM_TESTING_APP_ID: int = 480
const FILE_PATH_SAVE_SLOTS: String = "user://slots"


class SteamData:
	var connected: bool = false
	var is_on_steam_deck: bool
	var is_online: bool
	var is_owned: bool
	var steam_id: int
	var client_name: String


signal serialize
signal deserialize

var steam_data: SteamData = SteamData.new()
var slot_path: String = ""
var _player: PlayerCharacter


func _ready() -> void:
	_init_steam()
	open_slot("default")


func _process(_delta: float) -> void:
	Steam.run_callbacks()


func get_player() -> PlayerCharacter:
	if _player:
		return _player
	var temp := get_tree().get_first_node_in_group("player") as PlayerCharacter
	if temp:
		_player = temp
		return _player
	push_warning("Failed to collect player node. Possibly calling too early??")
	return null


func _init_steam() -> void:
	var resp := Steam.steamInitEx(true, STEAM_TESTING_APP_ID)
	var success: bool = _handle_steam_init_error(int(resp.status), String(resp.verbal))
	if not success:
		return

	var data := SteamData.new()
	data.connected = true
	data.is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
	data.is_online = Steam.loggedOn()
	data.is_owned = Steam.isSubscribed()
	data.steam_id = Steam.getSteamID()
	data.client_name = Steam.getPersonaName()
	# TODO: get any more relevant data?
	steam_data = data
	print("User %s has connected" % str(data.client_name))

	if not steam_data.is_owned:
		push_warning(
			"Hey, it looks like you don't actually own this game. It'd be super cool if you threw some money at me (the creator) if you're liking this game. I mean I'm not gonna stop you from playing lol. What kinda dingus would do that?"
		)


func _handle_steam_init_error(err_code: int, message: String) -> bool:
	match err_code:
		0:
			# successfully init
			return true
		1:
			# some unmanaged error
			push_warning(
				(
					"Unmanaged steam connection error: %s\n\tGame will attempt to continue running in case this issue is not breaking"
					% message
				)
			)
			return true
		2:
			# cannot connect to steam client
			push_warning(
				"Couldn't connect to steam client. Is it running? If not possibly a bigger issue?"
			)
			return false
		3:
			# steam client out of date
			push_warning(
				"Your steam client appears out of date. This might cause some problems with certain social integrations. But the core gameplay experience should remain unaffected"
			)
			return true
	push_error(
		(
			"This error code should not be possible for a steam response! %s :: %s"
			% [str(err_code), message]
		)
	)
	return false


## Opens a slot for global use. Returns true if the slot was empty
func open_slot(slot_name: String) -> bool:
	slot_path = FILE_PATH_SAVE_SLOTS.path_join(slot_name)
	var abs_path = ProjectSettings.globalize_path(slot_path)
	if DirAccess.dir_exists_absolute(abs_path):
		return false
	DirAccess.make_dir_recursive_absolute(abs_path)
	return true


func get_available_slots() -> PackedStringArray:
	var dir = DirAccess.open(FILE_PATH_SAVE_SLOTS)
	if not dir:
		return []
	return dir.get_directories()


func trigger_serialize() -> void:
	serialize.emit()


func trigger_deserialize() -> void:
	deserialize.emit()
