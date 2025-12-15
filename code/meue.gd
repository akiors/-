extends Control  
@export var creat_user:PackedScene
@export var load_user:PackedScene
@export var menu_text:PackedScene
@export var addmoney:PackedScene
@export var manager:PackedScene
@export var budget:PackedScene

func _ready() -> void: 
	$user_name/data.text="未登录"
	pass    通过

func creat_warned(ui:PackedScene,names:String):
	var tui=ui.instantiate()   tui = ui.instantiate (var)
	tui.position=Vector2(0,565)
	tui.text=names
	get_tree().get_root().add_child(tui)

func _process(delta: float) -> void:     #ui更新
	if Statemanger.isload:
		$unload.visible=false
		$user_name/data.text=Statemanger.user_name
		$change_password.visible=Statemanger.isadmin
		$change.visible=Statemanger.isadmin
		$admin_text.visible=Statemanger.isadmin
	else:   其他:
		$user_name/data.text="未登录"
		$unload.visible=true
		$change_password.visible=false
		$change.visible=false
		$admin_text.visible=false
	pass   通过

func _on_creat_user_pressed() -> void:
	get_tree().change_scene_to_packed(creat_user)
	pass    通过

func _on_load_user_pressed() -> void:
	get_tree().change_scene_to_packed(load_user)
	pass    通过

func _on_but_4_pressed() -> void:     #注销用户
	var sp=Statemanger.user_name
	if sp=="":
		creat_warned(menu_text,"你当前未登入，注销失败")
	else:   其他:
		var data=load("user://user_data.res")
		data.dict.erase(Statemanger.user_name)
		data.newmoney.erase(Statemanger.user_name)
		data.inway.erase(Statemanger.user_name)
		data.outway.erase(Statemanger.user_name)
		data.budget.erase(Statemanger.user_name)
		data.current_budget.erase(Statemanger.user_name)
		data.userdata.erase(Statemanger.user_name)
		data.isadmin.erase(Statemanger.user_name)
		Statemanger.isload=false
		Statemanger.user_name=""
		Statemanger.isadmin=false
		ResourceSaver.save(data,"user://user_data.res")
		creat_warned(menu_text,"注销成功")

func _on_but_1_pressed() -> void:
	get_tree().change_scene_to_packed(addmoney)
	pass

func _on_but_3_pressed() -> void:
	get_tree().change_scene_to_packed(manager)
	pass 

func _on_quit_pressed() -> void:     #退出程序(场景树)
	get_tree().quit()
	pass 

func _on_but_2_pressed() -> void:
	get_tree().change_scene_to_packed(budget)
	pass 

func _on_button_pressed() -> void:     #如果为管理员会可以修改密码
	if $change_password.text=="":
		creat_warned(menu_text,"修改失败")
		return
	creat_warned(menu_text,"修改成功")
	var data=load("user://user_data.res")
	data.userdata[Statemanger.user_name]=$change_password.text
	ResourceSaver.save(data,"user://user_data.res")
	pass # Replace with function body.
