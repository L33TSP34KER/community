package game

import (
	"strconv"
	"chain/runtime"
)

func getDungeonList() []Dungeon {
	return []Dungeon{
		{Name: "Goblin Cave", MinLevel: 1, MaxFloors: 5, DifficultyMultiplier: 1.0},
		{Name: "Dark Forest", MinLevel: 5, MaxFloors: 10, DifficultyMultiplier: 1.3},
		{Name: "Abandoned Mine", MinLevel: 10, MaxFloors: 15, DifficultyMultiplier: 1.5},
		{Name: "Cursed Crypt", MinLevel: 15, MaxFloors: 20, DifficultyMultiplier: 1.8},
		{Name: "Dragon's Lair", MinLevel: 25, MaxFloors: 25, DifficultyMultiplier: 2.2},
		{Name: "Demon Fortress", MinLevel: 35, MaxFloors: 30, DifficultyMultiplier: 2.5},
		{Name: "Void Temple", MinLevel: 45, MaxFloors: 40, DifficultyMultiplier: 3.0},
		{Name: "Tower of Eternity", MinLevel: 60, MaxFloors: 50, DifficultyMultiplier: 4.0},
	}
}

func getEnemyTemplates() map[string][]string {
	return map[string][]string{
		"Goblin Cave": {"Goblin Scout", "Goblin Warrior", "Goblin Shaman", "Goblin Brute", "Goblin King"},
		"Dark Forest": {"Wild Wolf", "Dark Sprite", "Treant", "Shadow Beast", "Forest Guardian"},
		"Abandoned Mine": {"Cave Bat", "Skeleton Miner", "Rock Golem", "Zombie Worker", "Mine Overseer"},
		"Cursed Crypt": {"Skeleton Knight", "Wraith", "Vampire Spawn", "Lich", "Crypt Lord"},
		"Dragon's Lair": {"Dragon Whelp", "Dragonkin Warrior", "Fire Elemental", "Dragon Guard", "Ancient Dragon"},
		"Demon Fortress": {"Imp", "Demon Warrior", "Hell Hound", "Demon Lord", "Demon Emperor"},
		"Void Temple": {"Void Walker", "Shadow Assassin", "Void Cultist", "Void Priest", "Void Entity"},
		"Tower of Eternity": {"Time Guardian", "Celestial Knight", "Arcane Sentinel", "Elder Mage", "Time Lord"},
	}
}

func generateEnemy(dungeon Dungeon, floor int) Enemy {
	templates := getEnemyTemplates()
	enemyNames := templates[dungeon.Name]
	
	isBoss := (floor == dungeon.MaxFloors)
	
	var enemyName string
	if isBoss {
		enemyName = enemyNames[len(enemyNames)-1]
	} else {
		index := (floor * len(enemyNames)) 
		if index >= len(enemyNames)-1 {
			index = len(enemyNames) - 2
		}
		enemyName = enemyNames[index]
	}
	
	baseHP := 30 + floor*10
	baseDamage := 5 + floor*2
	baseDefense := 2 + floor
	expReward := 20 + floor*5
	coinReward := 10 + floor*3
	
	if isBoss {
		baseHP = int(float64(baseHP) * (1.5 * dungeon.DifficultyMultiplier))
		baseDamage = int(float64(baseDamage) * (1.1 * dungeon.DifficultyMultiplier))
		baseDefense = int(float64(baseDefense) * (1.0 * dungeon.DifficultyMultiplier))

		expReward = expReward * 5
		coinReward = coinReward * 5
		enemyName = "BOSS: " + enemyName
	}
	
	baseHP = int(float64(baseHP) * dungeon.DifficultyMultiplier)
	baseDamage = int(float64(baseDamage) * dungeon.DifficultyMultiplier)
	expReward = int(float64(expReward) * dungeon.DifficultyMultiplier)
	coinReward = int(float64(coinReward) * dungeon.DifficultyMultiplier)
	
	return Enemy{
		Name: enemyName,
		Level: dungeon.MinLevel + (floor * 2),
		HP: baseHP,
		MaxHP: baseHP,
		Damage: baseDamage,
		Defense: baseDefense,
		ExpReward: expReward,
		CoinReward: coinReward,
		IsBoss: isBoss,
	}
}

