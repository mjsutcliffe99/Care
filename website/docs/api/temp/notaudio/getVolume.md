# <a href="../../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">care</a>.<a href="../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">temp</a>.<a href="../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">notaudio</a>.<a href="./" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">getVolume</a>

<span class="api-kind">Function</span>

Returns the master notaudio volume.

## Syntax

```lua
volume = care.temp.notaudio.getVolume()
```

## Arguments

None.

## Returns

| Name | Type | Description |
| --- | --- | --- |
| `volume` | number | Current master volume between 0 and 1. |

## Example

```lua
local volume = care.temp.notaudio.getVolume()
```
