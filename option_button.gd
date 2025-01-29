extends OptionButton

const RESOLUTION_DICT = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080)
}

func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICT:
		add_item(resolution_size_text)
