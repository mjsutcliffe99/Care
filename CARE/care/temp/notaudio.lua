--- @module care.temp.notaudio
--- @summary [TEMPORARY - JUST FOR TESTING THE API DOCS!]
--- @description Blah blah blah.

--- @function care.temp.notaudio.setVolume
--- @summary Sets the master notaudio volume.
--- @param volume number Master volume from 0 to 1.
--- @return nil Nothing.
--- @example
--- care.temp.notaudio.setVolume(0.5)
function notaudio.setVolume(volume)
end

--- @function care.temp.notaudio.getVolume
--- @summary Returns the master notaudio volume.
--- @return volume number Current master volume between 0 and 1.
--- @example
--- local volume = care.temp.notaudio.getVolume()
function notaudio.getVolume()
end

--- @function care.temp.notaudio.newSource
--- @summary Creates an notaudio source. (This is temporary and just here to test the API docs.)
--- @param path string Path to an notaudio file.
--- @return source care.temp.notaudio.Source new notaudio source.
--- @example
--- local music = care.temp.notaudio.newSource('music.mp3')
function notaudio.newSource(path)
end

--- @class care.temp.notaudio.Source
--- @summary A playable notaudio source.
--- @description (This is temporary and just here to test the API docs.)

--- @method care.temp.notaudio.Source:play
--- @summary Starts playback.
--- @return nil Nothing.
--- @example
--- music:play()
function Source:play()
end

--- @method care.temp.notaudio.Source:stop
--- @summary Stops playback.
--- @return nil Nothing.
--- @example
--- music:stop()
function Source:stop()
end

--- @method care.temp.notaudio.Source:setVolume
--- @summary Sets the volume of the source.
--- @param volume number Source volume from 0 to 1.
--- @return nil Nothing.
--- @example
--- music:setVolume(0.25)
function Source:setVolume(volume)
end

--- @class care.temp.notaudio.SoundData
--- @summary notaudio sample data. (This is temporary and just here to test the API docs.)
--- @field sampleRate number Samples per second.
--- @field channels number Number of notaudio channels.
