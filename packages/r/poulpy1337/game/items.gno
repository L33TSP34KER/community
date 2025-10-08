package game


var ItemPool []Item = []Item{
	{Category: CategoryWeapon, Name: "Rusty Sword", Level_min: 1, Rarity: RarityCommon, Value: 10, Stats: map[string]int{"damage": 5}},
	{Category: CategoryWeapon, Name: "Wooden Staff", Level_min: 1, Rarity: RarityCommon, Value: 10, Stats: map[string]int{"magic": 5}},
	{Category: CategoryWeapon, Name: "Short Bow", Level_min: 1, Rarity: RarityCommon, Value: 12, Stats: map[string]int{"damage": 6}},
	
	{Category: CategoryWeapon, Name: "Steel Sword", Level_min: 5, Rarity: RarityUncommon, Value: 50, Stats: map[string]int{"damage": 15}},
	{Category: CategoryWeapon, Name: "Oak Staff", Level_min: 5, Rarity: RarityUncommon, Value: 50, Stats: map[string]int{"magic": 15}},
	{Category: CategoryWeapon, Name: "Crossbow", Level_min: 5, Rarity: RarityUncommon, Value: 55, Stats: map[string]int{"damage": 18}},
	{Category: CategoryWeapon, Name: "War Hammer", Level_min: 7, Rarity: RarityUncommon, Value: 60, Stats: map[string]int{"damage": 20}},
	
	{Category: CategoryWeapon, Name: "Enchanted Blade", Level_min: 10, Rarity: RarityRare, Value: 200, Stats: map[string]int{"damage": 35, "magic": 10}},
	{Category: CategoryWeapon, Name: "Crystal Staff", Level_min: 10, Rarity: RarityRare, Value: 200, Stats: map[string]int{"magic": 40}},
	{Category: CategoryWeapon, Name: "Dragon Bow", Level_min: 12, Rarity: RarityRare, Value: 250, Stats: map[string]int{"damage": 45}},
	
	{Category: CategoryWeapon, Name: "Flamebringer", Level_min: 20, Rarity: RarityEpic, Value: 1000, Stats: map[string]int{"damage": 70, "magic": 30}},
	{Category: CategoryWeapon, Name: "Void Staff", Level_min: 20, Rarity: RarityEpic, Value: 1000, Stats: map[string]int{"magic": 80}},
	{Category: CategoryWeapon, Name: "Shadow Daggers", Level_min: 18, Rarity: RarityEpic, Value: 900, Stats: map[string]int{"damage": 65}},
	
	{Category: CategoryWeapon, Name: "Excalibur", Level_min: 30, Rarity: RarityLegendary, Value: 5000, Stats: map[string]int{"damage": 120, "magic": 50}},
	{Category: CategoryWeapon, Name: "Staff of Eternity", Level_min: 30, Rarity: RarityLegendary, Value: 5000, Stats: map[string]int{"magic": 150}},
	
	{Category: CategoryWeapon, Name: "Godslayer", Level_min: 50, Rarity: RarityMythic, Value: 20000, Stats: map[string]int{"damage": 250, "magic": 100}},
	
	{Category: CategoryArmor, Name: "Cloth Tunic", Level_min: 1, Rarity: RarityCommon, Value: 8, Stats: map[string]int{"defense": 3}},
	{Category: CategoryArmor, Name: "Leather Vest", Level_min: 1, Rarity: RarityCommon, Value: 10, Stats: map[string]int{"defense": 5}},
	{Category: CategoryArmor, Name: "Iron Helmet", Level_min: 2, Rarity: RarityCommon, Value: 15, Stats: map[string]int{"defense": 4}},
	
	{Category: CategoryArmor, Name: "Steel Chainmail", Level_min: 5, Rarity: RarityUncommon, Value: 60, Stats: map[string]int{"defense": 20}},
	{Category: CategoryArmor, Name: "Reinforced Boots", Level_min: 5, Rarity: RarityUncommon, Value: 40, Stats: map[string]int{"defense": 12}},
	{Category: CategoryArmor, Name: "Guardian Shield", Level_min: 6, Rarity: RarityUncommon, Value: 70, Stats: map[string]int{"defense": 25}},
	
	{Category: CategoryArmor, Name: "Dragon Scale Mail", Level_min: 10, Rarity: RarityRare, Value: 300, Stats: map[string]int{"defense": 50, "magic": 15}},
	{Category: CategoryArmor, Name: "Mystic Robes", Level_min: 10, Rarity: RarityRare, Value: 250, Stats: map[string]int{"defense": 30, "magic": 40}},
	
	{Category: CategoryArmor, Name: "Titan Plate", Level_min: 20, Rarity: RarityEpic, Value: 1200, Stats: map[string]int{"defense": 100}},
	{Category: CategoryArmor, Name: "Void Armor", Level_min: 20, Rarity: RarityEpic, Value: 1100, Stats: map[string]int{"defense": 80, "magic": 60}},
	
	{Category: CategoryArmor, Name: "Celestial Aegis", Level_min: 30, Rarity: RarityLegendary, Value: 6000, Stats: map[string]int{"defense": 180, "magic": 80}},
	
	{Category: CategoryPotion, Name: "Minor Health Potion", Level_min: 1, Rarity: RarityCommon, Value: 5, Stats: map[string]int{"heal": 20}},
	{Category: CategoryPotion, Name: "Minor Mana Potion", Level_min: 1, Rarity: RarityCommon, Value: 5, Stats: map[string]int{"mana": 20}},
	{Category: CategoryPotion, Name: "Stamina Tonic", Level_min: 1, Rarity: RarityCommon, Value: 6, Stats: map[string]int{"stamina": 30}},
	
	{Category: CategoryPotion, Name: "Health Potion", Level_min: 5, Rarity: RarityUncommon, Value: 25, Stats: map[string]int{"heal": 50}},
	{Category: CategoryPotion, Name: "Mana Potion", Level_min: 5, Rarity: RarityUncommon, Value: 25, Stats: map[string]int{"mana": 50}},
	{Category: CategoryPotion, Name: "Strength Elixir", Level_min: 7, Rarity: RarityUncommon, Value: 30, Stats: map[string]int{"strength_boost": 10}},
	
	{Category: CategoryPotion, Name: "Greater Health Potion", Level_min: 10, Rarity: RarityRare, Value: 100, Stats: map[string]int{"heal": 150}},
	{Category: CategoryPotion, Name: "Phoenix Elixir", Level_min: 15, Rarity: RarityRare, Value: 200, Stats: map[string]int{"revive": 1}},
	
	{Category: CategoryPotion, Name: "Elixir of Giants", Level_min: 20, Rarity: RarityEpic, Value: 500, Stats: map[string]int{"strength_boost": 50, "defense_boost": 50}},
	
	{Category: CategoryMaterial, Name: "Iron Ore", Level_min: 1, Rarity: RarityCommon, Value: 3},
	{Category: CategoryMaterial, Name: "Wood Logs", Level_min: 1, Rarity: RarityCommon, Value: 2},
}
