-- Clones de la flotte, pas d'autre choix que de cloner également les
-- écoulements et les seaux de flottes :/
local cpst = horticulture.utils.Compost:init()

local arreter_diffusion = function(coord)
    cpst:desactiver(cpst:sercoord({x=coord.x, y=coord.y-1, z=coord.z}))
end

local pe = table.copy(minetest.registered_nodes['default:water_source'])
pe.liquid_alternative_source = 'horticulture:water_source'
pe.liquid_alternative_flowing = 'horticulture:water_flowing'
pe.groups.not_in_creative_inventory = 1
pe.on_destruct = arreter_diffusion
minetest.register_node('horticulture:water_source', pe)

local pee = table.copy(minetest.registered_nodes['default:water_flowing'])
pee.liquid_alternative_source = 'horticulture:water_source'
pee.liquid_alternative_flowing = 'horticulture:water_flowing'
minetest.register_node('horticulture:water_flowing', pee)

local per = table.copy(minetest.registered_nodes['default:river_water_source'])
per.liquid_alternative_source = 'horticulture:river_water_source'
per.liquid_alternative_flowing = 'horticulture:river_water_flowing'
per.groups.not_in_creative_inventory = 1
per.on_destruct  = arreter_diffusion
minetest.register_node('horticulture:river_water_source', per)

local pere = table.copy(minetest.registered_nodes['default:river_water_flowing'])
pere.liquid_alternative_source = 'horticulture:river_water_source'
pere.liquid_alternative_flowing = 'horticulture:river_water_flowing'
minetest.register_node('horticulture:river_water_flowing', pere)

bucket.register_liquid(
    'horticulture:water_source',
    'horticulture:water_flowing',
    'horticulture:bucket_water',
    'bucket_water.png',
    'Water Bucket',
    {not_in_creative_inventory = 1}
)

bucket.register_liquid(
    'horticulture:river_water_source',
    'horticulture:river_water_flowing',
    'horticulture:bucket_river_water',
    'bucket_river_water.png',
    'River Water Bucket',
    {not_in_creative_inventory = 1},
    true
)

minetest.register_node('horticulture:eau_fertile', {
    description = horticulture.utils.blabla('Fertile Water'),
    drawtype = 'liquid',
    tiles = {
        {
            name = 'horticulture_eau_fertile_animation.png',
            animation = {
                type = 'vertical_frames',
                aspect_w = 16,
                aspect_h = 16,
                length = 4.2,
            },
        },
    },
    special_tiles = {
        {
            name = 'horticulture_eau_fertile_animation.png',
            backface_culling = false,
            animation = {
                type = 'vertical_frames',
                aspect_w = 16,
                aspect_h = 16,
                length = 4.2,
            },
        },
    },
    alpha = 210,
    paramtype = 'light',
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = '',
    drowning = 1,
    liquidtype = 'source',
    liquid_alternative_flowing = 'horticulture:eau_fertile_ecoulement',
    liquid_alternative_source = 'horticulture:eau_fertile',
    liquid_viscosity = 3,
    post_effect_color = {r=0, g=108, b=0, a=120},
    light_source = 3,
    groups = {liquid=1, puts_out_fire=1, cools_lava=1},
    sounds = default.node_sound_water_defaults(),
})


minetest.register_node('horticulture:eau_fertile_ecoulement', {
    description = horticulture.utils.blabla('Fertile Water Flowing'),
    drawtype = 'flowingliquid',
    tiles = {'horticulture_eau_fertile.png'},
    special_tiles = {
        {
            name = 'horticulture_eau_fertile_ecoulement.png',
            backface_culling = false,
            animation = {
                type = 'vertical_frames',
                aspect_w = 16,
                aspect_h = 16,
                length = 2.7,
            },
        },
        {
            name = 'horticulture_eau_fertile_ecoulement.png',
            backface_culling = true,
            animation = {
                type = 'vertical_frames',
                aspect_w = 16,
                aspect_h = 16,
                length = 2.7,
            },
        },
    },
    alpha = 210,
    paramtype = 'light',
    paramtype2 = 'flowingliquid',
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = '',
    drowning = 1,
    liquidtype = 'flowing',
    liquid_alternative_flowing = 'horticulture:eau_fertile_ecoulement',
    liquid_alternative_source = 'horticulture:eau_fertile',
    liquid_viscosity = 3,
    liquid_renewable = false,
    post_effect_color = {r=0, g=108, b=0, a=120},
    light_source = 3,
    groups = {
        not_in_creative_inventory = 1,
        liquid = 3,
        puts_out_fire = 1,
        cools_lava = 1
    },
    sounds = default.node_sound_water_defaults(),
})

bucket.register_liquid(
    'horticulture:eau_fertile', -- source
    'horticulture:eau_fertile_ecoulement', -- écoulement
    'horticulture:bucket_eau_fertile', -- nom
    'horticulture_seau_eau_fertile.png', -- img
    horticulture.utils.blabla('Fertile Water Bucket') -- desc
)
