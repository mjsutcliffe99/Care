# <a href="../../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">care</a>.<a href="../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">temp</a>.<a href="../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">audio</a>.<a href="./" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">newSource</a>

<span class="api-kind">Function</span>

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
| `source` | [`care.temp.audio.Source`](source/index.md) | new audio source. |

## Example

```lua
local music = care.temp.audio.newSource('music.mp3')
```
