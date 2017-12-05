
local evolution_compost = function(coord)
    local noeud = minetest.get_node(coord)
    local nom = noeud.name
    local params = minetest.registered_nodes[nom]
    local t = {
        {0, 1, 0},
        {1, 0, 0},
        {-1, 0, 0},
        {0, 0, 1},
        {0, 0, -1},
        {0, -1, 0},
    }
    for _, n in ipairs(t) do
        local x, y, z = unpack(n)
        local c = {x=coord.x + x, y=coord.y + y, z=coord.z + z}
        if minetest.get_node_light(c) ~= 0 then
            return true
        end
    end
    local suivant = nom:gsub('phase_(%d)', horticulture.utils.suivant)
    minetest.set_node(coord, {name=suivant})
    return true
end

local minuteur = function(coord)
    minetest.get_node_timer(coord):start(math.random(120, 180))
end

minetest.register_node('horticulture:compost_phase_1', {
    description = horticulture.utils.blabla('Infertile Compost'), -- Stérile
    tiles = {'horticulture_compost_phase_1.png'},
    phase = 1,
    drop = 'horticulture:compost_phase_1',
    groups = {crumbly = 3, soil = 1,},
    sounds = default.node_sound_dirt_defaults(),
    on_construct = minuteur,
    on_timer = evolution_compost,
})

minetest.register_node('horticulture:compost_phase_2', {
    description = horticulture.utils.blabla('Decomposing Compost'), -- En décomposition
    tiles = {'horticulture_compost_phase_2.png'},
    phase = 2,
    drop = 'horticulture:compost_phase_1',
    groups = {crumbly = 3, soil = 1, not_in_creative_inventory = 1},
    sounds = default.node_sound_dirt_defaults(),
    on_construct = minuteur,
    on_timer = evolution_compost,
})

minetest.register_node('horticulture:compost_phase_3', {
    description = horticulture.utils.blabla('Arable Compost'),
    tiles = {'horticulture_compost_phase_3.png'},
    phase = 3,
    groups = {crumbly = 3, soil = 1,},
    sounds = default.node_sound_dirt_defaults(),
})

local Compost = {}
local __compost_def = {__index = Compost, __inst = nil}

function Compost:init()
    if not __compost_def.__inst then
        local self = {}
        setmetatable(self, __compost_def)
        self.__actifs = {}
        __compost_def.__inst = self
    end
    return __compost_def.__inst
end

function Compost:sercoord(coord)
    return string.format('%i,%i,%i', coord.x, coord.y, coord.z)
end

function Compost:emaner(coord)
    return minetest.add_particlespawner({
        amount = .6,
        time = 0,
        -- Positions
        minpos = {x=coord.x, y=coord.y, z=coord.z},
        maxpos = {x=coord.x, y=coord.y+1.2, z=coord.z},
        -- Vélocités
        minvel = {x=0, y=.8, z=0},
        maxvel = {x=0, y=1.2, z=0},
        -- Accélérations
        minacc = {x=-.5, y=.5, z=-.5},
        maxacc = {x=.5, y=.5, z=.5},
        -- Expirations (temps d'existence)
        minexptime = .8,
        maxexptime = 1.1,
        -- Dimensions
        minsize = .8,
        maxsize = 1,
        -- Collision avec blocs solides
        colissiondetection = false,
        vertical = true,
        --texture = 'horticulture_compost_emanation.png',
        texture = 'horticulture_compost_bulle_emanation.png',
    })
end

function Compost:desactiver(sc)
    if self.__actifs[sc] then
        minetest.delete_particlespawner(self.__actifs[sc][3])
    end
    self.__actifs[sc] = nil
end

function Compost:est_actif(sc)
    return self.__actifs[sc] ~= nil
end

function Compost:activer(sc, coord)
    self.__actifs[sc] = {0, 20,  self:emaner(coord)}
end

function Compost:incrementer(sc)
    self.__actifs[sc][1] = self.__actifs[sc][1] + 1
end

function Compost:est_max(sc)
    return self.__actifs[sc][1] >= self.__actifs[sc][2]
end

horticulture.utils.Compost = Compost
local cpst = Compost:init()


local sources = {
    'default:water_source',
    'default:river_water_source',
    'horticulture:water_source',
    'horticulture:river_water_source',
}

minetest.register_abm({
    label = 'Horticulture Compost',
    nodenames = {'horticulture:compost_phase_3'},
    interval = horticulture.const.DELAI_EMANATION,
    neighbors = sources,
    chance = 3,
    action = function(coord, compost)
        local sc = cpst:sercoord(coord)
        local eau = minetest.get_node({x=coord.x, y=coord.y+1, z=coord.z})

        local d = false
        for _, t in ipairs(sources) do
            if eau.name == t then
                d = true
                break
            end
        end

        if not d then
            cpst:desactiver(sc)
            return
        end

        local air = minetest.get_node({x=coord.x, y=coord.y+2, z=coord.z})
        if air.name ~= 'air' then
            cpst:desactiver(sc)
            return
        end

        -- Initialisation, la diffusion n'a pas encore commencée
        if not cpst:est_actif(sc) then
            minetest.set_node(
                {x=coord.x, y=coord.y+1, z=coord.z},
                {name='horticulture:' .. eau.name:match(':(.+)')}
            )
            cpst:activer(sc, coord)
        end
        cpst:incrementer(sc)

        if cpst:est_max(sc) then
            cpst:desactiver(sc)
            minetest.set_node(
                {x=coord.x, y=coord.y+1, z=coord.z},
                {name='horticulture:eau_fertile',}
            )
            minetest.set_node(coord, {name='default:dirt',})
        end
    end,
})


local l = 'group:leaves'
local d = 'default:dirt'
minetest.register_craft({
    output = 'horticulture:compost_phase_1 8',
    recipe = {
        {d, l, d},
        {l, 'group:water_bucket', l},
        {d, l, d}
    },
    replacements = {
        {'group:water_bucket', 'bucket:bucket_empty'}
    },
})
