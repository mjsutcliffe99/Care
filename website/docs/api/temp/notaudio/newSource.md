# care.temp.notaudio.newSource

Creates an notaudio source. (This is temporary and just here to test the API docs.)

## Syntax

```lua
source = care.temp.notaudio.newSource(path)
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `path` | string | Path to an notaudio file. |

## Returns

| Name | Type | Description |
| --- | --- | --- |
| `source` | [`care.temp.notaudio.Source`](source/index.md) | new notaudio source. |

## Example

```lua
local music = care.temp.notaudio.newSource('music.mp3')
```
