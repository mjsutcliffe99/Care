# <a href="../../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">care</a>.<a href="../../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">anim</a>.<a href="../" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">system</a>.<a href="./" style="font-family: inherit !important; font-size: inherit; font-weight: inherit; text-transform: inherit;">import</a>

<span class="api-kind">Function</span>

Imports all animations from a json/png file pair

TODO: Explain the json format!

## Syntax

```lua
care.anim.system.import(image_path, reg_path, speed, scale)
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `image_path` | string | Path to the image file that contains the frames of one or more animations. |
| `reg_path` | string | Path to the json file that describes the animations. |
| `speed` | number | Playback speed of the animations, measured in seconds per frame. |
| `scale` | number | (Optional) Scaling factor applied the imported animation frames. (Useful for upscaling pixel art.) Defaults to 1 (i.e. real-size). |

## Returns

Nothing.

## Example

```lua
TODO
```
