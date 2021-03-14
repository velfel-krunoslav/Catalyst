# Design and brand identity guidelines
## Fonts
You should use the Inter typeface, as provided in the `assets/fonts` directory.
In general, text is styled with `Regular`, `Medium` or `Semi Bold` variants, with sizes being 13, 14 or 24px depending on the context.
Do not use the default Roboto typeface.

## Colors
**DO NOT hardcode color values in your code**. Always define constants which you'll later refer to.
Components found in the Figma prototype will **always** consist of one of the following colors, or a gradient of two:
| Color | Hex value | Constant name to use |
|--|--|--|
| ![red](img/attention.png) | `0xCB1C04 ` | RED_ATTENTION |
| ![green_success](img/success.png) | `0x33AE08` | GREEN_SUCCESSFUL |
| ![black](img/jet_black.png) | `0x000000` | BLACK |
| ![dark_grey](img/dark_grey.png) | `0x6D6D6D` | DARK_GREY |
| ![light_grey](img/light_grey.png) | `0xECECEC` | LIGHT_GREY |
| ![dark_green](img/dark_green.png) | `0x07630B` | DARK_GREEN |
| ![mint](img/mint.png) | `0x1BD14C ` | MINT_GREEN |
| ![olive](img/olive.png) | `0x009A29` | OLIVE_GREEN |
| ![teal](img/teal.png) | `0x0EAD65` | GREEN_TEAL |

## Icons
The icons you need in order to implement the UI can be found in the `assets/icons` directory.
If, by a chance, an icon is missing you can export it from the Figma prototype the following way:
```
[right click on a path or .SVG layer] ->
Copy/Paste ->
Copy as SVG
```
Open a text editor, paste the contents and save the file. Filename should match the component name in the Figma prototype. Be sure to save the file in the `assets/icons` directory so it can be reused.

If you need a new icon, you can grab it from [here](https://www.figma.com/file/yD2aaGo0TfruBPmWivRkzR/Phosphor-Icons-Community?node-id=3819:4526), and be sure to use the `Regular` variant.

