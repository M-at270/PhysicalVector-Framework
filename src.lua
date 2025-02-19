-- By: M_at270
-- Visit API.md for explanations on every type & property & method
-- Visit Examples.md for a tutorial and code that uses the module.
-- Visit README.md for more credit, contacts and overview

local module = {}

local SETTINGS: {[string]: any} = nil
-- settings will be defined once the module is initialized

-- // Requirements

local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local TWS = game:GetService("TweenService")

-- stores the most used functions in short variables to simplify use
local VECT = Vector3.new
local CF = CFrame.new
local RAD = math.rad
local SQRT = math.sqrt

-- // Initialization

module.Initialize = function(
	SETTINGS: {[string]: any} 
)	--the type of the settings is a table {string: any}
	
	SETTINGS = SETTINGS
	
	-- creates new instances that constitute to the vector model
	local newModel = Instance.new("Model") --model
	local newMeshPart = Instance.new("Part")
	local mesh = Instance.new("SpecialMesh")
	mesh.Parent = newMeshPart
	newMeshPart.Name = "MeshPart" -- names are used in methods
	local newPart = Instance.new("Part")
	local highlight = Instance.new("Highlight")
	local origin = Instance.new("Part")
	local billboardGui = Instance.new("BillboardGui")
	local textLabel = Instance.new('TextLabel')

	origin.Name = "Origin" -- names are used in methods
	
	-- shortening the code via applying a loop on the baseparts
	for _, i in ipairs({newPart, newMeshPart, origin, highlight}) do
		i.Parent = newModel

		if not i:IsA("Part") then continue end -- change properties of every part (no nesting)
		i.Anchored = true
		i.BottomSurface = Enum.SurfaceType.Smooth
		i.CanCollide = false
		i.CastShadow = SETTINGS["CastShadow"] or true -- changes to settings['castshadow'] if it exists, else true

		if not SETTINGS["ObjectColor"] then continue end
		i.Color = SETTINGS["ObjectColor"]
	end

	textLabel.Parent = billboardGui
	textLabel.TextScaled = true
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(1, 0, 1, 0) --edits the properties of billboardgui.textlabel (hovertext will be enabled via PhysicalVector:AddHoverText)
	textLabel.FontFace = Font.fromEnum(Enum.Font.Highway)
	billboardGui.Parent = newPart
	billboardGui.Enabled = false
	billboardGui.Size = UDim2.new(0, 400, 0, 50) --change if needed

	newPart.Size = VECT(5, 0.5, 0.5) -- specific properties as from the previous vector model
	newPart.CFrame = CF(VECT(17.75, 6, -7.75)) * CFrame.fromEulerAnglesXYZ(RAD(0), RAD(45), RAD(90)) -- RAD(0) or 0

	newMeshPart.Size = VECT(2.5, 2.5, 2.5)
	newMeshPart.CFrame = CF(VECT(17.75, 9.75, -7.75)) * CFrame.fromEulerAnglesXYZ(RAD(0), RAD(45), RAD(0))

	origin.Size = VECT(1, 1, 1) -- Vector.one
	origin.CFrame = CF(VECT(17.75, 3.5, -7.75)) * CFrame.fromEulerAnglesXYZ(RAD(0), RAD(90), RAD(0))

	-- apply settings (scalable)

	--highlight.FillColor = 0
	if SETTINGS["OutlineTransparency"] then -- checks if the desired setting exists in rhe table, if it does then
		highlight.OutlineTransparency = SETTINGS["OutlineTransparency"] -- apply the setting to the property
	else highlight.OutlineTransparency = 1 end -- else apply the default setting

	if SETTINGS["FillTransparency"] then -- analogous
		highlight.FillTransparency = SETTINGS["FillTransparency"]
	else highlight.FillTransparency = 0 end

	if SETTINGS["OutlineColor"] then
		highlight.OutlineColor = SETTINGS["OutlineColor"]
	end -- else defaults to Color3.fromRGB(255, 255, 255)

	if SETTINGS["ArrowTipMesh"] then
		mesh.MeshId = SETTINGS["ArrowTipMesh"]
	else mesh.MeshId = "rbxassetid://8535989451" end

	if not SETTINGS["CubeShape"] then -- checks if the desired setting either: is set to false or does not exist
		origin.Shape = Enum.PartType.Ball -- if so, then set the shapes
		newPart.Shape = Enum.PartType.Cylinder
	end --else nothing changes, usually the parts are of cube shape

	-- finish
	newModel.Name = "Vector"
	newModel.PrimaryPart = origin -- origin (the sphere) will be used as the main part of the model
	newModel.Parent = if game.Players.LocalPlayer then RS else SS -- dependant whether it's serverside (if localplayer exists then RS, else SS)
end

-- // MAIN TYPE

