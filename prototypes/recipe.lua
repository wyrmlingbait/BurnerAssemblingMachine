local recipe = util.table.deepcopy(data.raw.recipe["assembling-machine-1"])
recipe.enabled = true
recipe.name = "burner-assembling-machine"
recipe.ingredients =
    {
      {"stone-furnace", 1},
      {"iron-gear-wheel", 3},
      {"iron-plate", 3}
    }
recipe.result = "burner-assembling-machine"
data:extend({recipe})
