package game

import (
	"chain/runtime"
	"strconv"
	"strings"
	"time"
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
		

		if time.Since(players[i].LastDailyChest) < 24*time.Hour{
			players[i].Render = "Daily chest already open please wait 24h"
			return "";
		}
		players[i].LastDailyChest = time.Now()
		
		reward := generateChestRewards(&players[i])
		
		
		for _, item := range reward.Items {
			players[i].Inventory = append(players[i].Inventory, item)
		}
		
		
		players[i].Coins += reward.Coins
		players[i].Experience += reward.Experience
		
		players[i].updateLevel();
		
		players[i].LastDailyChest = time.Now()
		
		
		out := "# Daily Chest Opened! \n\n"
		out += "Rewards: \n\n"
		for _, item := range reward.Items {
			rarityStr := getRarityString(item.Rarity)
			out += " - " + rarityStr + " " + item.Name + " (" + item.Category + ") \n\n"
		}
		out += "\n\nCoins: +" + strconv.Itoa(reward.Coins) + " (Total: " + strconv.Itoa(players[i].Coins) + ") \n"
		out += "Experience: +" + strconv.Itoa(reward.Experience) + " (Total: " + strconv.Itoa(players[i].Experience) + ") \n"
		players[i].updateLevel()
		out += "Level: " + strconv.Itoa(players[i].Level)  + "\n"
		players[i].Render = out;
		return ""
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

func CreateUser(cur realm, username string) string {
	username = strings.TrimSpace(username)

	for _, r := range username {
		if !((r >= 'a' && r <= 'z') ||
			(r >= 'A' && r <= 'Z') ||
			(r >= '0' && r <= '9')) {
			return "username can only contain letters and digits"
		}
	}

	if username == "" {
		return "username cannot be empty"
	}

	for _, p := range players {
		if strings.EqualFold(p.Username, username) {
			return "username '" + username + "' already exists"
		}
	}

	seed += 1
	newPlayer := User{
		Level:      1,
		Address:    runtime.OriginCaller().String(),
		Username:   username,
		Inventory:  []Item{},
		Coins:      100,
		Experience: 0,
		Strength:   10,
		Defense:    10,
		Magic:      10,
		MaxHP:      100,
		CurrentHP:  100,
		LastDailyChest: time.Now(),
	}

	newPlayer.Render = "## Welcome to the Realm of Chains RPG!\n\n" +
	"Your journey begins now, " + username + ".\n" +
	"All gameplay happens through the blockchain contract use its functions to explore, battle, and earn rewards.\n\n" +
	"Check the contract interface to start your adventure!"

	players = append(players, newPlayer)
	return "Welcome"
}


func GetInventory(cur realm) string {
	call_address := runtime.OriginCaller().String()
	
	for i := range players {
		if players[i].Address != call_address {
			continue
		}
		
		out := "Inventory of " + players[i].Username + " \n\n "
		out += "Level: " + strconv.Itoa(players[i].Level) + " | Coins: " + strconv.Itoa(players[i].Coins) + " \n\n "
		out += "STR: " + strconv.Itoa(players[i].Strength) + " | DEF: " + strconv.Itoa(players[i].Defense) + " | MAG: " + strconv.Itoa(players[i].Magic) + " \n\n"
		
		if len(players[i].Inventory) == 0 {
			return out + "Empty inventory. Open your daily chest!"
		}
		
		categories := make(map[string][]Item)
		for _, item := range players[i].Inventory {
			categories[item.Category] = append(categories[item.Category], item)
		}
		
		for category, items := range categories {
			out += "\n\n### " + category + "s: \n\n"
			for _, item := range items {
				out += " - " + getRarityString(item.Rarity) + " " + item.Name + "\n\n"
			}
			out += "\n\n"
		}
		
		players[i].Render = out
	}
	
	return "No user found!"
}

func Render(path string) string {
	parts := strings.Split(path, "=")

	if len(parts) >= 2 {
		if parts[0] != "view" {
			return "";
		}
		for i := 0; i < len(players); i++ {
			if (players[i].Username == parts[1]) {
				return players[i].Render
			}
		}
		return "User not found please check the username"
	}
	out := "Game Stats\n\n"
	out += "Tips: you can should go to :view=yourusername to see what you are doing\n\n"
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
