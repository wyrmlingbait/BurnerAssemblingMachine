local BurnerAssemblingMachineItem = util.table.deepcopy(data.raw["item"]["assembling-machine-1"])
BurnerAssemblingMachineItem.name = "burner-assembling-machine"
BurnerAssemblingMachineItem.localised_name = {"burner-assembling-machine"}
BurnerAssemblingMachineItem.place_result = "burner-assembling-machine"
BurnerAssemblingMachineItem.icon = "__base__/graphics/icons/assembling-machine-0.png"
BurnerAssemblingMachineItem.order = "A[burner-assembling-machine]"

data:extend({BurnerAssemblingMachineItem})
