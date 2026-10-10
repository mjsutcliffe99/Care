# care.anim.Animation.new

<span class="api-kind">Function</span>

Creates a new animation object.


Creates an animation object from a sequence of quads referencing regions of a texture atlas.

## Syntax

```lua
animation = care.anim.Animation.new(atlas, quads, w, h, frame_count, speed, on_complete)
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `atlas` | love.Drawable | Texture atlas containing the animation frames. |
| `quads` | love.Quad[] | Sequence of quads defining the animation frames. |
| `w` | number | Width of each animation frame, in pixels. |
| `h` | number | Height of each animation frame, in pixels. |
| `frame_count` | number | Number of frames in the animation. |
| `speed` | number | Duration of each frame, in seconds. |
| `on_complete` | function | (Optional) Function called upon completion of the animation (before the on_complete callbacks of its instances - see care.anim.Instance). |

## Returns

| Name | Type | Description |
| --- | --- | --- |
| `animation` | [`care.anim.Animation`](index.md) | The newly created animation object. |

## Example

```lua
local animation = care.anim.Animation.new(atlas, quads, 64, 64, 8, 0.1, function()
    score = score + 1
end)
```
