--- @module care.temp.audio
--- @summary [TEMPORARY - JUST FOR TESTING THE API DOCS!]
--- @description Blah blah blah.
---
--- And even more blah blah blah

--- @function care.temp.audio.setVolume
--- @summary Sets the master audio volume.
--- @param volume number Master volume from 0 to 1. [care.temp.notaudio]
--- @return nil Nothing.
--- @example
--- care.temp.audio.setVolume(0.5)
function audio.setVolume(volume)
end

--- @function care.temp.audio.getVolume
--- @summary Returns the master audio volume.
--- @return volume number Current master volume between 0 and 1.
--- @example
--- local volume = care.temp.audio.getVolume()
function audio.getVolume()
end

--- @function care.temp.audio.newSource
--- @summary Creates an audio source. (This is temporary and just here to test the API docs.)
--- @param path string Path to an audio file.
--- @return source care.temp.audio.Source new audio source.
--- @example
--- local music = care.temp.audio.newSource('music.mp3')
function audio.newSource(path)
end

--- @class care.temp.audio.Supersource
--- @summary A playable audio Supersource.
--- @description (This is temporary and just here to test the API docs.)

--- @method care.temp.audio.Supersource:play
--- @summary Starts playback.
--- @return nil Nothing.
--- @example
--- music:play()
function Supersource:play()
end

--- @method care.temp.audio.Supersource:delete
--- @summary Deleted supersource.
--- @return nil Nothing.
--- @example
--- music:delete()
function Supersource:delete()
end

--- @class care.temp.audio.Source:care.temp.audio.Supersource
--- @summary A playable audio source.
--- @description (This is temporary and just here to test the API docs.)

--- @method care.temp.audio.Source:play
--- @summary Starts playback.
--- @return nil Nothing.
--- @example
--- music:play()
function Source:play()
end

--- @method care.temp.audio.Source:stop
--- @summary Stops playback.
--- @return nil Nothing.
--- @example
--- music:stop()
function Source:stop()
end

--- @method care.temp.audio.Source:setVolume
--- @summary Sets the volume of the source.
--- @param volume number Source volume from 0 to 1.
--- @return nil Nothing.
--- @example
--- music:setVolume(0.25)
function Source:setVolume(volume)
end

--- @class care.temp.audio.SoundData
--- @summary Audio sample data. (This is temporary and just here to test the API docs.)
--- @field sampleRate number Samples per second.
--- @field channels number Number of audio channels.