-- creates the main class (type) for vectors
export type PhysicalVector = {
	__index: PhysicalVector;
	Point2: Vector3;
	model: Model;          								-- Model of the vector
	adornee: Instance;     								-- Model of the physical object
	Color: Color3;										-- Color of the highlight
	new: (adornee, Point2) -> PhysicalVector;   		-- Constructor
	fromMatrix: (adornee, matrix) -> PhysicalVector;	-- Constructor from matrix (constant rotation)
	update: (self: PhysicalVector) -> ();				-- To be binded to renderstep
	Destroy: (self) -> {}								-- Destroys the vector entirely
}

local Vector: PhysicalVector = {} :: PhysicalVector -- use a new vector object with the type of physicalvector
Vector.__index = Vector

-- // CONSTRUCTORS

-- Creates an arrow between an object and a point
function Vector.new(adornee, Point2, Color)
	local self = {} -- create the new vector object itself
	self.adornee = adornee
	self.Point2 = Point2
	self.Color = Color

	-- Position and rotate the vector model
	local magnitude = Point2.Magnitude - 2.5 -- 2.5 is the vector arrow tip's size

	local LookAt = CFrame.lookAt(self.adornee.Position, self.adornee.Position+Point2) --creates a new CFrame that starts at adornee and points at Point2
	LookAt *= CFrame.fromEulerAnglesXYZ(RAD(90), RAD(90), RAD(90)) -- rotate the model correctly
	self.model = RS.Vector:Clone() or SS.Vector:Clone() -- gets the vector model from RS or SS as it can be in both
	self.model.Highlight.FillColor = self.Color
	self.model.Parent = workspace
	self.model.PrimaryPart.CFrame = LookAt

	-- Scale the vector by sizing and positioning it's parts
	self.model.Part.Size = VECT(magnitude, self.model.Part.Size.Y, self.model.Part.Size.Z) -- part's X size is the length
	self.model.Part.CFrame = LookAt * CF(magnitude/2, 0, 0) -- move infront half of the length
	self.model.MeshPart.CFrame = CFrame.lookAt(self.model.Origin.Position, Point2)
	self.model.MeshPart.Rotation = self.model.Part.Rotation - VECT(0, 0, 90)
	self.model.MeshPart.CFrame *= CF(0, magnitude, 0)

	return setmetatable(self, Vector) -- returns the metatable of the created vector and class itself
end

-- Creates an arrow that constantly points in the direction of matrix
function Vector.fromMatrix(adornee, matrix: {number}, Color)
	local self = {}
	self.adornee = adornee
	self.Color = Color

	--[[Matrix format:
		{ox, oy, oz,
		oxx, oyx, ozx,
		oxy, oyy, ozy,
		oxz, oyz, ozz}
	]]

	local ox, oy, oz, oxx, oyx, ozx, oxy, oyy, ozy, oxz, oyz, ozz = matrix[1], matrix[2], matrix[3], matrix[4], matrix[5], matrix[6], matrix[7], matrix[8], matrix[9], matrix[10], matrix[11], matrix[12] 

	-- calculate the magnitude using -lookvector's coords
	local magnitude = SQRT(
		ozx * ozx + ozy * ozy + ozz * ozz
	)*4 -- the square root of a right triangle's sides' squares is the hypotenuse (multiply by 4 to apply significance, as magnitude of 1 is shown incorrectly lol)

	local CFr = CF(ox, oy, oz, oxx, oyx, ozx, oxy, oyy, ozy, oxz, oyz, ozz) -- creating the CFrame from 12 components and rotating it
	CFr *= CFrame.fromEulerAnglesXYZ(RAD(90), RAD(90), RAD(90))

	-- Scale the vector by sizing and positioning it's parts
	self.model = RS.Vector:Clone() or SS.Vector:Clone() -- gets vector model from RS or SS because it can be in both
	self.model.Highlight.FillColor = Color
	self.model.Parent = workspace
	self.model.PrimaryPart.CFrame = CFr

	self.model.Part.Size = VECT(magnitude, self.model.Part.Size.Y, self.model.Part.Size.Z) --takes magnitude as the X parameter to change the cylinder's length
	self.model.Part.CFrame = CFr * CF(magnitude/2, 0, 0) -- moves the cylinder forward by half of the magnitude by adding cframes
	self.model.MeshPart.CFrame = CFr
	self.model.MeshPart.Rotation = self.model.Part.Rotation - VECT(0, 0, 90) --rotates the cylinder 90 degrees Z
	self.model.MeshPart.CFrame *= CF(0, magnitude, 0)

	return setmetatable(self, Vector) -- returns the metatable of the created vector and class itself
end

-- // METHODS

