extends Panel


var cash = 250
var firm_name = "GoDot Pirate Trader"
var city = preload("res://City.gd")
var product = preload("res://Product.gd")
var city_product = preload("res://CityProduct.gd")
var product_panel = preload("res://ProductPanel.tscn")
var current_city_index = 0;
var city_data = [{'name':'Hong Kong'}, {'name':'Shanghai'}, {'name':'Nagasaki'}, {'name':'Manila'}]
var product_data = [{'name': 'General Goods', 'min_price': 2, 'max_price': 25},
					{'name': 'Arms', 'min_price': 15, 'max_price': 85},
					{'name': 'Silk', 'min_price': 105, 'max_price': 585},
					{'name': 'Opium', 'min_price': 120, 'max_price': 5000}]

var cities = []
var products = []

signal ARRIVE_AT_PORT


func _ready() :
	CreateProducts()
	CreateProductPalels()
	CreateCities()
	CreateCityProducts()
	ArriveAtPort()
	UpdateUI() 


func CreateProductPalels():
	for _product in products:
		var _product_panel = product_panel.instance()
		_product.product_panel = _product_panel
		_product_panel.init(_product)
		_product_panel.UpdateUI(_product.product_name)
		$ProductListContainer.add_child(_product_panel)


func ArriveAtPort():
	emit_signal("ARRIVE_AT_PORT")

func CreateCityProducts() -> void:
	for _city in cities:
		for _product in products:
			var _city_product = city_product.new(self, _city, _product)
			_city.city_products.append(_city_product)
	
	
func CreateCities():
	for _city in city_data:
		var city1 = city.new()
		city1.city_name = _city.name
		cities.append(city1)
	

	
func CreateProducts():
	for _product in product_data:
		var prod = product.new(_product.name, _product.min_price, _product.max_price)
		products.append(prod)
	

func UpdateUI():
	$FirmLabel.text = firm_name
	$CashLabel.text = "Cash: $" + str(cash)
	$CityLabel.text = "City: " + cities[current_city_index].city_name


func DepartFromCity(_new_city_index):
	if current_city_index != _new_city_index:
		current_city_index = _new_city_index
		ArriveAtPort()
		UpdateUI()

	
