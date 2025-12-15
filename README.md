爪哇部落后端组第一次考核项目，用godot做的记账管理小程序

# Godot记账管理小程序
基于Godot 4.x引擎开发的简易记账工具，是我学习Godot引擎的练手项目，实现了个人日常收支记录的基础功能。

## 项目介绍
### 开发背景
作为Godot引擎的学习实践项目，主要目的是熟悉GDScript语法、Godot的UI节点操作和简单数据处理逻辑。

### 核心功能
1. 手动录入收入/支出记录（支持填写金额、收支类型、备注信息）
2. 实时统计总收支、月度收支数据
3. 收支记录的查看、删除操作
4. 用户的注册登录注销功能
5. 预算的管理
6. 对各类型的收入支出进行统计

### 开发环境
- 引擎版本：Godot 4.5.1
- 开发语言：GDScript
- 运行平台：Windows

## 运行步骤
1. 下载并安装[Godot 4.x引擎](https://godotengine.org/download)
2. 克隆本仓库到本地：
   ```bash   ”“bash   ”“bash”“bash   ”“bash”“bash“bash”“bash”“bash”“bash”“bash”“bash”“bash
   git clone https://github.com/你的用户名/仓库名.git
3. 在release有项目编译后的exe文件,其中pck文件是资源文件

## 详细说明
```text   ' ' '文本
godot-account-book/
├─ code/          # GDScript脚本目录（核心逻辑代码）
│  |─ add_money.gd   # 记账管理界面功能脚本
|  |─ buffet.gd      # 预算管理界面功能脚本 
|  |─ come_back.gd   # 返回主界面按钮事件功能脚本
|  |─ creat_user.gd  # 注册用户界面功能脚本
|  |─ data.gd        # 存储数据的Resource类定义脚本
|  |─ load_user.gd   # 用户登录界面功能脚本
|  |─ manager.gd     # 统计查询界面功能脚本
|  |─ meue.gd        # 主界面功能脚本
|  |─ statemanger.gd # 全局数据管理脚本
|  L─ text.gd        # 文字功能脚本
├─ font/          # 项目字体资源
├─ image/         # 界面图片素材
├─ tscn/          # Godot场景文件（UI布局）
├─ README.md      # 项目说明文档
└─ project.godot  # Godot项目核心配置文件
```
## GDScript语法要点
本项目主要用到GDScript的基础语法，与python类似，末尾无需分号,核心知识点如下：
1. **变量与数据类型**
   - 用`var`定义变量，支持动态类型（如`var money = 0`表示收支金额，`var note = ""`表示备注信息）。
   - 常用类型：`int`（整数）、`String`（字符串）、`Array`（数组，存储收支记录）。

2. **函数定义**
   - 用`func`定义函数，如收支录入功能：
     ```gdscript   “”“gdscript
     func add_income(amount: int, desc: String):函数add_income(amount: int, desc: String)：
         money += amount   钱=金额
         record_list.append({"type": "收入", "amount": amount, "desc": desc})record_list。追加({“类型”:“收入”,“数量”:,“desc”:desc})
     ```
2. **条件判断**
   - 用`if-else-elif`判断：
     ```gdscript   “”“gdscript' ' ' gdscript”“gdscript
     var a=2
     var b=3
     if b>a:
        print("true"   “真正的”)
     elif b==a:
        print("same")   打印(“相同”)
     else:   其他:
        print("false")   打印(“错误”)
     ```

3. **节点操作**
   - 通过`$节点名`获取UI节点，如获取输入框内容：`var input_amount = $LineEdit_amount.text.to_int()`。
   - 绑定按钮点击事件：`$Button_add.pressed.connect(add_income)`。

4. **数据处理**
   - 用`for`循环遍历收支记录数组，实现数据统计：
     ```gdscript   “”“gdscript
     func calculate_total():
         var total = 0
         for record in record_list:对于record_list中的记录：
             total += record["amount"]
         return total
     ```
5. **内置操作**
 - extends用于指定当前脚本继承的父类 `extends control`,此时表示该功能脚本继承control节点(control节点为ui界面节点)
 - @export用于将变量暴露到godot的编辑器，提供可视化修改 `@export var see:int=0`此时see变量可在编辑器修改

##项目核心节点类型说明
本项目基于 Godot 4.x 开发，核心使用的节点类型及功能如下：
### 一、 基础显示与布局节点
1. **Label**
   - 作用：显示静态文本，支持字体、颜色、对齐方式调整。
   - 项目应用：展示界面标题（如“简易记账工具”）、收支统计数据（如“总余额：XXX元”）、功能提示文字。
2. **ColorRect**
   - 作用：显示纯色矩形，可设置颜色、透明度，支持作为背景或分隔线。
   - 项目应用：作为功能模块的背景底色（如收支录入区的浅色背景）、界面分隔条，区分不同功能区域。
3. **TextureRect**
   - 作用：显示图片纹理，支持拉伸、平铺、保持比例等显示模式。
   - 项目应用：展示程序 logo、功能图标（如收入项的“+”图标、支出项的“-”图标）。

### 二、 交互控件节点
1. **Button**
   - 作用：响应点击事件，触发功能逻辑。
   - 项目应用：“添加收入”“添加支出”“删除记录”“清空数据”等功能触发按钮。
2. **OptionButton**
   - 作用：提供下拉选择列表，支持单选选项。
   - 项目应用：选择收支类型（收入/支出）、筛选记录的时间范围（今日/本周/本月）。
3. **ItemList**
   - 作用：展示可选择的条目列表，支持单选/多选、条目高度自定义。
   - 项目应用：展示所有收支记录条目，方便用户查看和选中待删除的记录。
4. **TextEdit**
   - 作用：支持多行文本输入与显示，可用于备注或长文本内容编辑。
   - 项目应用：录入收支记录的详细备注信息（如“购买办公用品”“工资收入”）。

### 三、 功能辅助节点
1. **AnimationPlayer**
   - 作用：管理和播放动画，支持属性动画（如位置、颜色、透明度变化）。
   - 项目应用：实现按钮点击的高亮动画、记录添加/删除时的过渡效果、界面切换的淡入淡出动画。
