# <a href="../../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">care</a>.<a href="../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">anim</a>.<a href="../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">Animation</a>:<a href="./" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">setSpeed</a>

<span class="api-kind">Method</span>

Sets the default playback speed of the animation.


Individual instances (see [care.anim.Instance]) of the animation may optionally ignore this and set its own playback speed.

## Syntax

```lua
source:setSpeed(speed)
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `speed` | number | Duration of each frame, in seconds. |

## Returns

Nothing.

## Example

```lua
animation:setSpeed(0.05)
```
