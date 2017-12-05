
local Secateur = {}
local __sec_def = {__index = Secateur, __inst = nil}

function Secateur:init()
    if not __sec_def.__inst then
        local self = {}
        setmetatable(self, __sec_def)
        self.__actions = {}
        self.__attrs = {usure=65535/256}
        __sec_def.__inst = self
    end
    return __sec_def.__inst
end

function Secateur:ajouter_action(action)
    if type(action) ~= 'function' then
        error('Argument de ajouter_action doit être une référence de fonction')
    end
    self.__actions[action] = true
end

function Secateur:supprimer_action(action)
    self.__actions[action] = nil
end

function Secateur:executer(outil, qui, quoi)
    for c, _ in pairs(self.__actions) do
        if c(qui, quoi) then
            if not horticulture.utils.creatif(qui) then
                outil:add_wear(self.__attrs.usure)
            end
            minetest.sound_play('horticulture_collecter_2', {
                pos = qui:getpos(),
            })
            if outil:get_wear() <= 0 then
                 minetest.sound_play('horticulture_cassage_outil', {
                    pos = qui:getpos(),
                    gain = 3,
            })
            end
            break
        end
    end
    return outil
end

horticulture.utils.Secateur = Secateur
local sec = Secateur:init()

minetest.register_tool('horticulture:secateur', {
    description = horticulture.utils.blabla('Secateur'),
    inventory_image = 'horticulture_secateur.png',
    visual_scale = .5,
    wield_scale = {x=-.5, y=.5, z=.5},
    stack_max = 1,
    -- Les sons ne fonctionnent pas sans tool_capabilities a-prori
    --sound = {
        --place = {name = 'horticulture_collecter'},
        --breaks = {name = 'horticulture_cassage_outil'},
     --},
    on_place = function(o, k, q) return sec:executer(o, k, q) end,
})

minetest.register_craft({
    output = 'horticulture:secateur',
    recipe = {
        {'', 'default:steel_ingot', ''},
        {'group:stick', 'group:stick', 'default:steel_ingot'},
        {'', 'group:stick', ''},
    }
})
