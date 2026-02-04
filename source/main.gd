extends Node2D


@onready var options_button: OptionButton = $CanvasLayer/LanguageSwitcher


func _ready() -> void:
    TranslationServer.set_locale("en")
    options_button.item_selected.connect(_on_item_selected)


func _on_item_selected(index: int) -> void:
    var translation: String = options_button.get_item_text(index)
    TranslationServer.set_locale(translation)