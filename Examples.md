## PhysicalVector Examples and Tutorial

PhysicalVector should be created as a ModuleScript in either ReplicatedStorage or ServerScriptService, depending whether it is used on the client or server.

Get the module:
```lua
local VectorModule = require(game.ReplicatedStorage.PhysicalVector)
```

Firstly, we have to initialize the module. <br>
During initialization the module creates a vector model and applies personal settings.

The format of settings is `["Property"] = value`, all stored in a table.
```lua
VectorModule.Initialize(
	{["OutlineTransparency"] = 0.5;
		["ObjectColor"] = Color3.fromRGB(0, 0, 0);
		["OutlineColor"] = Color3.fromRGB(255, 0, 0);
		["FillTransparency"] = 0.5;
	}
)
```

This will initialize the module and apply such settings as the transparency of vector outlines at 0.5 and etc.

I will use a specific folder `PhysicalObjects` in `Workspace` with objects for vectors.

Let's create our first vector. <br>
We'll use `PhysicalVector.new()`

```lua
local vect = VectorModule.PhysicalVector.new(
	workspace.PhysicalObjects:WaitForChild('Part'), 
	Vector3.new(15, -15, 15),
  Color3.new(0.305882, 0.490196, 1)
)
```
This creates a new vector at `Workspace.PhysicalObjects.Part` that points at the coordinate (15, 15, 15) relative to the Part.
> [!NOTE]
> While creating a vector via `PhysicalVector.new()`, the Y coordinate of Point2 should be reversed.

The color of the vector in Settings is the color of the baseparts. <br>
The color of the vector in functions is the color of the highlight.

Playtest the game: The vector starts at an object and points toward (15, 15, 15). <br>

However, if we move the vector's adornee object, nothing changes. <br>
To consistently attach the vector to the adornee object, we should connect the `PhysicalVector:update()` function to a `RunService.RenderStepped` event, as so:

```lua
local RS = game:GetService("RunService")

RS.RenderStepped:Connect(function(dt)
	vect:update()
end)
```

Now the vector will consistently update with each frame.

Let's create `vect2` and use an animation on it.
```lua
local vect2 = VectorModule.PhysicalVector.new(
	workspace.PhysicalObjects.Part2,
	Vector3.new(15, -15, 15),
	Color3.new(1, 0, 0.0156863)
)
```

Let's "grow" the vector, updating and giving it a hovering text beforehand:
```lua
task.wait(1)
vect2:update()

task2.wait(2)
vect2:AddHoverText(Vector3.new(0, 1.5, 0), "Grow Animation", vect.model.Highlight.FillColor)
VectorModule.PhysicalVector.Animations.Grow(vect2, Enum.EasingStyle.Quad, 2)
```

This will add a text "Grow Animation" above the vector and apply the Grow animation to it with an easing style of Quad and time of 2.

> [!NOTE]
> To edit the hovering text of a vector, use `PhysicalVector:AddHoverText()` again with the new properties. <br>
> You can also edit other text properties with `PhysicalVector.Animations.TweenHoverTextProperties()`.

*An example of a fun application of PhysicalVector* <br>
Let's have a vector always point toward it's adornee's Force.

To do this, create a new `PhysicalVector` object. <br>
In the `RS.RenderStepped` event we will constantly edit the vector's Point2 and update it.

We will multiply the adornee's Velocity by -1 to point in the direction of the force:
```lua
RS.RenderStepped:Connect(function(dt)
	local velocity = -vect3.adornee:GetVelocityAtPosition(vect3.adornee.Position + Vector3.new(0, 0, 0))
	vect3.Point2 = velocity
	vect3:update()
end)
```

