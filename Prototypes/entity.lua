local BurnerAssemblingMachine = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"])

BurnerAssemblingMachine.name = "burner-assembling-machine"
BurnerAssemblingMachine.order = "a[burner-assembling-machine]"
BurnerAssemblingMachine.minable = {mining_time = 0.2, result = "burner-assembling-machine"}
BurnerAssemblingMachine.energy_source =
    {
      type = "burner",
      fuel_category = "chemical",
      effectivity = 1,
      fuel_inventory_size = 1,
      emissions_per_second_per_watt = 10 / 150000,
      smoke =
      {
        {
          name = "smoke",
          deviation = {0.1, 0.1},
          frequency = 5
        }
      }
    }
BurnerAssemblingMachine.localised_name = {"burner-assembling-machine"}
BurnerAssemblingMachine.crafting_categories = {"wyrm-burner-crafting"}
BurnerAssemblingMachine.icon = "__base__/graphics/icons/assembling-machine-0.png"
BurnerAssemblingMachine.animation =
    {
      layers =
      {
        {
          filename = "__BurnerAssemblingMachine__/graphics/assembling-machine-0.png",
          priority="high",
          width = 108,
          height = 114,
          frame_count = 32,
          line_length = 8,
          shift = util.by_pixel(0, 2),
          hr_version =
          {
            filename = "__BurnerAssemblingMachine__/graphics/burner-assembling-machine.png",
            priority="high",
            width = 214,
            height = 226,
            frame_count = 32,
            line_length = 8,
            shift = util.by_pixel(0, 2),
            scale = 0.5
          }
        },
        {
          filename = "__BurnerAssemblingMachine__/graphics/assembling-machine-1-shadow.png",
          priority="high",
          width = 95,
          height = 83,
          frame_count = 1,
          line_length = 1,
          repeat_count = 32,
          draw_as_shadow = true,
          shift = util.by_pixel(8.5, 5.5),
          hr_version =
          {
            filename = "__BurnerAssemblingMachine__/graphics/hr-assembling-machine-1-shadow.png",
            priority="high",
            width = 190,
            height = 165,
            frame_count = 1,
            line_length = 1,
            repeat_count = 32,
            draw_as_shadow = true,
            shift = util.by_pixel(8.5, 5),
            scale = 0.5
          }
        }
      }
    }
BurnerAssemblingMachine.crafting_speed = 0.5
data:extend({BurnerAssemblingMachine})