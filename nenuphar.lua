
local poser = function(items, qui, quoi)
    local coord = quoi.under
    local noeud = minetest.get_node(coord)

    local coord_dessus = quoi.above
    local noeud_dessus = minetest.get_node(coord_dessus)

    if noeud_dessus.name ~= 'air'
       or noeud.name ~= 'horticulture:eau_fertile' then
        return
    end

    minetest.set_node(coord_dessus, {
        name = items:get_name(),
        param2 = math.random(0, 3), -- orientation
        }
    )
    if not horticulture.utils.creatif(qui) then
        items:take_item()
    end
    return items
end

local croitre = function(coord, temps)
    if horticulture.const.JOUR_SEULEMENT and horticulture.utils.fait_jour() then
        return true
    end

    local noeud = minetest.get_node(coord)
    local nom = noeud.name
    local params = minetest.registered_nodes[nom]

    local coord_support = table.copy(coord)
    coord_support.y = coord_support.y - 1
    local support = minetest.get_node(coord_support)

    if support.name ~= 'horticulture:eau_fertile' then
        minetest.dig_node(coord)
        minetest.add_item(coord, 'horticulture:waterlily_phase_1')
        return false
    end

    if minetest.get_node_light(coord) < horticulture.const.LUMIERE_MIN then
        return true
    end

    local suivant
    if params.phase == 1 or params.phase == 2 then
        suivant = nom:gsub('phase_(%d)', horticulture.utils.suivant)
    else
        minetest.set_node(coord, {
            name='flowers:waterlily',
            param2=noeud.param2
            }
        )
        return false
    end
    minetest.swap_node(coord, {name=suivant, param2=noeud.param2,})
    return true
end

for i=1, 3 do
    local placement
    local desc = 'Waterlily Embryon'
    local groupes = {dig_immediate = 3,}
    if i == 1 then
        placement = poser
    else
        desc = desc .. ' Phase_' .. i
        groupes.not_in_creative_inventory = 1
    end
    local noeud = string.format('horticulture:waterlily_phase_%i', i)
    minetest.register_node(noeud, {
        description = horticulture.utils.blabla(desc),
        tiles = {
            string.format('horticulture_nenuphar_dessus_phase_%i.png', i),
            string.format('horticulture_nenuphar_dessous_phase_%i.png', i),
        },
        inventory_image = 'horticulture_nenuphar_dessus_phase_2.png',
        wield_image = 'horticulture_nenuphar_dessus_phase_2.png',
        groups = groupes,
        drawtype = 'nodebox',
        paramtype = 'light',
        paramtype2 = 'facedir',
        walkable = false,
        sunlight_propagates = true,
        liquids_pointable = true,
        node_placement_prediction = '', -- Permet de déposer le nénuphar sur un liquide
        buildable_to = false,
        floodable = true,
        phase = i,
        node_box = {
            type = 'fixed',
            fixed = {-0.5, -31 / 64, -0.5, 0.5, -15 / 32, 0.5}
        },
        selection_box = {
            type = 'fixed',
            fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, -15 / 32, 7 / 16}
        },
        sounds = default.node_sound_leaves_defaults(),
        drop = 'horticulture:waterlily_phase_1',
        on_place = placement,
        on_construct = function(coord)
            local n = math.random(
                horticulture.const.TAUX_MIN,
                horticulture.const.TAUX_MAX
            )
            minetest.get_node_timer(coord):start(n)
        end,
        on_timer = croitre,
    })
end

local function decouper(qui, quoi)
    local coord = quoi.under
    local noeud = minetest.get_node(coord)
    if noeud.name == 'flowers:waterlily' then
        local n = math.random(2, 3)
        local items = ItemStack('horticulture:waterlily_phase_1 ' .. n)
        minetest.set_node(coord, {name='air'})
        minetest.item_drop(items, qui, coord)
        return true
    end
    return false
end

local sec = horticulture.utils.Secateur:init()
sec:ajouter_action(decouper)
