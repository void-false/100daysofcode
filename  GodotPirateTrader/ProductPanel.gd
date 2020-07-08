extends Panel


var product


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func init(_product):
	product = _product
	
	
func update_price(price):
	$Price.text = str(price)

func UpdateUI(_product_name):
	$ProductName.text = _product_name
