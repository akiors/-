extends Control
@export var warned:PackedScene
@export var come_back:PackedScene

func _ready() -> void:
	$sucess.visible=false
	var tui=come_back.instantiate()
	get_tree().get_root().add_child(tui)
	pass

func _process(delta: float) -> void:
	pass

func creat_warned(ui:PackedScene,label:String):
	var tui=ui.instantiate()
	tui.position=Vector2(300,342)
	tui.text=label
	get_tree().get_root().add_child(tui)
		
func _on_load_pressed() -> void:      #用户信息加载
	if $user_name.text==""||$user_password.text=="":
		var tui=warned.instantiate()
		tui.position=Vector2(342,342)
		tui.text="内容不能为空"
		get_tree().get_root().add_child(tui)
		return
	var data=load("user://user_data.res")
	if !data:creat_warned(warned,"账户不存在或者密码错误！")
	else:
		if $user_name.text in data.userdata:
			if data.userdata[$user_name.text]==$user_password.text:
				if Statemanger.user_name==$user_name.text:
					creat_warned(warned,"您已经登录了这个账户")
					return
				$sucess.visible=true
				Statemanger.isload=true
				Statemanger.user_name=$user_name.text
				Statemanger.bud=data.budget[$user_name.text]
				Statemanger.current_bud=data.current_budget[$user_name.text]
				Statemanger.isadmin=data.isadmin[$user_name.text]
				await get_tree().create_timer(1).timeout
				var accept=load("res://tscn/meue.tscn")
				get_tree().change_scene_to_packed(accept)
				return
		creat_warned(warned,"账户不存在或者密码错误！")		
	pass 
