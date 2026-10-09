# care.temp.audio.newSource

Creates an audio source. (This is temporary and just here to test the API docs.)

## Syntax

```lua
source = care.temp.audio.newSource(path)
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `path` | string | Path to an audio file. |

## Returns

| Name | Type | Description |
| --- | --- | --- |
| `source` | [`care.temp.audio.Source`](Source/index.md) | new audio source. |

## Example

```lua
local music = care.temp.audio.newSource('music.mp3')
```
