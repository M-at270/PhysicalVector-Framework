# PhysicalVector Module

> [!NOTE]
> Module "PhysicalVector" contains the object type [PhysicalVector].
> To avoid confusion, the module will be referenced as Module and the object type as PhysicalVector.

### Module.Initialize()
```lua
Module.Initialize(
  SETTINGS [{
    [string]: any
}]
) -> ()
```
Creates the vector model in `game.ReplicatedStorage` if ran in a `LocalScript`, and in `game.ServerStorage` if ran in a `Script`.
Applies `SETTINGS`. <br>
*Example of SETTINGS format:* <br>
```lua
Module.Initialize(
  {["ObjectColor"] = Color3.new(0, 0, 0);
   ["OutlineTransparency"] = 1
}
```
Applicable settings: <br>
`["ObjectColor"] = [Color3]` <br>
`["OutlineTransparency"] = [number]`

## [PhysicalVector]
### PhysicalVector.Point2
```lua
PhysicalVector.Point2 [Vector3]
```
The point that the PhysicalVector will initially point to.
### PhysicalVector.model
```lua
PhysicalVector.model [Model]
```
The model in Workspace of the vector.
### PhysicalVector.adornee
```lua
PhysicalVector.adornee [Instance]
```
The object where the vector will initially start at once created and/or updated.
### PhysicalVector.Color
```lua
PhysicalVector.Color [Color3]
```
The FillColor of the vector's model's highlight.
### PhysicalVector.new()
```lua
PhysicalVector.new(
    adornee [Instance],
    Point2 [Vector3],
    Color [Color3]
) -> [PhysicalVector]
```
The first and main constructor of PhysicalVector.
Creates a vector that starts at `adornee.Position`, has a magnitude of `Point2.Magnitude` and `self.model.Highlight.FillColor` of `Color`.

### PhysicalVector.fromMatrix()
```lua
PhysicalVector.fromMatrix(
    adornee [Instance],
    matrix [{number}],
    Color [Color3]
) -> [PhysicalVector]
```
Secondary constructor of PhysicalVector.
Creates a vector that starts at `adornee.Position`.
The vector's Orientation is depicted via `matrix`, which is in the format of `CFrame:GetComponents()`:
```lua
{ox, oy, oz,
oxx, oyx, ozx,
oxy, oyy, ozy,
oxz, oyz, ozz}
```
The vector's magnitude is calculated via the square root of (ozx * ozx + ozy * ozy + ozz * ozz) multiplied by 4.
If needed to pertain original magnitude, divide the ZVector, RightVector and UpVector components by 4.

### PhysicalVector:update()
> [!NOTE]
> To achieve a constant updating cycle execute `PhysicalVector:update()` in a `RunService:RenderStepped` event. <br>

Updates the vector's position to start at `self.adornee.Position` and end at `self.Point2`.

### PhysicalVector:Destroy()
Sets `self`'s metatable to `nil` and `self.model`'s parent to `nil`.

### PhysicalVector:updateMatrix()
```lua
PhysicalVector:updateMatrix(
  matrix [{number}]
) -> ()
```
Updates the vector with the given `matrix`.
Changes properties of the vector analogous to `PhysicalVector.fromMatrix()`

### PhysicalVector:AddHoverText()
```lua
PhysicalVector:AddHoverText(
offset [Vector3],
text [string],
textColor3 [Color3]
) -> ()
```
Sets the vector's `BillboardGui.Enabled` to `true`.
Edits the `BillboardGui.ExtentsOffset` to `offset`, `BillboardGui.TextLabel.Text` to `text` and `BillboardGui.TextLabel.TextColor3` to `textColor3`.

### PhysicalVector:RemoveHoverText()
Sets the vector's `BillboardGui.Enabled` to `false`.

# [Animations]

> [!WARNING]
> Running any of the animations yields the running thread for `RunTime` seconds to avoid overlapping functions.

### Animations.Grow()
```lua
Animations.Grow(
vect [PhysicalVector],
EasingStyle [Enum.EasingStyle],
RunTime [number]
) -> ()
```
Tweens the `vect`'s magnitude from 0 to `vect.Point2.Magnitude` for `RunTime` seconds with the style `EasingStyle`.

### Animations.FadeIn()
```lua
Animations.FadeIn(
vect [PhysicalVector],
EasingStyle [Enum.EasingStyle],
RunTime [number]
) -> ()
```
Tweens the `vect.Model`'s Transparency to 0 for `RunTime` seconds with the style `EasingStyle`.

### Animations.FadeOut()
```lua
Animations.FadeOut(
vect [PhysicalVector],
EasingStyle [Enum.EasingStyle],
RunTime [number]
) -> ()
```
Tweens the `vect.Model`'s Transparency to 1 for `RunTime` seconds with the style `EasingStyle`.

### Animations.TweenColor()
```lua
Animations.TweenColor(
vect [PhysicalVector],
EasingStyle [Enum.EasingStyle],
RunTime [number],
targetColor [Color3]
) -> ()
```
Tweens the `vect.Model.HighLight.FillColor` to `targetColor` for `RunTime` seconds with the style `EasingStyle`.

### Animations.TweenHoverTextProperties()
```lua
Animations.TweenHoverTextProperties(
vect [PhysicalVector],
EasingStyle [Enum.EasingStyle],
RunTime [number],
targetProperties [{}]
) -> ()
```
Tweens properties of the vector's BillboardGui to `targetProperties`.
Allows for multiple properties at once in `targetProperties`.

### Animations.MovePoints()
```lua
Animations.MovePoints(
vect [PhysicalVector],
EasingStyle [Enum.EasingStyle],
RunTime [number],
Point4 [Vector3]
) -> ()
```
Tweens the entire `vect.Model` to point at `Point4`.
Automatically sets `vect.Point2` to `Point4`.
