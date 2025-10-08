package game

import (
	"strconv"
	"chain/runtime"
)


var seed uint64 = 0
var players []User

func getRandomRarity(userLevel int) int {
	roll := random(10000)
	
	levelBonus := userLevel * 10
	
	if roll < 5000-levelBonus { 
		return RarityCommon
	} else if roll < 7500-levelBonus/2 { 
		return RarityUncommon
	} else if roll < 9000 { 
		return RarityRare
	} else if roll < 9700+levelBonus/4 { 
		return RarityEpic
	} else if roll < 9950+levelBonus/2 { 
		return RarityLegendary
	} else { 
		return RarityMythic
	}
}

func generateChestRewards(user *User) ChestReward {
	reward := ChestReward{
		Items: []Item{},
		Coins: 0,
		Experience: 0,
	}
	
	numItems := 1 + random(3)
	if user.Level > 20 {
		numItems = 2 + random(3) 
	}
	
	itemPool := getItemPool()
	
	for i := 0; i < numItems; i++ {
		targetRarity := getRandomRarity(user.Level)
		
		
		validItems := []Item{}
		for _, item := range itemPool {
			if item.Rarity == targetRarity && item.Level_min <= user.Level {
				validItems = append(validItems, item)
			}
		}
		
		
		if len(validItems) == 0 && targetRarity > RarityCommon {
			targetRarity--
			for _, item := range itemPool {
				if item.Rarity == targetRarity && item.Level_min <= user.Level {
					validItems = append(validItems, item)
				}
			}
		}
		
		if len(validItems) > 0 {
			selectedItem := validItems[random(len(validItems))]
			reward.Items = append(reward.Items, selectedItem)
		}
	}
	
	
	baseCoins := 10 + user.Level*5
	rarityBonus := 0
	for _, item := range reward.Items {
		rarityBonus += item.Rarity * 10
	}
	reward.Coins = baseCoins + rarityBonus + random(50)
	
	
	reward.Experience = 50 + user.Level*10 + random(30)
	
	return reward
}

func OpenDailyChest(cur realm) string {
	call_address := runtime.OriginCaller().String()
	seed += 1
	
	for i := range players {
		if players[i].Address != call_address {
			continue
		}
		
		
		reward := generateChestRewards(&players[i])
		
		
		for _, item := range reward.Items {
			players[i].Inventory = append(players[i].Inventory, item)
		}
		
		
		players[i].Coins += reward.Coins
		players[i].Experience += reward.Experience
		
		
		newLevel := players[i].Experience / 1000
		if newLevel > players[i].Level {
			players[i].Level = newLevel
			
			players[i].Strength += 5
			players[i].Defense += 5
			players[i].Magic += 5
		}
		
		players[i].LastDailyChest++ 
		
		
		out := "Daily Chest Opened! - "
		out += "Rewards: - "
		for _, item := range reward.Items {
			rarityStr := getRarityString(item.Rarity)
			out += "  " + rarityStr + " " + item.Name + " (" + item.Category + ") - "
		}
		out += "Coins: +" + strconv.Itoa(reward.Coins) + " (Total: " + strconv.Itoa(players[i].Coins) + ") - "
		out += "Experience: +" + strconv.Itoa(reward.Experience) + " (Total: " + strconv.Itoa(players[i].Experience) + ") - "
		players[i].updateLevel()
		out += "Level: " + strconv.Itoa(players[i].Level) 
		
		return out
	}
	
	return "No user found. Please create an account first!"
}

func getRarityString(rarity int) string {
	switch rarity {
	case RarityCommon:
		return "[Common]"
	case RarityUncommon:
		return "[Uncommon]"
	case RarityRare:
		return "[Rare]"
	case RarityEpic:
		return "[Epic]"
	case RarityLegendary:
		return "[Legendary]"
	case RarityMythic:
		return "[MYTHIC]"
	default:
		return "[Unknown]"
	}
}

func CreateUser(cur realm, username string) {
	seed += 1
	players = append(players, User{
		Level: 1,
		Address: runtime.OriginCaller().String(),
		Username: username,
		Inventory: []Item{},
		Coins: 100, 
		Experience: 0,
		Strength: 10,
		Defense: 10,
		Magic: 10,
		MaxHP: 100,
		CurrentHP: 100,
	})
}

func GetInventory(cur realm) string {
	call_address := runtime.OriginCaller().String()
	
	for i := range players {
		if players[i].Address != call_address {
			continue
		}
		
		out := "Inventory of " + players[i].Username + " - "
		out += "Level: " + strconv.Itoa(players[i].Level) + " | Coins: " + strconv.Itoa(players[i].Coins) + " - "
		out += "STR: " + strconv.Itoa(players[i].Strength) + " | DEF: " + strconv.Itoa(players[i].Defense) + " | MAG: " + strconv.Itoa(players[i].Magic) + " --- "
		
		if len(players[i].Inventory) == 0 {
			return out + "Empty inventory. Open your daily chest!"
		}
		
		categories := make(map[string][]Item)
		for _, item := range players[i].Inventory {
			categories[item.Category] = append(categories[item.Category], item)
		}
		
		for category, items := range categories {
			out += category + "s: - "
			for _, item := range items {
				out += "  " + getRarityString(item.Rarity) + " " + item.Name + " "
			}
			out += "               "
		}
		
		return out
	}
	
	return "No user found!"
}

func Random(_ realm) {
	seed += 1
}

func Render(_ string) string {
	out := "Game Stats\n\n"
	out += "Total Players: " + strconv.Itoa(len(players)) + "\n\n"
	
	if len(players) > 0 {
		out += "Leaderboard (by Level):\n"
		
		sortedPlayers := make([]User, len(players))
		copy(sortedPlayers, players)
		
		for i := 0; i < len(sortedPlayers)-1; i++ {
			for j := 0; j < len(sortedPlayers)-i-1; j++ {
				if sortedPlayers[j].Level < sortedPlayers[j+1].Level {
					sortedPlayers[j], sortedPlayers[j+1] = sortedPlayers[j+1], sortedPlayers[j]
				}
			}
		}
		
		max := 5
		if len(sortedPlayers) < 5 {
			max = len(sortedPlayers)
		}
		
		for i := 0; i < max; i++ {
			out += strconv.Itoa(i+1) + ". " + sortedPlayers[i].Username + " - Lvl " + strconv.Itoa(sortedPlayers[i].Level) + "\n"
		}
	}
	
	return out
}
