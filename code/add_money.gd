extends Control
@export var come_back:PackedScene
@export var text:PackedScene     #PackedScene类型是场景类型,负责tscn文件这里用于文字场景的调用
var erp=["收入","支出"]
var choose:int=-1

func _ready() -> void:
	var tui=come_back.instantiate()          #instantiate()函数为实例化函数，此时为根节点实例
	tui.position=Vector2(140,3)				 #position为位置,vector2表示二维平面向量
	get_tree().get_root().add_child(tui)	 #表示将实例化场景加入场景树,才能可视化
	var datap=load("user://user_data.res")   #load为加载函数,加载"user://user_data.res"这个为存储文件,负责用户信息存储
	if datap==null||!datap.dict.has(Statemanger.user_name): return
	$cmp.add_item("")                        #加入空类型
	for i in datap.inway[Statemanger.user_name]:     #依次加入收入类型
		$income/income_categoity.add_item(i)
		$cmp.add_item(i)
	for i in datap.outway[Statemanger.user_name]:    #依次支出收入类型
		$outcome/income_categoity.add_item(i)
		$cmp.add_item(i)
	var count=datap.dict[Statemanger.user_name].size()     #以下将显示所有收入支出记录
	var re=datap.dict[Statemanger.user_name]
	for i in range(count):
		var y=4-re[i][1].length()
		var x=6-re[i][3].length()-re[i][4].length()-re[i][5].length()
		$ItemList.add_item(re[i][0]+"       "+re[i][1]+"    ".repeat(y)+"    "+re[i][2]+"年"+re[i][3]
		+"月"+re[i][4]+"日"+re[i][5]+":"+re[i][6]+"  ".repeat(x)+"       "+re[i][7]+"元"+"          "+re[i][8])	
	pass 


func _process(delta: float) -> void:
	pass

func _on_save_pressed() -> void:
	var tree
	if Statemanger.isload==false: 
		var tui=text.instantiate()
		tui.position=Vector2(332,565)
		tui.text="您还没登录"
		get_tree().get_root().add_child(tui)
		return
	var datap=load("user://user_data.res")
	var payway=erp[$TabBar.current_tab]      #判断当前是收入函数支出,从而取得拿到哪一个节点的具体信息
	if $TabBar.current_tab==0: tree=$income
	else: tree=$outcome
	var year=tree.get_child(4).text
	var month=tree.get_child(6).text
	var day=tree.get_child(8).text
	var hour=tree.get_child(14).text
	var minith=tree.get_child(13).text
	var money=tree.get_child(11).text
	var cateu=tree.get_child(1).get_item_text(tree.get_child(1).selected)  
	var beizhu=$TextEdit.text
	var list=[payway,cateu,year,month,day,hour,minith,money]
	if list.has(""):
		var tui=text.instantiate()
		tui.position=Vector2(322,565)
		tui.text="还有未填的元素"
		get_tree().get_root().add_child(tui)
		return
	var isrunyear:int=(int(year)%4==0&&int(year)%100!=0)||int(year)%400==0   #判断是平年还是闰年
	var dictgh=[31,28+isrunyear,31,30,31,30,31,31,30,31,30,31]
	if int(month)>12||int(month)<=0||int(day)<=0||int(day)>dictgh[int(month)-1]||int(hour)<0||int(hour)>23||int(minith)<0||int(minith)>=60:
		var tui=text.instantiate()
		tui.position=Vector2(322,565)
		tui.text="没有这个时间"
		get_tree().get_root().add_child(tui)
		return
	list.append(beizhu)   #加入元素
	var map=[1,-1]
	var yourchoose=[datap.inway[Statemanger.user_name],datap.outway[Statemanger.user_name]]
	datap.dict[Statemanger.user_name].append(list)    #对该用户的记录进行新增
	var nemon=int(money)*map[$TabBar.current_tab]     
	datap.newmoney[Statemanger.user_name]+=nemon      #总收入增减
	var dest=yourchoose[$TabBar.current_tab][list[1]]     #以下对类型的单独控制钱的增减和次数的增加
	dest[0]+=nemon
	dest[1]+=1
	if dest[2]==1:             #预算管理
		datap.current_budget[Statemanger.user_name]+=nemon
		Statemanger.current_bud+=nemon
	var y=4-list[1].length()
	var x=6-list[3].length()-list[4].length()-list[5].length()
	$ItemList.add_item(list[0]+"       "+list[1]+"    ".repeat(y)+"    "+list[2]+"年"+list[3]+"月"+list[4]   #记录新增
	+"日"+list[5]+":"+list[6]+"  ".repeat(x)+"       "+list[7]+"元"+"          "+list[8])
	ResourceSaver.save(datap,"user://user_data.res")    #保存文件
	pass 
	
