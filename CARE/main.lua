local care = require "care"
local flux = require "care.third_party.flux"
local moonshine = require "care.third_party.moonshine"
local t = care.i18n.t

local test_atlas = care.gfx.atlas:new("assets/ui/ui.png","assets/ui/ui.json",4) --TEMP
local test_menu --TEMP
local screen_effect --TEMP
local imgBackground --TEMP
local ph = 0 --TEMP
local effects_on = true --TEMP

function love.load()
    care.gfx.viewport.setup(1280,720,1280,720)
    love.mouse.setVisible(false)
    care.input.mouse.set_cursor(test_atlas,"cursor_white",8,2)

    --TEMP:
    care.i18n.load_locale("en","assets/locales/en.json")
    care.i18n.set_locale("en")

    --TEMP:
    care.input.keybinds.bind("fullscreen","f11")
    care.input.keybinds.bind("toggle_crt","f1")

    --TEMP:
    local font = love.graphics.newFont("assets/fonts/pixelsix00.ttf",32)
    love.graphics.setFont(font)

    --TEMP:
    test_menu = care.ui.menu:new(40,40,test_atlas,{
        care.ui.button:new(0,0,400,80,t("ui.main_menu.start_game"),nil),
        care.ui.button:new(0,110,400,80,t("ui.main_menu.save_game",{name="Matthew"}),{on_click = function() love.window.setTitle("HI") end}),
        care.ui.button:new(0,220,400,80,t("ui.main_menu.exit_game"),nil),
        care.ui.button:new(0,330,400,80,t("ui.main_menu.exit_game"),nil)
    })
    --test_menu.templates.button.quad_idle = test_menu.atlas:get_quad("btn_idle") --TEMP
    test_menu:set_default_quads("button",{ quad_idle = "btn_idle"}) --TEMP
    test_menu.widgets[2]:set_graphics({ idle = "btn_idle", pressed = "btn_pressed", disabled = "btn_disabled" }) --TEMP

    --TEMP:
    for _,w in ipairs(test_menu.widgets) do
        w.on_hover_enter = function() flux.to(w, 1.0, { scale = 1.25 }):ease("elasticout") end
        w.on_hover_exit  = function() flux.to(w, 1.0, { scale = 1.0 }):ease("elasticout") end
    end

    --TEMP:
    imgBackground = love.graphics.newImage("assets/backgrounds/summer.png") --TEMP
    screen_effect = moonshine(moonshine.effects.scanlines).chain(moonshine.effects.crt).chain(moonshine.effects.chromasep)
    screen_effect.parameters = {
        chromasep = {angle = 0.5, radius = 6},
        scanlines = {thickness = 0.2, width = 4, opacity = 0.25}
    }

    --TEMP:
    local nslice = care.gfx.nineslice:new(test_atlas,{
        tl = "btn_tl",
        t  = "btn_t",
        tr = "btn_tr",
        l  = "btn_l",
        c  = "btn_c",
        r  = "btn_r",
        bl = "btn_bl",
        b  = "btn_b",
        br = "btn_br"
    })
    --local c_nslice = nslice:render(200,50)
    --test_menu:set_default_quads("button",{ quad_idle = "nil"})

    --TEMP:
    local anim_atlas = care.gfx.atlas:new("assets/anims/heartburst.png","assets/anims/heartburst.json",4)
    care.anim.system.import("anim_heartburst",anim_atlas,{
        "frame01",
        "frame02",
        "frame03",
        "frame04",
        "frame05",
        "frame06",
        "frame07",
        "frame08",
        "frame09",
        "frame10",
        "frame11",
        "frame12",
        "frame13",
        "frame14",
        "frame15",
        "frame16",
        "frame17",
        "frame18",
        "frame19",
        "frame20",
        "frame21",
        "frame22",
        "frame23"
    },
    1/15)--,
    --function() love.window.setTitle(love.window.getTitle().."1") end)
    --animinst_blast = care.anim.instance:new(anim_blast)
    --animinst_blast.on_complete = function() love.window.setTitle(love.window.getTitle().."2") end --TEMP
    --anim_blast.on_complete = function() love.window.setTitle(love.window.getTitle().."1") end --TEMP
end

function love.resize()
    care.gfx.viewport.resize()
end

function love.mousemoved(x,y,dx,dy)
    care.input.mouse.moved(x,y,dx,dy)
end

function love.mousepressed(x,y,b)
    test_menu:mousepressed(x,y,b)
    care.anim.system.spawn("anim_heartburst")--,nil,function() love.window.setTitle(love.window.getTitle().."2") end)
end

function love.mousereleased(x,y,b)
    test_menu:mousereleased(x,y,b)
end

function love.keypressed(key, scancode, isrepeat)
    --TEMP (input.keybinds should manage keybind functions):
    if (key==care.input.keybinds.actions.fullscreen) then love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
    elseif (key==care.input.keybinds.actions.toggle_crt) then effects_on = not effects_on
    elseif (key=="c" and love.keyboard.isDown("f3")) then care.debug.on = not care.debug.on --TEMP (make it rebindable)
    end
end

function love.update(dt)
    flux.update(dt)
    test_menu:update(dt)
    care.anim.system.update(dt)
    --TEMP:
    ph = ph + dt*30
    screen_effect.scanlines.phase = ph
end

function ddraw() --TEMP
    love.graphics.clear(0,0,0.2,1)
    love.graphics.draw(imgBackground,0,0,0,2.9,2.9) --TEMP
    test_menu:draw()
    care.anim.system.draw()
    care.input.mouse.draw()
end

function love.draw()
    love.graphics.setCanvas(care.gfx.viewport.canvas)

    --TEMP:
    if (effects_on) then
        screen_effect(function()
            ddraw()
        end)
    else
        ddraw()
    end

    love.graphics.setCanvas()
    care.gfx.viewport.draw()
    care.debug.draw()
end