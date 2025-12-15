extends Node               #全局脚本,在不同场景可以通过远程链接到此节点的相关属性
@export var isload:bool    #是否登录 
@export var user_name:String       #当前用户名
@export var bud:int                #预算
@export var current_bud:int        #当前预算
@export var isadmin:bool           #是否为管理员
var sprite=preload("res://image/Almanac_IndexButton.png")      #预加载图片
var sprite1=preload("res://image/Almanac_IndexButtonHighlight.png")
