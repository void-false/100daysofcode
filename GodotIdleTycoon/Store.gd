extends Panel


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var money: float = 0
var store_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ui()

func update_ui() -> void:
	$MoneyLabel.text = "$" + str(money)
	$StoreCountLabel.text = str(store_count)
	
func _on_Button_pressed() -> void:
	money += 1
	update_ui()


func _on_BuyButton_pressed() -> void:
	store_count += 1
	money -= 5
	update_ui()