func calculatePlayerDamage(player *User) int {
	baseDamage := player.Strength
	
	for _, item := range player.Inventory {
		if item.Category == CategoryWeapon {
			if damageBonus, ok := item.Stats["damage"]; ok {
				baseDamage += damageBonus / 10
			}
			if magicBonus, ok := item.Stats["magic"]; ok {
				baseDamage += magicBonus / 10
			}
		}
		if item.Category == CategoryPet {
			if bonus, ok := item.Stats["damage_bonus"]; ok {
				baseDamage += bonus
			}
			if bonus, ok := item.Stats["all_stats"]; ok {
				baseDamage += bonus / 2
			}
		}
	}
	
	return baseDamage + random(10) - 5
}

func calculatePlayerDefense(player *User) int {
	baseDefense := player.Defense
	
	for _, item := range player.Inventory {
		if item.Category == CategoryArmor {
			if defenseBonus, ok := item.Stats["defense"]; ok {
				baseDefense += defenseBonus / 10
			}
		}
		if item.Category == CategoryPet {
			if bonus, ok := item.Stats["all_stats"]; ok {
				baseDefense += bonus / 2
			}
		}
	}
	
	return baseDefense
}

func ListDungeons(cur realm) string {
	call_address := runtime.OriginCaller().String()
	
	dungeons := getDungeonList()
	
	var userLevel int
	for i := range players {
		if players[i].Address == call_address {
			userLevel = players[i].Level
			break
		}
	}
	
	out := "Available Dungeons:\n\n"
	
	for i, dungeon := range dungeons {
		out += strconv.Itoa(i) + ". " + dungeon.Name + "\n"
		out += "   Min Level: " + strconv.Itoa(dungeon.MinLevel)
		
		if userLevel < dungeon.MinLevel {
			out += " LOCKED"
		} else {
			out += " OPEN"
		}
		
		out += "\n   Floors: " + strconv.Itoa(dungeon.MaxFloors) + "\n"
		out += "   Difficulty: "
		
		stars := int(dungeon.DifficultyMultiplier)
		for j := 0; j < stars; j++ {
			out += "⭐"
		}
		out += "\n\n"
	}
	
	out += "Use EnterDungeon(index) to start!"
	
	return out
}

func EnterDungeon(cur realm, dungeonIndex int) string {
	call_address := runtime.OriginCaller().String()
	seed += 1
	
	dungeons := getDungeonList()
	
	if dungeonIndex < 0 || dungeonIndex >= len(dungeons) {
		return "Invalid dungeon selection!"
	}
	
	selectedDungeon := dungeons[dungeonIndex]
	
	for i := range players {
		if players[i].Address != call_address {
			continue
		}
		
		if players[i].Level < selectedDungeon.MinLevel {
			return "Level " + strconv.Itoa(selectedDungeon.MinLevel) + " required for " + selectedDungeon.Name + "!"
		}
		
		players[i].CurrentHP = players[i].MaxHP
		players[i].CurrentDungeon = dungeonIndex
		players[i].DungeonProgress = 1
		
		enemy := generateEnemy(selectedDungeon, 1)
		
		out := "Entered: " + selectedDungeon.Name + "\n"
		out += "Floor 1/" + strconv.Itoa(selectedDungeon.MaxFloors) + "\n\n"
		out += "Enemy Encountered!\n"
		out += enemy.Name + " (Lvl " + strconv.Itoa(enemy.Level) + ")\n"
		out += "HP: " + strconv.Itoa(enemy.HP) + "/" + strconv.Itoa(enemy.MaxHP) + "\n"
		out += "ATK: " + strconv.Itoa(enemy.Damage) + " | DEF: " + strconv.Itoa(enemy.Defense) + "\n\n"
		out += "Your HP: " + strconv.Itoa(players[i].CurrentHP) + "/" + strconv.Itoa(players[i].MaxHP) + "\n"
		out += "Use AttackEnemy() to fight!"
		
		return out
	}
	
	return "No user found!"
}

