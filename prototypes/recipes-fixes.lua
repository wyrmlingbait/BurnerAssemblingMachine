local wyrm_categories = {
		["crafting"] = "wyrm-burner-crafting"
}
	
  local enabled = true
  local crafter = false
  local category
  local assembling_categories = {}
  local recipe_list = {} -- recipes for the burner assembly machine
  local ingredients = {} -- ingredients with a list of recipes
  local resources = {} -- resources on map for checking ingredients
  local name
  local prereq
  local effects
  

  local ban_ingredients = {}
  local ban_recipes = {}
  
  
  -- remove recipes that we can't craft  the ingredients
  
  if mods["bobelectronics"] then
    ban_ingredients["electronic-circuit"] = true
  end
  if mods["angelsbioprocessing"] then
    ban_ingredients["paste-cellulose"] = true
	ban_recipes["seed-extractor"] = true
  end
  if mods["bobplates"] then
    ban_ingredients["glass"] = true
	ban_ingredients["steel-gear-wheel"] = true
	ban_ingredients["steel-plate"] = true
  end
  if mods["angelsrefining"] then
   ban_recipes["clarifier"] = true
  end   
  
  -- we need to be able to craft an extra recipe from pyhightech in order to be no handcrafting
  
  if mods["pyhightech"] then
    table.insert(data.raw["assembling-machine"]["burner-assembling-machine"].crafting_categories, "handcrafting")
  end
  
  function check_ingredients(ban_i, name)
  local recipe = data.raw["recipe"][name]
  local ingredients
  if recipe.ingredients then
    ingredients = recipe.ingredients
  elseif recipe.normal.ingredients then
    ingredients = recipe.normal.ingredients
  end
  if ingredients ~= nil then
    for i,j in pairs(ingredients) do
	  if ban_i[j.name] then
	    return false
	  end
	end
  end
  return true
  end
  
  function check_recipes(ban_r,name)
  if ban_r[name] == true then
    return false
  else
    return true
  end
  end
  
  -- prepare resources list
  for v,k in pairs(data.raw["resource"]) do
    resources[k.name] = true
  end
  
  -- get crafting categories for assembling machines
  for _,p in pairs(data.raw["assembling-machine"]) do
    crafter = false
    for _,k in pairs(p.crafting_categories) do
	  if k == "crafting" then
	    crafter=true
	  end
	end
	if crafter then
      for _,k in pairs(p.crafting_categories) do
	    if not assembling_categories[k] then
	      assembling_categories[k]=true
	    end
	  end
	end
  end
  
  -- get list of recipes available from the start
  for p,k in pairs(data.raw["recipe"]) do
	 enabled = true
     for a,b in pairs(k) do
	   if a == "enabled" then
	     if data.raw["recipe"][p].enabled == "true" then
		   enabled = true
		 elseif data.raw["recipe"][p].enabled == "false" then
		   enabled = false
		 else
		   enabled = data.raw["recipe"][p].enabled
		 end
	   end
	 end
	 if enabled then
	   name = k.name
	   if check_ingredients(ban_ingredients,name) then
	     if check_recipes(ban_recipes,name) then
	       recipe_list[name] = true
		 end
	   end
	 end
  end
  

  
  
  -- get list of recipes from first tier of techs and remove any recipes mistakenly picked up before
  for p,k in pairs(data.raw["technology"]) do
     for a,b in pairs(k) do
	   if a == "enabled" then
	     if data.raw["technology"][p].enabled == "true" then
		   enabled = true
		 elseif data.raw["technology"][p].enabled == "false" then
		   enabled = false
		 else
		   enabled = data.raw["technology"][p].enabled
		 end
	   end
	 end
	 prereq = false
	 effects = false
     for a,b in pairs(k) do
	   if a == "prerequisites" then
	     if #b ~= 0 then
	       prereq = true
		 end
	   elseif a == "effects" then
	     effects = true
	   end
	     if prereq  and k.enabled ~= false then
		  if effects then
		   for _,j in pairs(data.raw["technology"][p].effects) do
		     if j.type =="unlock-recipe" then
			   recipe_list[j.recipe] = false
			 end
		   end
		  end
		 elseif prereq == false  and k.enabled ~= false then
		  if effects then
		   for _,j in pairs(data.raw["technology"][p].effects) do
		     if j.type =="unlock-recipe" then
			   if check_ingredients(ban_ingredients,j.recipe) then
			     if check_recipes(ban_recipes,j.recipe) then
			       recipe_list[j.recipe] = true
				 end
			   end
			 end
		   end
		  end		 
		 end
	 end	 
  end	 
  
  
--log(serpent.block(data.raw, {comment=false, sparse=true}))

-- create categories based on previous names and add recipes to them

  for p,k in pairs(recipe_list) do
    if k then
     category = data.raw["recipe"][p].category
	 if category == nil then
	   data.raw["recipe"][p].category = "wyrm-burner-crafting"
	 elseif assembling_categories[category] then
       if not wyrm_categories[category] then
	     wyrm_categories[category] = "wyrm-burner-" .. data.raw["recipe"][p].category
	     data:extend({
	       {
		      type = "recipe-category",
		      name = wyrm_categories[data.raw["recipe"][p].category],
	       },
         })
	     table.insert(data.raw["assembling-machine"]["burner-assembling-machine"].crafting_categories, wyrm_categories[data.raw["recipe"][p].category])
       end
	   data.raw["recipe"][p].category = wyrm_categories[data.raw["recipe"][p].category]
     end
	end
  end  

-- add new categories to assembling machines

for _,p in pairs(data.raw["assembling-machine"]) do
  for _,k in pairs(p.crafting_categories) do
     if wyrm_categories[k] then
	   table.insert(p.crafting_categories, wyrm_categories[k])
	 end
  end
end

-- add new categories to all types of players

for v,k in pairs(data.raw["player"]) do
   for n,p in pairs(wyrm_categories) do
     for _,j in pairs(k.crafting_categories) do
	   if j == n then
         table.insert(k.crafting_categories,p)
	   end
	 end
   end
end

