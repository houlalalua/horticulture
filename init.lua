-- Test mod horticulture par houlala qui déteste lua

horticulture = {
    path = minetest.get_modpath('horticulture'),
    const = {
        -- Taux de lumière minimum pour que les fleurs puissent pousser.
        LUMIERE_MIN = tonumber(minetest.setting_get('LUMIERE_MIN')) or 10,
        -- Si true les fleurs ne pousseront que lorsqu'il fait jour.
        -- Si false, pousseront même la nuit si toutefois le niveau de lumière
        -- est suffisant.
        JOUR_SEULEMENT = minetest.setting_getbool('JOUR_SEULEMENT') or true,
        AUBE = 0.22,
        CREPUSCULE = 0.78,
        -- Niveau du compost sur lequel les graines peuvent être plantées
        COMPOST_ARABLE = 3,
        TAUX_MIN = 180,
        TAUX_MAX = 210,
        DELAI_EMANATION = 20,
    },
    utils = {
        nom_fleur = function(noeud)
            local r = noeud:match('^flowers:(.+)$')
            if horticulture.fleurs[r] then
                return r
            end
            return
        end,
        nom_fleur_phase = function(noeud)
            local r = noeud:match('^horticulture:(.+)_phase_%d$')
            if horticulture.fleurs[r] then
                return r
            end
            return
        end,
        suivant = function(n)
            return string.format('phase_%i', n+1)
        end,
        fait_jour = function()
            local t = minetest.get_timeofday()
            if t < horticulture.const.AUBE
                or t > horticulture.const.CREPUSCULE then
                return true
            end
            return false
        end,
        creatif = function(qui)
            return (creative
                    and creative.is_enabled_for
                    and creative.is_enabled_for(qui)
                    )
        end,
        blabla = function(nom)
            -- Voir ensuite pour y intégrer intllib
            -- et éventuellement une fonction simple
            -- pour la traduction
            local r = function(t, c)
                if t == '_' then t = ' ' end
                return t .. c:upper()
            end
            nom = string.gsub(' ' .. nom, '([_ ])(%l)', r)
            return 'Horticulture' .. nom
        end,
        --meta = {},
    },
}

dofile(horticulture.path .. '/secateur.lua')
dofile(horticulture.path .. '/compost.lua')
dofile(horticulture.path .. '/liquides.lua')
dofile(horticulture.path .. '/fleurs.lua')
dofile(horticulture.path .. '/nenuphar.lua')

