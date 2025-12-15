extends Control
var no=preload("res://image/options_checkbox0.png")    #预加载资源,全局只调用一次,无论是否进入该场景,这里加载勾选框图片
var yes=preload("res://image/options_checkbox1.png")

func _ready() -> void:
	var datap=load("user://user_data.res")
	if datap==null||!datap.dict.has(Statemanger.user_name): return 
	if datap.budget[Statemanger.user_name]==-1:
		$Label2.visible=true                     #visible为是否显示.false不显示,true反之
		$Label3.visible=false
	else:
		$Label2.visible=false
		$Label3.visible=true
	for i in datap.inway[Statemanger.user_name]:
		if datap.inway[Statemanger.user_name][i][2]==0:
			$ItemList.add_item(i,no)             #no为为勾选的图片，未打勾
		else:
			$ItemList.add_item(i,yes)
	for i in datap.outway[Statemanger.user_name]:
		if datap.outway[Statemanger.user_name][i][2]==0:
			$ItemList2.add_item(i,no)
		else:
			$ItemList2.add_item(i,yes)
	pass

func _process(delta: float) -> void:   #更新预算
	$Label3/Label.text=str(Statemanger.bud)+"元"
	$Label3/Label3.text=str(Statemanger.current_bud)+"元"
	pass

func _on_button_pressed() -> void:    #重新设置预算
	var datap=load("user://user_data.res")
	if datap==null||!datap.dict.has(Statemanger.user_name): return 
	if int($Label2/TextEdit.text)<=0:
		var text=load("res://tscn/text.tscn")
		var tui=text.instantiate()
		tui.position=Vector2(250,570)
		tui.text="您的预算有问题"
		get_tree().get_root().add_child(tui)
		return
	datap.budget[Statemanger.user_name]=int($Label2/TextEdit.text)
	datap.current_budget[Statemanger.user_name]=int($Label2/TextEdit.text)
	Statemanger.bud=int($Label2/TextEdit.text)
	Statemanger.current_bud=int($Label2/TextEdit.text)
	$Label2.visible=false
	$Label3.visible=true
	ResourceSaver.save(datap,"user://user_data.res")
	pass

func _on_delete_pressed() -> void:
	$Label2.visible=true
	$Label3.visible=false
	pass 

func _on_item_list_item_activated(index: int) -> void:   #预算类型控制（决定是否可以通过该类型对预算进行增减）
	var datap=load("user://user_data.res")
	if datap==null||!datap.dict.has(Statemanger.user_name): return 
	var texture=$ItemList.get_item_icon(index)
	var data=datap.inway[Statemanger.user_name]
	if texture==yes: 
		$ItemList.set_item_icon(index,no)
		data[$ItemList.get_item_text(index)][2]=0
	elif texture==no: 
		$ItemList.set_item_icon(index,yes)
		data[$ItemList.get_item_text(index)][2]=1
	ResourceSaver.save(datap,"user://user_data.res")

func _on_item_list_2_item_activated(index: int) -> void:
	var datap=load("user://user_data.res")
	if datap==null||!datap.dict.has(Statemanger.user_name): return 
	var texture=$ItemList2.get_item_icon(index)
	var data=datap.outway[Statemanger.user_name]
	if texture==yes: 
		$ItemList2.set_item_icon(index,no)
		data[$ItemList2.get_item_text(index)][2]=0
	elif texture==no: 
		$ItemList2.set_item_icon(index,yes)
		data[$ItemList2.get_item_text(index)][2]=1
	ResourceSaver.save(datap,"user://user_data.res")
