extends "res://scripts/ai/enemy.gd"

@onready var burn_timer = $BurnTimer
@onready var animation_player = $AnimationPlayer
@onready var ray_cast_player = $PlayerDetection
@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_bomber_chase_state = $FiniteStateMachine/EnemyBomberChaseState as EnemyBomberChaseState
@onready var enemy_bomber_attack_state = $FiniteStateMachine/EnemyBomberAttackState as EnemyBomberAttackState

var player # Reference to the player node or position
var target_dir

@export var heart_drop : PackedScene

func _ready():
	super._ready() # Make parent also run its ready functiona
	player = get_node("/root/Game/MainScene/Player")
	burn_timer.wait_time = 2
	ray_cast_player.target_position.x = detect_radius
	
	# On attack_player, chase -> wander
	enemy_bomber_chase_state.attack_player.connect(fsm.change_state.bind(enemy_bomber_attack_state))
	# On out_of_range, attack -> chase
	enemy_bomber_attack_state.out_of_range.connect(fsm.change_state.bind(enemy_bomber_chase_state))


func die():
	queue_free()
	emit_signal("died", self, score_value, experience_drop, null, heart_drop, preload("res://scenes/particles/impact_explosion.tscn"), global_position)


func take_damage(damage):
	if not alive:
		return
	animation_player.play("take_damage")
	health -= damage
	emit_signal("health_changed", health * 100/max_health)
	if (health <= 0):
		alive = false
		animation_player.play("explode") # Destroy object

var burn_count = 0
var burn_damage
func burn(damage):
	# Play burn particles
	$Burn.emitting = true
	# Apply damage
	burn_damage = damage
	take_damage(damage)
	burn_timer.start()

func _physics_process(delta):
	if not alive:
		return
	
	if target:
		target_dir = (target.global_position - global_position).normalized()

func _on_GunTimer_timeout():
	can_shoot = true
	
func _on_MachineGunTimer_timeout():
	can_shoot = true

func _on_burn_timer_timeout():
	burn_count += 1
	if burn_count < 4:
		burn(burn_damage)
	else:
		burn_count = 0

func _on_detect_radius_body_entered(body):
	if body.name == "Player":
		target = body

func _on_detect_radius_body_exited(body):
	if body == target:
		target = null


