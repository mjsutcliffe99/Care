# <a href="../../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">care</a>.<a href="../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">temp</a>.<a href="../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">audio</a>.<a href="./" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">setVolume</a>

<span class="api-kind">Function</span>

Sets the master audio volume.

## Syntax

```lua
care.temp.audio.setVolume(volume)
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `volume` | number | Master volume from 0 to 1. [care.temp.notaudio](../notaudio/index.md) |

## Returns

Nothing.

## Example

```lua
care.temp.audio.setVolume(0.5)
```
