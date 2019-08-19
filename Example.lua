Cauldron.recipes["example-bindings"] = {
    enable = true,
    description = "An example of Cauldron_Bindings",
    bindings = {
        { key = "E", action = "MOVEFORWARD" },
        { key = "1", action = { attributes = { type = "spell", spell = "Flash Heal" } } },
        { action = { frame = PlayerFrame, attributes = { type1 = "spell", spell = "Flash Heal", type2 = "spell", spell2 = "Power Word: Shield" } } },
    }
}
