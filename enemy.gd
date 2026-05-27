extends CharacterBody2D

@export var speed = 100
@export var player: CharacterBody2D
@export var max_health = 10
var current_health = 10
@export var damage = 5
var can_attack = true

func _ready():
	add_to_group("enemy")
	$HealthBar.max_value = max_health
	$HealthBar.value = current_health

func _physics_process(_delta):
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()

# 碰撞到玩家就掉血
func _on_body_entered(body):
	if body.name == "Player" and can_attack:
		can_attack = false
		body.take_damage(damage)
		await get_tree().create_timer(1.0).timeout
		can_attack = true

func take_damage(value):
	current_health -= value
	$HealthBar.value = current_health
	if current_health <= 0:
		die()

func die():
	if $DeathParticles:
		$DeathParticles.emitting = true
	if player:
		player.add_exp(50)
	queue_free()

func _on_hitbox_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.
