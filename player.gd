extends CharacterBody2D

# 主角基础属性
@export var speed = 300
@export var max_health = 500
var current_health = 500
@export var max_exp = 1000
var current_exp = 0

# 攻击冷却
@export var attack_cooldown = 0.5
var can_attack = true

func _ready():
	# 初始化血条和经验条（需要你在UI里先建好ProgressBar）
	$UI/HealthBar.max_value = max_health
	$UI/HealthBar.value = current_health
	$UI/ExpBar.max_value = max_exp
	$UI/ExpBar.value = current_exp

func _physics_process(_delta):
	# 基础移动
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed
	move_and_slide()

	# 鼠标左键攻击
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_attack:
		perform_attack()

# 攻击逻辑
func perform_attack():
	can_attack = false
	var hit_area = $AttackHitbox
	var hit_list = hit_area.get_overlapping_bodies()

	for hit in hit_list:
		if hit.is_in_group("enemy"):
			hit.take_damage(10) # 小怪血条10，打一下就死

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

# 受伤逻辑
func take_damage(damage):
	current_health -= damage
	$UI/HealthBar.value = current_health
	print("主角受伤！当前血量：", current_health)
	
	if current_health <= 0:
		print("主角死亡！")
		queue_free()

# 获得经验
func add_exp(amount):
	current_exp += amount
	$UI/ExpBar.value = current_exp
	print("获得经验！当前经验：", current_exp)
	
	if current_exp >= max_exp:
		print("主角升级！")
		# 这里可以加升级逻辑，比如加血、加攻
		current_exp = 0
		max_health += 50
		current_health = max_health
		$UI/HealthBar.max_value = max_health
		$UI/HealthBar.value = current_health
		$UI/ExpBar.value = current_exp
