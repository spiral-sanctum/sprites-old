
-- Generate uniform size minisprites

foreach_rule(
    "src/minisprites/pokemon/gen6/*.png",
    {
        display="pad g6 minisprite %f",
        pad{w=40, h=30},
        compresspng{config="MINISPRITE"}
    },
    "build/gen6-minisprites-padded/%b"
)

foreach_rule(
    "src/minisprites/items/*.png",
    {
        display="pad item minisprite %f",
        pad{w=24, h=24},
        compresspng{config="MINISPRITE"}
    },
    "build/item-minisprites-padded/%b"
)

foreach_rule(
    "src/minisprites/pokemon/gen6/*.png",
    {
        display="trim g6 minisprite %f",
        trimimg{},
        compresspng{config="MINISPRITE"}
    },
    "build/gen6-minisprites-trimmed/%b"
)

foreach_rule(
    "src/minisprites/items/*.png",
    {
        display="trim item minisprite %f",
        trimimg{},
        compresspng{config="MINISPRITE"}
    },
    "build/item-minisprites-trimmed/%b"
)

-- PS spritesheet

rule(
    "ps-pokemon.sheet.mjs",
    {
        display="ps pokemon sheet",
        "node tools/sheet %f %o",
        compresspng{config="SPRITESHEET"}
    },
    "build/ps/pokemonicons-sheet.png"
)

-- TODO: reenable when trainers are moved
-- rule{
--     display="ps trainers sheet",
--     {"ps-trainers.sheet.mjs"},
--     {
--         "node tools/sheet %f %o",
--         compresspng{config="SPRITESHEET"}
--     },
--     {"build/ps/trainers-sheet.png"}
-- }

rule(
    "ps-items.sheet.mjs",
    {
        display="ps items sheet",
        "node tools/sheet %f %o",
        compresspng{config="SPRITESHEET"}
    },
    "build/ps/itemicons-sheet.png"
)

-- PS pokeball icons

local balls = {
    "src/_uncategorized/noncanonical/ui/battle/Ball-Normal.png",
    "src/_uncategorized/noncanonical/ui/battle/Ball-Sick.png",
    "src/_uncategorized/noncanonical/ui/battle/Ball-Null.png",
}

rule(
    balls,
    {
        display="pokemonicons-pokeball-sheet",
        "magick convert -background transparent -gravity center -extent 40x30 %f +append %o",
        compresspng{config="SPRITESHEET"}
    },
    "build/ps/pokemonicons-pokeball-sheet.png"
)

-- Smogdex social images

local input = spriteglob("src/models/*", {b = false, s = false})

foreach_rule(
    input,
    {
        display="fbsprite %f",
        "magick convert \"%f[0]\" -trim -resize 150x150 -background white -gravity center -extent 198x198 -bordercolor black -border 1 %o",
        compresspng{config="MODELS"}
    },
    "build/smogon/fbsprites/xy/%B.png"
)

foreach_rule(
    input,
    {
        display="twittersprite %f",
        "magick convert \"%f[0]\" -trim -resize 115x115 -background white -gravity center -extent 120x120 %o",
        compresspng{config="MODELS"}
    },
    "build/smogon/twittersprites/xy/%B.png"
)


-- Trainers

-- TODO: reenable when trainers are moved
-- foreach_rule{
--     display="pad trainer %f",
--     {"src/canonical/trainers/*"},
--     {
--         pad{w=80, h=80},
--         compresspng{config="TRAINERS"}
--     },
--     {"build/padded-trainers/canonical/%b"}
-- }

-- Padded Dex

local dexOutput = foreach_rule(
    "src/dex/*",
    {
        display="pad dex %f",
        pad{w=120, h=120},
        compresspng{config="DEX"}
    },
    "build/padded-dex/%b"
)


-- Build missing CAP dex

local dexSet = {}
for file in iter(dexOutput) do
    dexSet[tup.base(file)] = true
end

local dexMissing = {}
for file in iter(spriteglob(
                     {"src/sprites/gen5/*.gif", "src/models/*.gif"},
                     {b = false, s = false})) do
    local base = tup.base(file)
    if dexSet[base] then
        goto continue
    end
    dexMissing += file
    dexSet[base] = true
    ::continue::
end

foreach_rule(
    dexMissing,
    {
        display="missing dex %B",
        "magick convert \"%f[0]\" -trim %o",
        "magick mogrify -background transparent -gravity center -resize \"120x120>\" -extent 120x120 %o",
        compresspng{config="DEX"}
    },
    "build/padded-dex/%B.png"
)
