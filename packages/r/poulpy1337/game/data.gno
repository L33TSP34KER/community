package game

import "math/rand"

const (
	CategoryWeapon = "Weapon"
	CategoryArmor = "Armor"
	CategoryPotion = "Potion"
	CategoryMaterial = "Material"
	CategoryPet = "Pet"
	CategoryCosmetic = "Cosmetic"
)

const (
	RarityCommon = 1
	RarityUncommon = 2
	RarityRare = 3
	RarityEpic = 4
	RarityLegendary = 5
	RarityMythic = 6
)

type Item struct {
	Category string
	Name string
	Level_min int 
	Rarity int
	Value int 
	Stats map[string]int 
}

type InterItem interface {
	GetBase() Item
}

type User struct {
	Level int
	Address string
	Username string
	Inventory []Item
	LastDailyChest int
	Coins int
	Experience int
	Strength int
	Defense int
	Magic int
	CurrentHP int
	MaxHP int
	DungeonProgress int
	CurrentDungeon int
}

type ChestReward struct {
	Items []Item
	Coins int
	Experience int
}

func getItemPool() []Item {
	return ItemPool
}

func random(max int) int {
	r := rand.New(rand.NewPCG(seed, 0))
	return r.Int() % max
}

func (u *User) updateLevel() {
    if u.Experience > 100 * u.Level {
		u.Level += 1
		u.Strength += 5
		u.Defense += 5
		u.Magic += 5
		u.Experience = 0
		u.MaxHP *= u.Level
		u.CurrentHP = u.MaxHP
	}
}


type Enemy struct {
	Name string
	Level int
	HP int
	MaxHP int
	Damage int
	Defense int
	ExpReward int
	CoinReward int
	IsBoss bool
}

type DungeonFloor struct {
	FloorNumber int
	Enemy Enemy
	Defeated bool
}

type Dungeon struct {
	Name string
	MinLevel int
	MaxFloors int
	DifficultyMultiplier float64
}
