
horticulture.fleurs = {
    dandelion_white=true,
    dandelion_yellow=true,
    geranium=true,
    rose=true,
    tulip=true,
    viola=true,
}

local function decouper(qui, quoi)
    local coord = quoi.under
    local noeud = minetest.get_node(coord)
    local nf = horticulture.utils.nom_fleur(noeud.name)
    if nf then
        local n = string.format(
            'horticulture:%s_graine %i',
            nf, math.random(2, 5)
        )
        local graines = ItemStack(n)
        minetest.set_node(coord, {name='air'})
        minetest.item_drop(graines, qui, coord)
        return true
    end
    return false
end

local sec = horticulture.utils.Secateur:init()
sec:ajouter_action(decouper)

local croissance_fleur = function(coord, temps)
    if horticulture.const.JOUR_SEULEMENT and horticulture.utils.fait_jour() then
        return true
    end
    local noeud = minetest.get_node(coord)
    local nom = noeud.name
    local params = minetest.registered_nodes[nom]

    local coord_support = table.copy(coord)
    coord_support.y = coord_support.y - 1
    local support = minetest.get_node(coord_support)
    local phase = minetest.registered_nodes[support.name].phase

    -- Au cas où le support a été changé via un autre biais
    if phase ~= horticulture.const.COMPOST_ARABLE then
        minetest.dig_node(coord) -- Pas de drop avec cette fonction, donc :
        minetest.add_item(coord, nom:gsub('phase_%i', 'graine'))
        return false
    end

    if minetest.get_node_light(coord) < horticulture.const.LUMIERE_MIN then
        return true
    end

    local suivant
    if params.phase == 1 or params.phase == 2 then
        suivant = nom:gsub('phase_(%d)', horticulture.utils.suivant)
    elseif params.phase == 0 then
        suivant = nom:gsub('graine', 'phase_1')
    else
        minetest.set_node(coord, {
            name='flowers:' .. horticulture.utils.nom_fleur_phase(nom)
            }
        )
        return false
    end
    minetest.swap_node(coord, {name = suivant})
    return true
end

local minuteur = function(coord)
    local n = math.random(
        horticulture.const.TAUX_MIN,
        horticulture.const.TAUX_MAX
    )
    minetest.get_node_timer(coord):start(n)
end

local function inscrire_graine(fleur)
    local img = 'horticulture_' .. fleur .. '_semence.png'

    minetest.register_node('horticulture:' .. fleur .. '_graine', {
        description = horticulture.utils.blabla(fleur .. ' Seed'),
        tiles = {img},
        inventory_image = img,
        wield_image = img,
        groups = {attached_node = 1, dig_immediate = 3},
        drawtype = 'signlike',
        paramtype = 'light',
        paramtype2 = 'wallmounted',
        walkable = false,
        sunlight_propagates = true,
        phase = 0,
        selection_box = {
            type = 'fixed',
            fixed = {-.5, -.5, -.5, .5, -.5/16, .5},
        },
        sounds = default.node_sound_leaves_defaults(),
        on_place = function(graines, qui, quoi)
            local coord = quoi.under
            local noeud = minetest.get_node(coord)

            local coord_dessus = quoi.above
            local noeud_dessus = minetest.get_node(coord_dessus)

            if noeud_dessus.name ~= 'air' or
               noeud.name ~= 'horticulture:compost_phase_3' then
                return
            end
            minetest.set_node(coord_dessus, {
                name = 'horticulture:' .. fleur .. '_graine',
                param2 = 1,
                }
            )
            if not horticulture.utils.creatif(qui) then
                graines:take_item()
            end
            return graines
        end,
        on_construct = minuteur,
        on_timer = croissance_fleur,
})
end


local inscrire_fleur = function(fleur)
    inscrire_graine(fleur)
    for i=1, 3 do
        local noeud = string.format('horticulture:%s_phase_%i', fleur, i)
        minetest.register_node(noeud, {
            tiles = {string.format('horticulture_%s_phase_%i.png', fleur, i)},
            groups = {
                attached_node = 1,
                dig_immediate = 3,
                not_in_creative_inventory = 1, -- Pas réellement nécessaire (desc absente)
            },
            drawtype = 'plantlike',
            paramtype = 'light',
            walkable = false,
            sunlight_propagates = true,
            phase = i,
            selection_box = {
                type = 'fixed',
                fixed = {-.5, -.5, -.5, .5, -.3, .5},
            },
            sounds = default.node_sound_leaves_defaults(),
            drop = string.format('horticulture:%s_graine', fleur),
            on_timer = croissance_fleur,
        })
    end
end

for id, v in pairs(horticulture.fleurs) do
    if v then inscrire_fleur(id) end
end
