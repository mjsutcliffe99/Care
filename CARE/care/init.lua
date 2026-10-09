--- @module care
--- @summary A game engine extension to Love2D.
--- @description
--- Matthew Sutcliffe, 2nd February 2026
local care = {}

care.version = "0.0.1" --unofficially so (versioning not settled yet)
care.ui    = require "care.ui"
care.gfx   = require "care.gfx"
care.input = require "care.input"
care.i18n  = require "care.i18n"
care.anim  = require "care.anim"
care.debug = require "care.debug"
care.geom  = require "care.geom"

return care