local wyrm_categories = {
		["crafting"] = "wyrm-burner-crafting"
}
  local enabled = true
  local crafter = false
  local category
  local assembling_categories = {}
  local recipe_list = {}
  local name
  local prereq
  local effects
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
	   recipe_list[name] = true
	 end
  end
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
			   recipe_list[j.recipe] = true
			 end
		   end
		  end		 
		 end
	 end	 
  end	 
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

for _,p in pairs(data.raw["assembling-machine"]) do
  for _,k in pairs(p.crafting_categories) do
     if wyrm_categories[k] then
	   table.insert(p.crafting_categories, wyrm_categories[k])
	 end
  end
end

for v,k in pairs(data.raw["player"]) do
   for n,p in pairs(wyrm_categories) do
     for _,j in pairs(k.crafting_categories) do
	   if j == n then
         table.insert(k.crafting_categories,p)
	   end
	 end
   end
end