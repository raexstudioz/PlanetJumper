extends Node2D
var Shield_Price : int = 10
var Boosters_Price : int = 10
@export var shopPanel : Control
var shopcaller : Node2D

func _ready():
	#shopPanel = get_node("../ShopPanel")
	print("The Shop PAnel:-- " , shopPanel)
	await _wait_until_shop_ready()
	theconnection()
	
func _wait_until_shop_ready():
	while shopPanel == null:
		await get_tree().process_frame

func theconnection():
	shopPanel.connect("CloseShop",Callable(self,"CloseShopPanel"))
	shopPanel.connect("buyshield",Callable(self,"Buy_Shield"))
	shopPanel.connect("buypoints",Callable(self,"Buy_Points"))
	shopPanel.connect("buybooster",Callable(self,"Buy_Boosters"))

func Buy_Shield():
	if(GlobalVariables.globalpoints < Shield_Price):
		print("Not enough points to buy!!")
		return
	GlobalVariables.deduct_point(10)
	GlobalVariables.add_ShieldTime()
	var type = SavingTypeList.new()
	type.type_list["Points"] = true
	type.type_list["ShieldTime"] = true
	SaveAndLoad.Save_PlayerData(type)
	
func Buy_Points():
	var today = Time.get_date_string_from_system()
	if GlobalVariables.LastPointsDate == today:
		show_message("You already got your points for today.\nWait till tomorrow!")
		return
	GlobalVariables.LastPointsDate = today
	GlobalVariables.add_custom_points(100)
	var type = SavingTypeList.new()
	type.type_list["Points"] = true
	type.type_list["LastPointsDate"] = true
	SaveAndLoad.Save_PlayerData(type)

func show_message(text: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	get_tree().root.add_child(dialog)
	dialog.popup_centered()
	dialog.confirmed.connect(dialog.queue_free)

func Buy_Boosters():
	if(GlobalVariables.globalpoints < Boosters_Price):
		print("Not Enough points to buy!!")
		return
	GlobalVariables.deduct_point(10)
	GlobalVariables.add_Boosters()
	var type = SavingTypeList.new()
	type.type_list["Points"] = true
	type.type_list["Boosters"] = true
	SaveAndLoad.Save_PlayerData(type)

func OpenShopPanel():
	shopPanel.show()
	shopPanel.Hello()

	
	
func CloseShopPanel():
	print("Closing Shop Panel!!")
	shopPanel.hide()
