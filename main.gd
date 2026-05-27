extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_rate = 1.0
@export var spawn_distance = 50

var player: CharacterBody2D

func _ready():
	player = $Player
	$SpawnTimer.wait_time = spawn_rate

func _on_spawn_timer_timeout():
	if not enemy_scene or not player:
		return

	var enemy = enemy_scene.instantiate()
	enemy.player = player
	add_child(enemy)

	# ↓↓↓ 这是真正的【四周随机生成】代码 ↓↓↓
	var screen_size = get_viewport_rect().size
	var side = randi() % 4
	var pos = Vector2()

	match side:
		0: pos = Vector2(randf() * screen_size.x, -spawn_distance)       # 上方
		1: pos = Vector2(randf() * screen_size.x, screen_size.y + spawn_distance) # 下方
		2: pos = Vector2(-spawn_distance, randf() * screen_size.y)       # 左方
		3: pos = Vector2(screen_size.x + spawn_distance, randf() * screen_size.y) # 右方

	enemy.position = pos