-- Updates the vector to point at point2
function Vector:update()
	local Point2 = self.Point2
	local magnitude = Point2.Magnitude - 2.5 -- calculates vector length and removes 2.5, because 2.5 is the size of the arrow tip (cone)

	local LookAt = CFrame.lookAt(self.adornee.Position, self.adornee.Position+Point2) --creates a new cframe that looks at Point2 from adornee
	LookAt *= CFrame.fromEulerAnglesXYZ(RAD(90), RAD(90), RAD(90))

	self.model.Highlight.FillColor = self.Color
	self.model.PrimaryPart.CFrame = LookAt
	self.model.Part.Size = VECT(magnitude, self.model.Part.Size.Y, self.model.Part.Size.Z)
	self.model.Part.CFrame = LookAt * CF(magnitude/2, 0, 0)
	self.model.MeshPart.CFrame = CFrame.lookAt(self.model.Origin.Position, Point2)
	self.model.MeshPart.Rotation = self.model.Part.Rotation - VECT(0, 0, 90)
	self.model.MeshPart.CFrame *= CF(0, magnitude, 0) -- moves the cone mesh forward by magnitude
end

function Vector:Destroy()	-- setting the parent & metatable of both to nil will destroy both
	self.model.Parent = nil

	return setmetatable(self, nil)
end

-- Updates the vector to point in direction of matrix
function Vector:updateMatrix(matrix)
	local ox, oy, oz, oxx, oyx, ozx, oxy, oyy, ozy, oxz, oyz, ozz = matrix[1], matrix[2], matrix[3], matrix[4], matrix[5], matrix[6], matrix[7], matrix[8], matrix[9], matrix[10], matrix[11], matrix[12] 

	local magnitude = SQRT(
		ozx * ozx + ozy * ozy + ozz * ozz
	)*4 -- the square root of a right triangle's sides' squares is the hypotenuse (multiply by 4 to apply significance, as magnitude of 1 is shown incorrectly lol)

	local CFr = CF(ox, oy, oz, oxx, oyx, ozx, oxy, oyy, ozy, oxz, oyz, ozz)
	CFr *= CFrame.fromEulerAnglesXYZ(RAD(90), RAD(90), RAD(90))

	self.model.Highlight.FillColor = self.Color
	self.model.PrimaryPart.CFrame = CFr

	self.model.Part.Size = VECT(magnitude, self.model.Part.Size.Y, self.model.Part.Size.Z)
	self.model.Part.CFrame = CFr * CF(magnitude/2, 0, 0)
	self.model.MeshPart.CFrame = CFr
	self.model.MeshPart.Rotation = self.model.Part.Rotation - VECT(0, 0, 90)
	self.model.MeshPart.CFrame *= CF(0, magnitude, 0)
end

function Vector:AddHoverText(offset: Vector3, text: string, textColor3: Color3)
	self.model.Part.BillboardGui.ExtentsOffset = offset
	self.model.Part.BillboardGui.Enabled = true
	self.model.Part.BillboardGui.TextLabel.Text = text
	self.model.Part.BillboardGui.TextLabel.TextColor3 = textColor3
end

function Vector:RemoveHoverText()
	self.model.Part.BillboardGui.Enabled = false
end

-- // ANIMATIONS TABLE

-- creates a metatable to store animations in, will consist in PhysicalVector
export type Animations = {
	__index: Animations;
	Grow: (vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number) -> ();
	FadeIn: (vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number) -> ();
	FadeOut: (vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number) -> ();
	TweenColor: (vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number, targetColor: Color3) -> ();
	TweenHoverTextProperties: (vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number, targetProperties: {}) -> ();
	MovePoints: (vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number, Point4: Vector3) -> ()
}

local Animations: Animations = {} :: Animations -- needs a new object with type Animations
Animations.__index = Animations

Vector.Animations = Animations -- parent to Vector

-- // ANIMATIONS

function Animations.Grow(vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number)
	-- YIELDS THE RUNNING THREAD TILL ANIMATION COMPLETES (otherwise would run in an exception with renderstepped)

	local magnitude = vect.Point2.Magnitude - 2.5 -- Point2: Vector3
	local CFr = vect.model.PrimaryPart.CFrame
	local MeshCFr = vect.model.MeshPart.CFrame

	vect.model.MeshPart.CFrame = CFr * CF(0, 0, 0) -- empty cframe to change if needed offset
	vect.model.Part.CFrame = CFr
	vect.model.Part.Size = VECT(0.1, vect.model.Part.Size.Y, vect.model.Part.Size.Z)
	vect.model.MeshPart.Rotation = vect.model.Part.Rotation - VECT(0, 0, 90)

	TWS:Create(
		vect.model.MeshPart, TweenInfo.new(RunTime, EasingStyle), {CFrame = MeshCFr}
	):Play() -- tween MeshPart's cframe to MeshCFr
	TWS:Create(
		vect.model.Part, TweenInfo.new(RunTime, EasingStyle), {Size = VECT(magnitude, vect.model.Part.Size.Y, vect.model.Part.Size.Z),
			CFrame = CFr * CF(magnitude/2, 0, 0)
		}
	):Play() -- tween vect.model.Part's size's X coordinate (length) and CFrame forward half of the length

	task.wait(RunTime)
