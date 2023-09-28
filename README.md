# Godot4 2D Top-Down game

Rougelike, should be similar to this game:
https://www.youtube.com/watch?v=e-RP-GHxxQA&ab_channel=Phibian


# MVP:

Tank(player) defends base against two types of enemies(infantry and tanks). Infantry can destroy base if close enough, tanks will only target player.

Tank(player) has to go out of base to get ammunition off dead enemies. And can store and retrieve ammunition from base.

Tank(Player) weapons:
    Machine gun is effective against infantry
    Tank turret is effective against tanks

**Godot scene structures:**

- Main Scene
    - Game Manager Node
    - Player Scene
        - Tank Node (with associated scripts, sprites, etc.)
    - Enemy Scene
        - Infantry Node (with associated scripts, sprites, etc.)
        - Tank Node (with associated scripts, sprites, etc.)
    - Ammo Pickup Scene
        - Ammo Pickup Node (with associated scripts, sprites, etc.)
    - Base Scene
        - Base Node (with associated scripts, sprites, etc.)
        - Ammo Storage Node (with associated scripts, sprites, etc.)
