# <a href="../../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">care</a>.<a href="../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">anim</a>.<a href="../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">Animation</a>:<a href="./" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">getSpeed</a>

<span class="api-kind">Method</span>

Returns the default playback speed of the animation.


An individual instance (see [care.anim.Instance](../instance/index.md)) of the animation may optionally override this with its own playback speed.

## Syntax

```lua
speed = source:getSpeed()
```

## Arguments

None.

## Returns

| Name | Type | Description |
| --- | --- | --- |
| `speed` | number | Currently set duration of each frame, in seconds. |

## Example

```lua
local speed = animation:getSpeed()
```
