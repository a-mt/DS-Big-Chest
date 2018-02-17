-- List of all the files in <modname>/scripts/prefabs that you want to load prefabs from
PrefabFiles = {
    "big_chest"
}

-- Add Recipe
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS    = GLOBAL.STRINGS
local TECH       = GLOBAL.TECH

local function AddRecipe(style, fuel, order)
    local chest     = Recipe(style, {Ingredient("boards", 3), Ingredient("nightmarefuel", fuel)}, RECIPETABS.MAGIC, TECH.MAGIC_ONE, "treasurechest_placer", 1)
    chest.product   = style
    chest.atlas     = "images/inventoryimages/big_chest.xml"
    chest.image     = "big_chest.tex"
    chest.sortkey   = GLOBAL.GetRecipe("treasurechest")["sortkey"] + order
    chest.numtogive = 1
end

AddRecipe("medium_chest", 2, 0.1)
STRINGS.NAMES.MEDIUM_CHEST       = "Medium Chest"
STRINGS.RECIPE_DESC.MEDIUM_CHEST = "A bigger container (5x5)."

AddRecipe("big_chest", 6, 0.2)
STRINGS.NAMES.BIG_CHEST          = "Big Chest"
STRINGS.RECIPE_DESC.BIG_CHEST    = "The biggest container (9x9)."