func AttackEnemy(cur realm) string {
	call_address := runtime.OriginCaller().String()
	seed += 1
	
	for i := range players {
		if players[i].Address != call_address {
			continue
		}
		
		if players[i].DungeonProgress == 0 {
			return "You're not in a dungeon! Use EnterDungeon() first."
		}
		
		dungeons := getDungeonList()
		currentDungeon := dungeons[players[i].CurrentDungeon]
		
		out := "DUNGEON RUN START!\n"
		out += currentDungeon.Name + "\n"
		out += "Starting HP: " + strconv.Itoa(players[i].CurrentHP) + "/" + strconv.Itoa(players[i].MaxHP) + "\n\n"
		
		// Fight through all floors
		for players[i].DungeonProgress <= currentDungeon.MaxFloors {
			enemy := generateEnemy(currentDungeon, players[i].DungeonProgress)
			
			out += "=== FLOOR " + strconv.Itoa(players[i].DungeonProgress) + "/" + strconv.Itoa(currentDungeon.MaxFloors) + " ===\n"
			out += enemy.Name + " (Lvl " + strconv.Itoa(enemy.Level) + ")\n"
			out += "Enemy HP: " + strconv.Itoa(enemy.HP) + "\n\n"
			
			roundNum := 1
			
			// Fight current enemy
			for {
				out += "Round " + strconv.Itoa(roundNum) + ": "
				
				playerDamage := calculatePlayerDamage(&players[i])
				actualDamage := playerDamage - enemy.Defense
				if actualDamage < 1 {
					actualDamage = 1
				}
				enemy.HP -= actualDamage
				
				out += "You deal " + strconv.Itoa(actualDamage) + " dmg"
				
				if enemy.HP <= 0 {
					out += " - Enemy defeated!\n"
					
					players[i].Experience += enemy.ExpReward
					players[i].Coins += enemy.CoinReward
					
					out += "Rewards: +" + strconv.Itoa(enemy.CoinReward) + " coins, +" + strconv.Itoa(enemy.ExpReward) + " exp\n"
					
					players[i].updateLevel()
					
					if enemy.IsBoss {
						reward := generateChestRewards(&players[i])
						out += "\nBOSS DEFEATED! Loot:\n"
						for _, item := range reward.Items {
							players[i].Inventory = append(players[i].Inventory, item)
							out += "  " + item.Name + " (" + getRarityString(item.Rarity) + ")\n"
						}
						players[i].DungeonProgress = 0
						out += "\nDUNGEON COMPLETE!\n"
						out += "Final HP: " + strconv.Itoa(players[i].CurrentHP) + "/" + strconv.Itoa(players[i].MaxHP)
						return out
					}
					
					healAmount := players[i].MaxHP / 10
					players[i].CurrentHP += healAmount
					if players[i].CurrentHP > players[i].MaxHP {
						players[i].CurrentHP = players[i].MaxHP
					}
					
					out += "Healed +" + strconv.Itoa(healAmount) + " HP\n"
					out += "Current HP: " + strconv.Itoa(players[i].CurrentHP) + "/" + strconv.Itoa(players[i].MaxHP) + "\n\n"
					
					break
				}
				
				enemyDamage := enemy.Damage - calculatePlayerDefense(&players[i])
				if enemyDamage < 1 {
					enemyDamage = 1
				}
				players[i].CurrentHP -= enemyDamage
				
				out += ", Enemy deals " + strconv.Itoa(enemyDamage) + " dmg"
				out += " (Your HP: " + strconv.Itoa(players[i].CurrentHP) + "/" + strconv.Itoa(players[i].MaxHP) + ")\n"
				
				if players[i].CurrentHP <= 0 {
					players[i].CurrentHP = players[i].MaxHP
					players[i].DungeonProgress = 0
					coinLoss := players[i].Coins / 10
					players[i].Coins -= coinLoss
					if players[i].Coins < 0 {
						players[i].Coins = 0
					}
					out += "\nDEFEATED on floor " + strconv.Itoa(players[i].DungeonProgress) + "!\n"
					out += "Lost " + strconv.Itoa(coinLoss) + " coins.\n"
					out += "HP restored to " + strconv.Itoa(players[i].MaxHP) + "."
					return out
				}
				
				roundNum++
			}
			
			players[i].DungeonProgress++
		}
		
		return out
	}
	
	return "No user found!"
}
