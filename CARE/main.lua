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
    local font = love.graphics.newFont("assets/fonts/pixelsix00.ttf",36)
    love.graphics.setFont(font)

    --TEMP:
    test_menu = care.ui.menu:new(40,40,test_atlas,{
        care.ui.button:new(0,0,400,80,t("ui.main_menu.start_game"),nil),
        care.ui.button:new(0,110,400,80,t("ui.main_menu.save_game",{name="Matthew"}),{on_click = function() love.window.setTitle("Hello there") end}),
        care.ui.button:new(0,220,400,80,t("ui.main_menu.crt"),{on_click = function() effects_on = not effects_on end}),
        care.ui.button:new(0,330,400,80,t("ui.main_menu.exit_game"),{on_click = function() love.event.quit() end})
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
        chromasep = {angle = 0.5, radius = 4},
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

    care.anim.system.import("assets/anims/heart.png","assets/anims/heart.json",1/15,3)

    --TEMP:
    --logo_love = love.graphics.newImage("assets/logos/love.png") --TEMP
    --logo_care = love.graphics.newImage("assets/logos/care.png") --TEMP
end

function love.resize()
    care.gfx.viewport.resize()
end

function love.mousemoved(x,y,dx,dy)
    care.input.mouse.moved(x,y,dx,dy)
end

function love.mousepressed(x,y,b)
    test_menu:mousepressed(x,y,b)
    care.anim.system.spawn("heartburst",x,y)
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
    love.graphics.draw(imgBackground,0,0,0,1,1) --TEMP
    test_menu:draw()
    care.anim.system.draw()
    care.input.mouse.draw()

    --love.graphics.draw(logo_love,450,200,0,3,3) --TEMP
    --love.graphics.draw(logo_care,700,200,0,3,3) --TEMP
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