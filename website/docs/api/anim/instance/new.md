# <a href="../../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">care</a>.<a href="../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">anim</a>.<a href="../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">Instance</a>.<a href="./" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">new</a>

<span class="api-kind">Function</span>

Creates a new instance of an animation.


Creates a new instance of the animation provided by a care.anim.Animation object.

## Syntax

```lua
animation = care.anim.Instance.new(anim, repeats, speed, on_complete)
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `anim` | [`care.anim.Animation`](../animation/index.md) | Reference animation that this instance plays. |
| `repeats` | boolean | (Optional) Whether the animation repeats after completion (or otherwise is deleted). Defaults to false if not specified. |
| `speed` | number | (Optional) Playback speed of the animation, measured in seconds per frame. If not specified, the default speed specified in the care.anim.Animation object will be used. |
| `on_complete` | function | (Optional) Function called upon completion of this instance of the animation (after the on_complete callback of its associated care.anim.Animation). |

## Returns

| Name | Type | Description |
| --- | --- | --- |
| `animation` | [`care.anim.Animation`](../animation/index.md) | The newly created animation object. |

## Example

```lua
TODO
```
