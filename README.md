# PhysicalVector Module
By M_at270

*README.md last update: 17.02.2025*

PhysicalVector is a free open-source Roblox Module that allows you to create, manage, store and animate vectors (arrows) in workspace.
Applications of this module can be considered purely educational, physical, algebraic or showcase.

## Overview
PhysicalVector can be used in both local and serverside scripts. <br>

Get the module:
```lua
local VectorModule = require(game.ReplicatedStorage.PhysicalVector)
```

PhysicalVector has 2 ways of creating vectors:
  - From a point.
  - From a matrix.

For much more advanced capabilities we recommend `PhysicalVector.fromMatrix()` <br>
And for much simpler uses `PhysicalVector.new()`.

The function `PhysicalVector:update()` is designated to refresh the vector. <br>
Any vector can be destroyed via `PhysicalVector:Destroy()`. <br>
You can add text above or below the vector with `PhysicalVector:AddHoverText()`.

PhysicalVector offers **Animations**: Smooth and configurable animations of vectors.

`Animations.Grow()` will smoothly create the vector by "growing" it from it's starting point. <br>

A vector can dissapear and appear with `Animations.FadeOut()` and `Animations.FadeIn()`.

A vector can smoothly move from one point to another with `Animations.MovePoints()`
##
PhysicalVector can be used in both algebraic, scientific, physical or simple uses, such as pointing an arrow toward an object as indication.

For a tutorial and examples visit `Examples.md`!

PhysicalVector's API is documented in `API.md`!

PhysicalVector's source code is in `src.lua`!

## Contact

My roblox account: <a href="https://www.roblox.com/users/1368132378/profile">M_at270</a> <br>

PhysicalVector is also listed on my portfolio: <a href="https://devforum.roblox.com/t/for-hire-ui-designer-full-stack-scripter-portfolio/3459676">Portfolio</a> <br>

My Discord: mat270