end

function Animations.FadeIn(vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number)
	local self: {} = vect -- uses self (vector itself) to get other parts of it
	local targetTransparency = 0

	for _, i: Instance in ipairs(self.model:GetChildren()) do -- iterates over all Parts of the vector model to change their color
		if i:IsA("Part") then
			i.Color = SETTINGS["ObjectColor"] or Color3.new(152, 152, 152) --resets every part color to suppress glow while fading (highlight declines)
		end
	end

	TWS:Create(
		self.model.MeshPart, TweenInfo.new(RunTime, EasingStyle), {Transparency = targetTransparency}
	):Play()
	TWS:Create(
		self.model.Part, TweenInfo.new(RunTime, EasingStyle), {Transparency = targetTransparency}
	):Play()

	task.wait(RunTime)
end

function Animations.FadeOut(vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number)
	local self: {} = vect -- analogous to previus function
	local targetTransparency = 1

	for _, i: Instance in ipairs(self.model:GetChildren()) do -- iterates over all Parts of the vector model to change their color
		if i:IsA("Part") or i:IsA("MeshPart") then
			i.Color = SETTINGS["ObjectColor"] or Color3.new(152, 152, 152) --resets every part color to suppress glow while fading (highlight declines)
		end
	end

	TWS:Create(
		self.model.MeshPart, TweenInfo.new(RunTime, EasingStyle), {Transparency = targetTransparency}
	):Play()
	TWS:Create(
		self.model.Part, TweenInfo.new(RunTime, EasingStyle), {Transparency = targetTransparency}
	):Play()

	task.wait(RunTime)
end

function Animations.TweenColor(vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number, targetColor: Color3)
	local self: {} = vect

	TWS:Create( --creates a new tween with the goal of targetColor FillColor
		self.model.Highlight, TweenInfo.new(RunTime, EasingStyle), {FillColor = targetColor}
	):Play() -- play the tween
	
	-- since we're changing the color, change the vector's Color property to the new color
	self.Color = targetColor

	task.wait(RunTime)
end

function Animations.TweenHoverTextProperties(vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number, targetProperties: {})
	local self: {} = vect
	local HoverText = self.model.Part.BillboardGui.TextLabel

	TWS:Create(
		HoverText, TweenInfo.new(RunTime, EasingStyle), targetProperties
	):Play() -- simply tween the properties (however can run into an exception if the property is boolean, int, str or object)

	task.wait(RunTime)
end

function Animations.MovePoints(vect: Vector, EasingStyle: Enum.EasingStyle, RunTime: number, Point4: Vector3)
	local self: {} = vect
	local Point2 = self.Point2
	local origin = self.adornee.Position
	local magnitude = Point4.Magnitude - 2.5

	local newCF = CFrame.lookAt(origin, origin+Point4)
	newCF *= CFrame.fromEulerAnglesXYZ(RAD(90), RAD(90), RAD(90)) -- rotate correctly

	local newPartCF = newCF * CF(magnitude/2, 0, 0) -- move forwards half of the length
	local newPartSize = VECT(magnitude, self.model.Part.Size.Y, self.model.Part.Size.Z)
	local newMeshPartCF = newCF * CF(magnitude, 0, 0)
	local newMeshPartRotation = newMeshPartCF * self.model.MeshPart.CFrame.Rotation * CFrame.Angles(180, 0, 0)

	-- create a new vector to simplify calculations and remove later
	local testVector = Vector.new(self.adornee, Point4, Color3.new(0.5, 0.5, 0.5)) --create a new Vector using .new()
	local newMeshPartRotation = testVector.model.MeshPart.CFrame -- get the desired rotation
	testVector:Destroy() -- and remove it via the custom method :Destroy()

	TWS:Create( -- and tween the CFrames of both objects (excluding origin, that'll move when updated)
		self.model.Part, TweenInfo.new(RunTime, EasingStyle), {CFrame = newPartCF, Size = newPartSize}
	):Play()

	TWS:Create(
		self.model.MeshPart, TweenInfo.new(RunTime, EasingStyle), {CFrame = newMeshPartRotation}
	):Play()

	self.Point2 = Point4
	task.wait(RunTime)
end

-- save in module via setting the metatable of the created Vector table to PhysicalVector

-- metatable hierarchy: PhysicalVector --> Vector --> self AND PhysicalVector --> Vector --> Animations

module.PhysicalVector = setmetatable(Vector, {} :: PhysicalVector)

return module
