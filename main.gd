extends Node2D

@onready var button: OptionButton = $Player/Control/OptionButton

func _ready() -> void:
    TranslationServer.set_locale("en")
    button.item_selected.connect(_on_item_selected)


func _on_item_selected(i: int) -> void:
    var item: String = button.get_item_text(i)
    TranslationServer.set_locale(item)