func _on_item_list_item_selected(index: int) -> void:
	choose=index             #记录当前选择的记录
	pass 

func _on_button_pressed() -> void:   #记录删除
	if choose==-1: return
	var map={"收入":-1,"支出":1}
	$ItemList.remove_item(choose)
	var datap=load("user://user_data.res")
	var arr=datap.dict[Statemanger.user_name]
	var money=arr[choose][7]
	var name1=arr[choose][1]
	var map1={"收入":datap.inway[Statemanger.user_name],"支出":datap.outway[Statemanger.user_name]}
	map1[arr[choose][0]][name1][0]+=map[arr[choose][0]]*int(money)
	map1[arr[choose][0]][name1][1]-=1
	datap.newmoney[Statemanger.user_name]+=int(money)*map[arr[choose][0]]
	datap.dict[Statemanger.user_name].remove_at(choose)
	ResourceSaver.save(datap,"user://user_data.res")
	choose=-1
	pass

func _on_button_2_pressed() -> void:  #记录筛选
	if $cmp.selected<0&&($left.text==""||$right.text==""):
		var text1=load("res://tscn/text.tscn")
		var tui=text1.instantiate()
		tui.position=Vector2(300,565)
		tui.text="无法筛选"
		get_tree().get_root().add_child(tui)
		return
	var datap=load("user://user_data.res")
	if datap==null||!datap.dict.has(Statemanger.user_name): return 
	var re=datap.dict[Statemanger.user_name]
	if $cmp.selected>=0&&($left.text==""||$right.text==""):
		$ItemList.clear()
		var you=$cmp.get_item_text($cmp.selected)
		if you=="":
			for i in re:
				var y=4-i[1].length()
				var x=6-i[3].length()-i[4].length()-i[5].length()
				$ItemList.add_item(i[0]+"       "+i[1]+"    ".repeat(y)+"    "+i[2]+"年"+i[3]
				+"月"+i[4]+"日"+i[5]+":"+i[6]+"  ".repeat(x)+"       "+i[7]+"元"+"          "+i[8])	
		else:
			for i in re:
				if i[1]==you:
					var y=4-i[1].length()
					var x=6-i[3].length()-i[4].length()-i[5].length()
					$ItemList.add_item(i[0]+"       "+i[1]+"    ".repeat(y)+"    "+i[2]+"年"+i[3]
					+"月"+i[4]+"日"+i[5]+":"+i[6]+"  ".repeat(x)+"       "+i[7]+"元"+"          "+i[8])	
	elif $cmp.selected==0&&$left.text!=""&&$right.text!="":
		var small=min(int($left.text),int($right.text))
		var maxip=max(int($left.text),int($right.text))
		$ItemList.clear()
		for i in re:
			if int(i[7])>=small&&int(i[7])<=maxip:
				var y=4-i[1].length()
				var x=6-i[3].length()-i[4].length()-i[5].length()
				$ItemList.add_item(i[0]+"       "+i[1]+"    ".repeat(y)+"    "+i[2]+"年"+i[3]
				+"月"+i[4]+"日"+i[5]+":"+i[6]+"  ".repeat(x)+"       "+i[7]+"元"+"          "+i[8])	
	else:
		var small=min(int($left.text),int($right.text))
		var maxip=max(int($left.text),int($right.text))
		$ItemList.clear()
		var you=$cmp.get_item_text($cmp.selected)
		for i in re:
			if int(i[7])>=small&&int(i[7])<=maxip&&i[1]==you:
				var y=4-i[1].length()
				var x=6-i[3].length()-i[4].length()-i[5].length()
				$ItemList.add_item(i[0]+"       "+i[1]+"    ".repeat(y)+"    "+i[2]+"年"+i[3]
				+"月"+i[4]+"日"+i[5]+":"+i[6]+"  ".repeat(x)+"       "+i[7]+"元"+"          "+i[8])	
	pass 
