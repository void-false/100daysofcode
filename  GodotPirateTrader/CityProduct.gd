extends Node


var city = null
var product = null
var price: int = 0
var main

func _init(_main, _city, _product):
	main = _main
	city = _city
	product = _product
	main.connect("ARRIVE_AT_PORT", self, "UpdateCityProduct")
#	GetRandomPrice()
	
func UpdateCityProduct():
	randomize()
	if randf() > .5:
		price = product.calculate_price()
		product.product_panel.update_price(price)
	print("Signal fired. Product: %s; City: %s" % [product.product_name, city.city_name])
	
