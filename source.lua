local players = game.Players
local tweenService = game:GetService('TweenService');
local httpservice = game:GetService('HttpService');
local runService = game:GetService('RunService');
local coreGui = game:GetService('CoreGui');
local uis = game:GetService('UserInputService');
local tweenService = game:GetService('TweenService');
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local viewport = workspace.Camera.ViewportSize
local lp = players.LocalPlayer
local mouse = lp:GetMouse()

local ElementalUI = {
	Sizes = {
		["Mobile"] = UDim2.new(0, 625, 0, 330),
		["Pc"] = UDim2.new(0, 625, 0, 430)
	},
	IDE = nil,
	Debug = function(text)
		return warn("[ELEMENTAL HUB] :", text)
	end
}
function ElementalUI:Validate(defaults, options)
	options = options or {}
	for k, v in next, (defaults) do
		if options[k] == nil then
			options[k] = v
		end
	end
	return options
end

function ElementalUI:Tween(Obj, Style, Info, Callback)
	local Tw = game:GetService("TweenService"):Create(Obj, TweenInfo.new(Style[1], Enum.EasingStyle[Style[2]]), Info)
	Tw.Completed:Connect(
		Callback or function()
		end
	)
	Tw:Play()
end

function ElementalUI:tween(object, goal, callback)
	local tween = tweenService:Create(object, tweenInfo, goal)
	tween.Completed:Connect(
		callback or function()
		end
	)
	tween:Play()
end

function ElementalUI:GenerateName()
	return tostring({}):sub(10)
end

function ElementalUI:New(options)
	local options = options or {}
	if game:GetService("RunService"):IsStudio() then
		ElementalUI.IDE = "Studio"
	elseif game:GetService("RunService"):IsClient() then
		ElementalUI.IDE = "Client"
	else
		ElementalUI:Debug("Unknown client type, save system has been disabled.")
		ElementalUI.IDE = "Studio"
	end
	ElementalUI:Validate(
		{
			UITitle = "ELEMENTAL",
			DefaultTheme = "Dark"
		},
		options
	)
	local InternalGUI = {
		CurrentTab = nil,
		Dragging = true,
		Device = nil
	}
	local Chosen_Theme = options.DefaultTheme
	local ThemesColors = {
		["Light"] = {
			["Main-BG"] = Color3.fromRGB(245, 246, 250),
			["Second-BG"] = Color3.fromRGB(255, 255, 255),
			["Hover-BG"] = Color3.fromRGB(34,34,34),
			["PrimaryText-BG"] = Color3.fromRGB(0, 0, 0),
			["Icons-BG"] = Color3.fromRGB(3, 3, 3),
			["SecondaryText-BG"] = Color3.fromRGB(175, 178, 183),
			["Dividers-BG"] = Color3.fromRGB(230, 230, 232)
		},
		["Dark"] = {
			["Main-BG"] = Color3.fromRGB(16, 16, 16),
			["Second-BG"] = Color3.fromRGB(20, 20, 20),
			["Hover-BG"] = Color3.fromRGB(34,34,34),
			["PrimaryText-BG"] = Color3.fromRGB(237, 237, 237),
			["Icons-BG"] = Color3.fromRGB(237, 237, 237),
			["SecondaryText-BG"] = Color3.fromRGB(175, 178, 183),
			["Dividers-BG"] = Color3.fromRGB(42, 42, 42)
		},
	}
	if game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").MouseEnabled then
		InternalGUI.Device = "Mobile"
	else
		InternalGUI.Device = "PC"
	end
	function InternalGUI:MakeDraggable(Frame)
		local dragToggle
		local dragStart
		local startPos
		local function updateInput(input)
			if not InternalGUI.Dragging then
				return
			end
			local delta = input.Position - dragStart
			local screenSize = workspace.CurrentCamera.ViewportSize
			local guiSize = Frame.AbsoluteSize
			ElementalUI:Tween(
				Frame,
				{.1, "Linear"},
				{
					Position = UDim2.new(
						startPos.X.Scale,
						startPos.X.Offset + delta.X,
						startPos.Y.Scale,
						startPos.Y.Offset + delta.Y
					)
				}
			)
		end

		Frame.InputBegan:Connect(
			function(input)
				if
					input.UserInputType == Enum.UserInputType.MouseButton1 or
					input.UserInputType == Enum.UserInputType.Touch
				then
					dragToggle = true
					dragStart = input.Position
					startPos = Frame.Position
					input.Changed:Connect(
						function()
							if input.UserInputState == Enum.UserInputState.End then
								dragToggle = false
							end
						end
					)
				end
			end
		)

		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement or
				input.UserInputType == Enum.UserInputType.Touch
			then
				if dragToggle then
					updateInput(input)
				end
			end
		end
		)
	end
	do
		-- StarterGui.Personal.Elemental/Hub.Monarch
		InternalGUI["1"] = Instance.new("ScreenGui", gethui and gethui() or game:GetService("Players").LocalPlayer.PlayerGui)
		InternalGUI["1"]["Name"] = [[Elemental-HUB]]
		InternalGUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame
		InternalGUI["2"] = Instance.new("Frame", InternalGUI["1"])
		InternalGUI["2"]["Active"] = true
		InternalGUI["2"]["BorderSizePixel"] = 0
		InternalGUI["2"]["BackgroundColor3"] = ThemesColors[options.DefaultTheme]["Main-BG"]
		InternalGUI["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
		InternalGUI["2"]["Size"] = UDim2.new(0, 625, 0, 433)
		InternalGUI["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
		InternalGUI["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.UICorner
		InternalGUI["3"] = Instance.new("UICorner", InternalGUI["2"])
		InternalGUI["3"]["CornerRadius"] = UDim.new(0, 3)

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar
		InternalGUI["4"] = Instance.new("Frame", InternalGUI["2"])
		InternalGUI["4"]["BorderSizePixel"] = 0
		InternalGUI["4"]["BackgroundColor3"] = ThemesColors[options.DefaultTheme]["Second-BG"]
		InternalGUI["4"]["Size"] = UDim2.new(0, 170, 1, 0)
		InternalGUI["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		InternalGUI["4"]["Name"] = [[Sidebar]]

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.UICorner
		InternalGUI["5"] = Instance.new("UICorner", InternalGUI["4"])
		InternalGUI["5"]["CornerRadius"] = UDim.new(0, 3)

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.UITItle
		InternalGUI["6"] = Instance.new("TextLabel", InternalGUI["4"])
		InternalGUI["6"]["TextWrapped"] = true
		InternalGUI["6"]["BorderSizePixel"] = 0
		InternalGUI["6"]["BackgroundColor3"] = ThemesColors[options.DefaultTheme]["Second-BG"]
		InternalGUI["6"]["TextSize"] = 20
		InternalGUI["6"]["FontFace"] = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		InternalGUI["6"]["TextColor3"] = ThemesColors[options.DefaultTheme]["PrimaryText-BG"]
		InternalGUI["6"]["Size"] = UDim2.new(1, 0, 0, 50)
		InternalGUI["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		InternalGUI["6"]["Text"] = string.upper(options.UITitle)
		InternalGUI["6"]["Name"] = [[UITItle]]

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.UITItle.UIPadding
		InternalGUI["7"] = Instance.new("UIPadding", InternalGUI["6"])
		InternalGUI["7"]["PaddingTop"] = UDim.new(0, 4)

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.UITItle.Frame
		InternalGUI["8"] = Instance.new("Frame", InternalGUI["6"])
		InternalGUI["8"]["BorderSizePixel"] = 0
		InternalGUI["8"]["BackgroundColor3"] = ThemesColors[options.DefaultTheme]["Dividers-BG"]
		InternalGUI["8"]["AnchorPoint"] = Vector2.new(0.5, 1)
		InternalGUI["8"]["Size"] = UDim2.new(1, -12, 0, 1)
		InternalGUI["8"]["Position"] = UDim2.new(0.5, 0, 1, 0)
		InternalGUI["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.TabsContainer
		InternalGUI["9"] = Instance.new("ScrollingFrame", InternalGUI["4"])
		InternalGUI["9"]["BorderSizePixel"] = 0
		InternalGUI["9"]["BackgroundColor3"] = Color3.fromRGB(25, 25, 25)
		InternalGUI["9"]["Name"] = [[TabsContainer]]
		InternalGUI["9"]["CanvasSize"] = UDim2.new(0, 0, 1, 0)
		InternalGUI["9"]["Selectable"] = false
		InternalGUI["9"]["Size"] = UDim2.new(1, -12, 1, -58)
		InternalGUI["9"]["Position"] = UDim2.new(0, 6, 0, 54)
		InternalGUI["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		InternalGUI["9"]["ScrollBarThickness"] = 0
		InternalGUI["9"]["BackgroundTransparency"] = 1

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.TabsContainer.UIListLayout
		InternalGUI["a"] = Instance.new("UIListLayout", InternalGUI["9"])
		InternalGUI["a"]["Padding"] = UDim.new(0, 4)
		InternalGUI["a"]["SortOrder"] = Enum.SortOrder.LayoutOrder

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder
		InternalGUI["13"] = Instance.new("Frame", InternalGUI["2"])
		InternalGUI["13"]["BorderSizePixel"] = 0
		InternalGUI["13"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		InternalGUI["13"]["Size"] = UDim2.new(1, -182, 1, -8)
		InternalGUI["13"]["Position"] = UDim2.new(0, 176, 0, 4)
		InternalGUI["13"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		InternalGUI["13"]["Name"] = [[TabsHolder]]
		InternalGUI["13"]["BackgroundTransparency"] = 1
	end

	function InternalGUI:Tab(options)
		local options = options or {}
		ElementalUI:Validate(
			{
				Name = "Tab-Name",
				Icon = [[rbxassetid://10723397895]]
			},
			options
		)
		local Tab = {
			Hover = false,
			Active = false
		}
		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.TabsContainer.Tab
		Tab["f"] = Instance.new("TextButton", InternalGUI["9"])
		Tab["f"]["Active"] = false
		Tab["f"]["BorderSizePixel"] = 0
		Tab["f"]["BackgroundColor3"] = Color3.fromRGB(4, 4, 4)
		Tab["f"]["Selectable"] = false
		Tab["f"]["Size"] = UDim2.new(1, 0, 0, 35)
		Tab["f"]["BackgroundTransparency"] = 1
		Tab["f"]["Name"] = [[Tab]]
		Tab["f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Tab["f"]["Text"] = [[]]
		Tab["f"]["AutoButtonColor"] = false

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.TabsContainer.Tab.UICorner
		Tab["10"] = Instance.new("UICorner", Tab["f"])
		Tab["10"]["CornerRadius"] = UDim.new(0, 6)

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.TabsContainer.Tab.ImageLabel
		Tab["11"] = Instance.new("ImageLabel", Tab["f"])
		Tab["11"]["BorderSizePixel"] = 0
		Tab["11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Tab["11"]["ImageColor3"] = ThemesColors[Chosen_Theme]["Icons-BG"]
		Tab["11"]["Image"] = options.Icon
		Tab["11"]["Size"] = UDim2.new(0, 18, 0, 18)
		Tab["11"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Tab["11"]["BackgroundTransparency"] = 1
		Tab["11"]["Position"] = UDim2.new(0, 6, 0, 8)

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.Sidebar.TabsContainer.Tab.TextLabel
		Tab["12"] = Instance.new("TextLabel", Tab["f"])
		Tab["12"]["BorderSizePixel"] = 0
		Tab["12"]["TextXAlignment"] = Enum.TextXAlignment.Left
		Tab["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Tab["12"]["TextSize"] = 14
		Tab["12"]["FontFace"] = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		Tab["12"]["TextColor3"] = ThemesColors[Chosen_Theme]["PrimaryText-BG"]
		Tab["12"]["BackgroundTransparency"] = 1
		Tab["12"]["Size"] = UDim2.new(1, -36, 0, 16)
		Tab["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Tab["12"]["Text"] = options.Name
		Tab["12"]["Position"] = UDim2.new(0, 32, 0, 9)

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name
		Tab["14"] = Instance.new("ScrollingFrame", InternalGUI["13"])
		Tab["14"]["Active"] = true
		Tab["14"]["Visible"] = false
		Tab["14"]["BorderSizePixel"] = 0
		Tab["14"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Tab["14"]["Name"] = options.Name
		Tab["14"]["Size"] = UDim2.new(1, 0, 1, 0)
		Tab["14"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0)
		Tab["14"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Tab["14"]["ScrollBarThickness"] = 0
		Tab["14"]["BackgroundTransparency"] = 1
		Tab["14"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y

		-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.UIListLayout
		Tab["15"] = Instance.new("UIListLayout", Tab["14"])
		Tab["15"]["Padding"] = UDim.new(0, 12)
		Tab["15"]["SortOrder"] = Enum.SortOrder.LayoutOrder
		do
			function Tab:Activate()
				if Tab.Active == false then
					if InternalGUI.CurrentTab ~= nil then
						InternalGUI.CurrentTab:Deactivate()
					end
					Tab.Active = true
					InternalGUI.CurrentTab = Tab
					
					if Chosen_Theme == "Dark" then
						ElementalUI:tween(Tab["f"], {BackgroundTransparency = 0})
						ElementalUI:tween(Tab["f"], {BackgroundColor3 = ThemesColors[Chosen_Theme]["Hover-BG"]})
						ElementalUI:tween(Tab["12"], {TextColor3 = ThemesColors[Chosen_Theme]["PrimaryText-BG"]})
						ElementalUI:tween(Tab["11"], {ImageColor3 = ThemesColors[Chosen_Theme]["Icons-BG"]})
					else
						ElementalUI:tween(Tab["f"], {BackgroundTransparency = 0})
						ElementalUI:tween(Tab["f"], {BackgroundColor3 = ThemesColors[Chosen_Theme]["Hover-BG"]})
						ElementalUI:tween(Tab["12"], {TextColor3 = Color3.fromRGB(255, 255, 255)})
						ElementalUI:tween(Tab["11"], {ImageColor3 = Color3.fromRGB(255, 255, 255)})
					end

					Tab["14"]["Visible"] = true
				end
			end
			function Tab:Deactivate()
				if Tab.Active then
					Tab.Active = false
					Tab.Hover = false
					if Chosen_Theme == "Dark" then
						ElementalUI:tween(Tab["f"], {BackgroundColor3 = ThemesColors[Chosen_Theme]["Second-BG"]})
						ElementalUI:tween(Tab["f"], {BackgroundTransparency = 1})
						ElementalUI:tween(Tab["12"], {TextColor3 =  ThemesColors[Chosen_Theme]["PrimaryText-BG"]})
						ElementalUI:tween(Tab["11"], {ImageColor3 = ThemesColors[Chosen_Theme]["Icons-BG"]})
					else
						ElementalUI:tween(Tab["f"], {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
						ElementalUI:tween(Tab["f"], {BackgroundTransparency = 1})
						ElementalUI:tween(Tab["12"], {TextColor3 = Color3.fromRGB(4, 4, 4)})
						ElementalUI:tween(Tab["11"], {ImageColor3 = Color3.fromRGB(4, 4, 4)})
					end

					Tab["14"]["Visible"] = false
				end
			end
		end
		Tab["f"].MouseEnter:Connect(
			function()
				if not Tab.Active then
					if Chosen_Theme == "Light" then
						ElementalUI:tween(Tab["f"], {BackgroundTransparency = 0})
						ElementalUI:tween(Tab["f"], {BackgroundColor3 = Color3.fromHex("#f6f6f6")})
					end
					Tab.Hover = true
				end
			end
		)
		Tab["f"].MouseLeave:Connect(
			function()
				if not Tab.Active then
					if Chosen_Theme == "Light" then
						ElementalUI:tween(Tab["f"], {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
						ElementalUI:tween(Tab["f"], {BackgroundTransparency = 1})
					end
					Tab.Hover = false
				end
			end
		)
		Tab["f"].MouseButton1Click:Connect(
			function()
				if Tab.Hover then
					Tab:Activate()
				end
			end
		)
		if InternalGUI.CurrentTab == nil then
			Tab:Activate()
		end

		function Tab:Separator(options)
			local options = options or {}
			ElementalUI:Validate(
				{
					Name = "GENERATE ARTS",
					Description = "elemental hub on top, sponso on flop !"
				},
				options
			)
			options.Name = string.upper(options.Name)

			local Separator = {}

			do
				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.TabSeparator
				Separator["15"] = Instance.new("Frame", Tab["14"])
				Separator["15"]["BorderSizePixel"] = 0
				Separator["15"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
				Separator["15"]["Size"] = UDim2.new(1, 0, 0, 60)
				Separator["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Separator["15"]["Name"] = [[TabSeparator]]
				Separator["15"]["BackgroundTransparency"] = 1

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.TabSeparator.Frame
				Separator["16"] = Instance.new("Frame", Separator["15"])
				Separator["16"]["BorderSizePixel"] = 0
				Separator["16"]["BackgroundColor3"] =	ThemesColors[Chosen_Theme]["Dividers-BG"]
				Separator["16"]["AnchorPoint"] = Vector2.new(0.5, 1)
				Separator["16"]["Size"] = UDim2.new(1, -12, 0, 1)
				Separator["16"]["Position"] = UDim2.new(0.5, 6, 1, 0)
				Separator["16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.TabSeparator.TextLabel
				Separator["17"] = Instance.new("TextLabel", Separator["15"])
				Separator["17"]["BorderSizePixel"] = 0
				Separator["17"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Separator["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
				Separator["17"]["TextSize"] = 18
				Separator["17"]["FontFace"] =Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
				Separator["17"]["TextColor3"] = ThemesColors[Chosen_Theme]["PrimaryText-BG"]
				Separator["17"]["BackgroundTransparency"] = 1
				Separator["17"]["Size"] = UDim2.new(0, 200, 0, 20)
				Separator["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Separator["17"]["Text"] = options.Name
				Separator["17"]["Position"] = UDim2.new(0, 0, 0, 8)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.TabSeparator.TextLabel
				Separator["18"] = Instance.new("TextLabel", Separator["15"])
				Separator["18"]["BorderSizePixel"] = 0
				Separator["18"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Separator["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
				Separator["18"]["TextSize"] = 14
				Separator["18"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
				Separator["18"]["TextColor3"] = ThemesColors[Chosen_Theme]["SecondaryText-BG"]
				Separator["18"]["BackgroundTransparency"] = 1
				Separator["18"]["Size"] = UDim2.new(0, 400, 0, 20)
				Separator["18"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Separator["18"]["Text"] = options.Description
				Separator["18"]["Position"] = UDim2.new(0, 0, 0, 28)
			end
			do
				function Separator:SetName(name)
					options.Name = name
					Separator["17"]["Text"] = options.Name
				end
				function Separator:SetDescription(description)
					options.Description = description
					Separator["18"]["Text"] = options.Description
				end
			end
			return Separator
		end
		function Tab:Slider(options)
			local options = options or {}
			ElementalUI:Validate(
				{
					Name = "Slider",
					Callback = function(v)
						return v
					end,
					Min = 0,
					Max = 100,
					Default = 50,
					Speed = .15
				},
				options
			)
			local Slider = {Completed = false, Value = options.Default, Hovered = false}

			do
				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider
				Slider["1a"] = Instance.new("Frame", Tab["14"])
				Slider["1a"]["BorderSizePixel"] = 0
				Slider["1a"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				Slider["1a"]["Size"] = UDim2.new(1, 0, 0, 50)
				Slider["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Slider["1a"]["Name"] = [[Slider]]

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.UICorner
				Slider["1b"] = Instance.new("UICorner", Slider["1a"])
				Slider["1b"]["CornerRadius"] = UDim.new(0, 3)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.TitleLabel
				Slider["1c"] = Instance.new("TextLabel", Slider["1a"])
				Slider["1c"]["BorderSizePixel"] = 0
				Slider["1c"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Slider["1c"]["BackgroundColor3"] = Color3.fromRGB(48, 48, 48)
				Slider["1c"]["TextSize"] = 15
				Slider["1c"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				Slider["1c"]["TextColor3"] = ThemesColors[Chosen_Theme]["SecondaryText-BG"]
				Slider["1c"]["BackgroundTransparency"] = 1
				Slider["1c"]["Size"] = UDim2.new(1, -220, 0, 50)
				Slider["1c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Slider["1c"]["Text"] = options.Name
				Slider["1c"]["Name"] = [[TitleLabel]]

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.TitleLabel.UIPadding
				Slider["1d"] = Instance.new("UIPadding", Slider["1c"])
				Slider["1d"]["PaddingLeft"] = UDim.new(0, 12)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.ClickRange
				Slider["1e"] = Instance.new("TextButton", Slider["1a"])
				Slider["1e"]["Active"] = false
				Slider["1e"]["BorderSizePixel"] = 0
				Slider["1e"]["BackgroundColor3"] = Color3.fromRGB(30, 39, 43)
				Slider["1e"]["BackgroundTransparency"] = 1
				Slider["1e"]["Selectable"] = false
				Slider["1e"]["AnchorPoint"] = Vector2.new(1, 0.5)
				Slider["1e"]["Size"] = UDim2.new(0, 150, 0, 25)
				Slider["1e"]["BackgroundTransparency"] = 1
				Slider["1e"]["Name"] = [[ClickRange]]
				Slider["1e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Slider["1e"]["Text"] = [[]]
				Slider["1e"]["Position"] = UDim2.new(1, -12, 0.5, 0)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.SliderBackground
				Slider["1f"] = Instance.new("TextButton", Slider["1a"])
				Slider["1f"]["Active"] = false
				Slider["1f"]["BorderSizePixel"] = 0
				Slider["1f"]["BackgroundColor3"] = Chosen_Theme == "Light" and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(34, 34, 34)  
				Slider["1f"]["Selectable"] = false
				Slider["1f"]["AnchorPoint"] = Vector2.new(1, 0.5)
				Slider["1f"]["Size"] = UDim2.new(0, 150, 0, 4)
				Slider["1f"]["Name"] = [[SliderBackground]]
				Slider["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Slider["1f"]["Text"] = [[]]
				Slider["1f"]["Position"] = UDim2.new(1, -12, 0.5, 0)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.SliderBackground.Draggable
				Slider["20"] = Instance.new("Frame", Slider["1f"])
				Slider["20"]["BorderSizePixel"] = 0
				Slider["20"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["PrimaryText-BG"]
				Slider["20"]["Size"] = UDim2.new(0.75, 0, 1, 0)
				Slider["20"]["Position"] = UDim2.new(0, 0, 0, 0)
				Slider["20"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Slider["20"]["Name"] = [[Draggable]]

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.SliderBackground.Draggable.UICorner
				Slider["21"] = Instance.new("UICorner", Slider["20"])
				Slider["21"]["CornerRadius"] = UDim.new(0, 6)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.SliderBackground.Draggable.Tick
				Slider["22"] = Instance.new("TextLabel", Slider["20"])
				Slider["22"]["BorderSizePixel"] = 0
				Slider["22"]["BackgroundColor3"] = Color3.fromRGB(236, 236, 236)
				Slider["22"]["TextSize"] = 6
				Slider["22"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
				Slider["22"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
				Slider["22"]["Size"] = UDim2.new(0, 12, 0, 12)
				Slider["22"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Slider["22"]["Text"] = [[|]]
				Slider["22"]["Name"] = [[Tick]]
				Slider["22"]["Position"] = UDim2.new(1, 0, 0, 1)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.SliderBackground.Draggable.Tick.UICorner
				Slider["23"] = Instance.new("UICorner", Slider["22"])
				Slider["23"]["CornerRadius"] = UDim.new(1, 0)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.SliderBackground.UICorner
				Slider["24"] = Instance.new("UICorner", Slider["1f"])
				Slider["24"]["CornerRadius"] = UDim.new(0, 6)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Slider.TextLabel
				Slider["25"] = Instance.new("TextLabel", Slider["1a"])
				Slider["25"]["BorderSizePixel"] = 0
				Slider["25"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55)
				Slider["25"]["TextSize"] = 14
				Slider["25"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				Slider["25"]["TextColor3"] = Color3.fromRGB(153, 156, 161)
				Slider["25"]["BackgroundTransparency"] = 1
				Slider["25"]["AnchorPoint"] = Vector2.new(1, 0.5)
				Slider["25"]["Size"] = UDim2.new(0, 50, 0, 25)
				Slider["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Slider["25"]["Text"] = options.Default
				Slider["25"]["Position"] = UDim2.new(1, -160, 0.5, 0)
			end

			do
				function Slider:GetValue()
					return Slider.Value
				end
				function Slider:SetCallback(func)
					options.Callback = func
				end
				function Slider:SetName(name)
					options.Name = name
					Slider["1c"]["Text"] = options.Name
				end
				function Slider:SetValue(value)
					if value >= options.Min and value <= options.Max then
						local clamp = math.clamp(value, options.Min, options.Max)
						local slider_calculate = (clamp - options.Min) / (options.Max - options.Min)
						Slider["25"]["Text"] = math.round(value)
						Slider.Value = math.round(value)
						ElementalUI:Tween(
							Slider["20"],
							{tonumber(options.Speed), "Linear", "InOut"},
							{Size = UDim2.fromScale(slider_calculate, Slider["20"]["Size"]["Y"]["Scale"])}
						)
						return value
					else
						Slider:SetValue(options.Max)
					end
					options.Callback(Slider.Value)
				end
			end
			do
				Slider["1e"].MouseEnter:Connect(
					function()
						Slider.Hovered = true
					end
				)
				Slider["1e"].MouseLeave:Connect(
					function()
						Slider.Hovered = false
					end
				)
				Slider["1e"].MouseButton1Down:Connect(
					function()
						Slider.Completed = false
						ElementalUI:tween(Slider["1c"], {TextColor3 = ThemesColors[Chosen_Theme]["PrimaryText-BG"]})
						repeat
							task.wait()
							local slider_calculate =
								math.clamp(
									(game:GetService("Players").LocalPlayer:GetMouse().X - Slider["1f"].AbsolutePosition.X) /
									Slider["1f"].AbsoluteSize.X,
									0,
									1
								)
							Slider.Value = math.round((options.Max - options.Min) * slider_calculate + options.Min)
							Slider["25"]["Text"] = math.round(Slider.Value)
							ElementalUI:Tween(
								Slider["20"],
								{tonumber(options.Speed), "Linear", "InOut"},
								{Size = UDim2.fromScale(slider_calculate, Slider["20"]["Size"]["Y"]["Scale"])}
							)
						until Slider.Completed or Slider.Hovered == false
						options.Callback(tonumber(Slider.Value))
						ElementalUI:tween(Slider["1c"], {TextColor3 = ThemesColors[Chosen_Theme]["SecondaryText-BG"]})
					end
				)
			end
			Slider:SetValue(options.Default)
			return Slider
		end
		function Tab:Button(options)
			local options = options or {}
			ElementalUI:Validate(
				{
					Name = "Button",
					Callback = function()
					end,
					Icon = [[rbxassetid://10734898355]]
				},
				options
			)

			local Button = {}

			do
				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Button
				Button["26"] = Instance.new("TextButton", Tab["14"])
				Button["26"]["Active"] = false
				Button["26"]["BorderSizePixel"] = 0
				Button["26"]["AutoButtonColor"] = false
				Button["26"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				Button["26"]["Selectable"] = false
				Button["26"]["Size"] = UDim2.new(1, 0, 0, 50)
				Button["26"]["Name"] = options.Name
				Button["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Button["26"]["Text"] = [[]]
				Button["26"]["Position"] = UDim2.new(0, 0, 0, 0)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Button.UICorner
				Button["27"] = Instance.new("UICorner", Button["26"])
				Button["27"]["CornerRadius"] = UDim.new(0, 3)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Button.TitleLabel
				Button["28"] = Instance.new("TextLabel", Button["26"])
				Button["28"]["BorderSizePixel"] = 0
				Button["28"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Button["28"]["BackgroundColor3"] = Color3.fromRGB(48, 48, 48)
				Button["28"]["TextSize"] = 15
				Button["28"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				Button["28"]["TextColor3"] = ThemesColors[Chosen_Theme]["SecondaryText-BG"]
				Button["28"]["BackgroundTransparency"] = 1
				Button["28"]["Size"] = UDim2.new(1, -49, 0, 50)
				Button["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Button["28"]["Text"] = options.Name
				Button["28"]["Name"] = [[TitleLabel]]

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Button.TitleLabel.UIPadding
				Button["29"] = Instance.new("UIPadding", Button["28"])
				Button["29"]["PaddingLeft"] = UDim.new(0, 12)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Button.TextLabel
				Button["2a"] = Instance.new("ImageLabel", Button["26"])
				Button["2a"]["BorderSizePixel"] = 0
				Button["2a"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55)
				Button["2a"]["ImageColor3"] = Color3.fromRGB(126, 126, 126)
				Button["2a"]["AnchorPoint"] = Vector2.new(1, 0)
				Button["2a"]["Image"] = options.Icon
				Button["2a"]["Size"] = UDim2.new(0, 25, 0, 25)
				Button["2a"]["BorderColor3"] = ThemesColors[Chosen_Theme]["Icons-BG"]
				Button["2a"]["BackgroundTransparency"] = 1
				Button["2a"]["Name"] = [[ButonIcon]]
				Button["2a"]["Position"] = UDim2.new(1, -12, 0, 14)
			end
			do
				function Button:SetText(text)
					options.Name = text
					Button["28"]["Text"] = options.Name
				end
				function Button:SetIcon(icon)
					options.Icon = icon
					Button["2a"]["Image"] = options.Icon
				end
				function Button:SetCallback(func)
					options.Callback = func
				end
			end
			do
				Button["26"].MouseButton1Click:Connect(
					function()
						ElementalUI:tween(Button["28"], {TextColor3 = ThemesColors[Chosen_Theme]["PrimaryText-BG"]})
						options.Callback()
						wait(.2)
						ElementalUI:tween(Button["28"], {TextColor3 = ThemesColors[Chosen_Theme]["SecondaryText-BG"]})
					end
				)
			end
			return Button
		end
		function Tab:Label(options)
			local options = options or {}
			ElementalUI:Validate(
				{
					Name = "Elemental Hub on top, starving artists is a flop."
				},
				options
			)

			local Label = {}
			do
				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Label
				Label["42"] = Instance.new("Frame", Tab["14"])
				Label["42"]["BorderSizePixel"] = 0
				Label["42"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				Label["42"]["Size"] = UDim2.new(1, 0, 0, 50)
				Label["42"]["Position"] = UDim2.new(0, 0, 0.05176, 0)
				Label["42"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Label["42"]["Name"] = options.Name

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Label.UICorner
				Label["43"] = Instance.new("UICorner", Label["42"])
				Label["43"]["CornerRadius"] = UDim.new(0, 3)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Label.TitleLabel
				Label["44"] = Instance.new("TextLabel", Label["42"])
				Label["44"]["TextWrapped"] = true
				Label["44"]["BorderSizePixel"] = 0
				Label["44"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Label["44"]["BackgroundColor3"] = Color3.fromRGB(48, 48, 48)
				Label["44"]["TextSize"] = 15
				Label["44"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				Label["44"]["TextColor3"] = ThemesColors[Chosen_Theme]["SecondaryText-BG"]
				Label["44"]["BackgroundTransparency"] = 1
				Label["44"]["Size"] = UDim2.new(1, 0, 0, 50)
				Label["44"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Label["44"]["Text"] = options.Name
				Label["44"]["Name"] = [[TitleLabel]]

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Label.TitleLabel.UIPadding
				Label["45"] = Instance.new("UIPadding", Label["44"])
				Label["45"]["PaddingLeft"] = UDim.new(0, 12)
			end
			do
				function Label:SetName(name)
					options.Name = name
					Label["42"]["Name"] = options.Name
				end
			end
			return Label
		end
		function Tab:Textbox(options)
			local options = options or {}
			ElementalUI:Validate(
				{
					Text = "",
					Callback = function(txt)
						return txt
					end,
					ClearOnFocus = false,
					ClearOnEnter = true,
					PlaceholderText = "hello",
					Finished = true
				},
				options
			)

			local Textbox = {}
			do
				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Label
				Textbox["42"] = Instance.new("Frame", Tab["14"])
				Textbox["42"]["BorderSizePixel"] = 0
				Textbox["42"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				Textbox["42"]["Size"] = UDim2.new(1, 0, 0, 50)
				Textbox["42"]["Position"] = UDim2.new(0, 0, 0.05176, 0)
				Textbox["42"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Textbox["42"]["Name"] = options.Text

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Label.UICorner
				Textbox["43"] = Instance.new("UICorner", Textbox["42"])
				Textbox["43"]["CornerRadius"] = UDim.new(0, 3)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Label.TitleLabel
				Textbox["44"] = Instance.new("TextBox", Textbox["42"])
				Textbox["44"]["TextWrapped"] = true
				Textbox["44"]["BorderSizePixel"] = 0
				Textbox["44"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Textbox["44"]["BackgroundColor3"] = Color3.fromRGB(48, 48, 48)
				Textbox["44"]["TextSize"] = 15
				Textbox["44"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				Textbox["44"]["TextColor3"] = ThemesColors[Chosen_Theme]["SecondaryText-BG"]
				Textbox["44"]["BackgroundTransparency"] = 1
				Textbox["44"]["Size"] = UDim2.new(1, 0, 0, 50)
				Textbox["44"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Textbox["44"]["Text"] = options.Text
				Textbox["44"]["PlaceholderText"] = options.PlaceholderText
				Textbox["44"]["ClearTextOnFocus"] = options.ClearOnFocus
				Textbox["44"]["Name"] = [[TitleLabel]]

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Label.TitleLabel.UIPadding
				Textbox["45"] = Instance.new("UIPadding", Textbox["44"])
				Textbox["45"]["PaddingLeft"] = UDim.new(0, 12)
			end
			do
				function Textbox:SetText(text)
					options.Text = text
					Textbox["44"]["Text"] = text
					return text
				end
				function Textbox:GetValue()
					return Textbox["44"]["Text"]
				end
				if game:GetService("UserInputService").TouchEnabled and not uis.MouseEnabled then
					Textbox["44"].InputBegan:Connect(
						function()
							Textbox["44"]:CaptureFocus()
						end
					)
				end
				local NOFIRE = false;
				Textbox["44"].FocusLost:Connect(
					function(a)
						if not a then return end
						task.spawn(options.Callback, Textbox["44"]["Text"])
						if options.ClearOnEnter then NOFIRE = true Textbox["44"].Text = "" NOFIRE = false end
					end
				)
				Textbox["44"].Changed:Connect(function(Property)
					if Property == "Text" and not options.Finished and not NOFIRE then
						task.spawn(options.Callback, Textbox["44"]["Text"])
					end
				end)
			end
			return Textbox
		end
		function Tab:Toggle(options)
			local options = options or {}
			ElementalUI:Validate(
				{
					Name = "Toggle",
					Callback = function(v)
						return v
					end,
					Default = false
				},
				options
			)
			local Toggle = {
				Toggled = false
			}
			do
				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Checkbox
				Toggle["46"] = Instance.new("Frame", Tab["14"])
				Toggle["46"]["BorderSizePixel"] = 0
				Toggle["46"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				Toggle["46"]["Size"] = UDim2.new(1, 0, 0, 50)
				Toggle["46"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Toggle["46"]["Name"] = [[Checkbox]]

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Checkbox.UICorner
				Toggle["47"] = Instance.new("UICorner", Toggle["46"])
				Toggle["47"]["CornerRadius"] = UDim.new(0, 3)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Checkbox.TextLabel
				Toggle["48"] = Instance.new("TextLabel", Toggle["46"])
				Toggle["48"]["BorderSizePixel"] = 0
				Toggle["48"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Toggle["48"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				Toggle["48"]["TextSize"] = 15
				Toggle["48"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				Toggle["48"]["TextColor3"] =	ThemesColors[Chosen_Theme]["SecondaryText-BG"] --- 4,4,4
				Toggle["48"]["Size"] = UDim2.new(1, -43, 0, 50)
				Toggle["48"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Toggle["48"]["Text"] = options.Name

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Checkbox.TextLabel.UIPadding
				Toggle["49"] = Instance.new("UIPadding", Toggle["48"])
				Toggle["49"]["PaddingLeft"] = UDim.new(0, 12)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Checkbox.Check
				Toggle["4a"] = Instance.new("TextButton", Toggle["46"])
				Toggle["4a"]["BorderSizePixel"] = 0
				Toggle["4a"]["BackgroundColor3"] = Chosen_Theme == "Light" and Color3.fromRGB(175, 178, 183) or ThemesColors[Chosen_Theme]["Hover-BG"] --- 4,4,4
				Toggle["4a"]["AnchorPoint"] = Vector2.new(1, 0.5)
				Toggle["4a"]["Size"] = UDim2.new(0, 25, 0, 25)
				Toggle["4a"]["Name"] = [[Check]]
				Toggle["4a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Toggle["4a"]["Text"] = [[]]
				Toggle["4a"]["Position"] = UDim2.new(1, -12, 0.5, 0)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Checkbox.Check.ImageLabel
				Toggle["4b"] = Instance.new("ImageLabel", Toggle["4a"])
				Toggle["4b"]["BorderSizePixel"] = 0
				Toggle["4b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
				Toggle["4b"]["ImageColor3"] = Chosen_Theme == "Light" and Color3.fromRGB(224, 224, 224) or Color3.fromRGB(0, 119, 190)
				Toggle["4b"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
				Toggle["4b"]["Image"] = [[rbxassetid://10709790644]]
				Toggle["4b"]["ImageTransparency"] = 1
				Toggle["4b"]["Size"] = UDim2.new(0.6, 0, 0.6, 0)
				Toggle["4b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Toggle["4b"]["BackgroundTransparency"] = 1
				Toggle["4b"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Checkbox.Check.UICorner
				Toggle["4c"] = Instance.new("UICorner", Toggle["4a"])
				Toggle["4c"]["CornerRadius"] = UDim.new(0, 3)
			end
			do
				function Toggle:Set(value)
					Toggle.Toggled = value
					if Chosen_Theme == "Light" then
						if Toggle.Toggled or Toggle.Toggled == "true" then
							ElementalUI:tween(Toggle["48"], {TextColor3 = Color3.fromRGB(4, 4, 4)})
							ElementalUI:tween(Toggle["4a"], {BackgroundColor3 = Color3.fromRGB(4, 4, 4)})
							ElementalUI:tween(Toggle["4b"], {ImageTransparency = 0})
						else
							ElementalUI:tween(Toggle["48"], {TextColor3 = Color3.fromRGB(175, 178, 183)})
							ElementalUI:tween(Toggle["4a"], {BackgroundColor3 = Color3.fromRGB(175, 178, 183)})
							ElementalUI:tween(Toggle["4b"], {ImageTransparency = 1})
						end
					else
						if Toggle.Toggled or Toggle.Toggled == "true" then
							ElementalUI:tween(Toggle["48"], {TextColor3 = ThemesColors[Chosen_Theme]["PrimaryText-BG"]})
							ElementalUI:tween(Toggle["4a"], {BackgroundColor3 = ThemesColors[Chosen_Theme]["Hover-BG"]})
							ElementalUI:tween(Toggle["4b"], {ImageTransparency = 0})
						else
							ElementalUI:tween(Toggle["48"], {TextColor3 =	ThemesColors[Chosen_Theme]["SecondaryText-BG"]})
							ElementalUI:tween(Toggle["4a"], {BackgroundColor3 = ThemesColors[Chosen_Theme]["Hover-BG"]})
							ElementalUI:tween(Toggle["4b"], {ImageTransparency = 1})
						end
					end
					options.Callback(value)
				end

				function Toggle:GetValue()
					return Toggle.Toggled
				end
			end
			do
				Toggle["4a"].MouseButton1Click:Connect(
					function()
						Toggle.Toggled = not Toggle.Toggled
						Toggle:Set(Toggle.Toggled)
					end
				)
				Toggle:Set(options.Default)
			end
			return Toggle
		end
		function Tab:Dropdown(option)
			local options = option or {}
			ElementalUI:Validate(
				{
					Name = "Dropdown",
					Value = {"1", "2", "3"},
					Callback = function(v)
						return v
					end,
					OpenIcon = [[rbxassetid://10709791523]],
					CloseIcon = [[rbxassetid://10709790948]]
				},
				options
			)
			local Dropdown = {
				Status = false
			}
			do
				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown
				Dropdown["4d"] = Instance.new("TextButton", Tab["14"])
				Dropdown["4d"]["Active"] = false
				Dropdown["4d"]["BorderSizePixel"] = 0
				Dropdown["4d"]["AutoButtonColor"] = false
				Dropdown["4d"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				Dropdown["4d"]["Selectable"] = false
				Dropdown["4d"]["Size"] = UDim2.new(1, 0, 0, 50)
				Dropdown["4d"]["Name"] = [[Dropdown]]
				Dropdown["4d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Dropdown["4d"]["Text"] = [[]]
				Dropdown["4d"]["Position"] = UDim2.new(0, 0, 0.46118, 0)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.UICorner
				Dropdown["4e"] = Instance.new("UICorner", Dropdown["4d"])
				Dropdown["4e"]["CornerRadius"] = UDim.new(0, 3)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.TitleLabel
				Dropdown["4f"] = Instance.new("TextLabel", Dropdown["4d"])
				Dropdown["4f"]["BorderSizePixel"] = 0
				Dropdown["4f"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Dropdown["4f"]["BackgroundColor3"] = Color3.fromRGB(48, 48, 48)
				Dropdown["4f"]["TextSize"] = 15
				Dropdown["4f"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				Dropdown["4f"]["TextColor3"] = ThemesColors[Chosen_Theme]["SecondaryText-BG"]
				Dropdown["4f"]["BackgroundTransparency"] = 1
				Dropdown["4f"]["Size"] = UDim2.new(1, -249, 0, 50)
				Dropdown["4f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Dropdown["4f"]["Text"] = options.Name
				Dropdown["4f"]["Name"] = [[TitleLabel]]

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.TitleLabel.UIPadding
				Dropdown["50"] = Instance.new("UIPadding", Dropdown["4f"])
				Dropdown["50"]["PaddingLeft"] = UDim.new(0, 12)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.TextLabel
				Dropdown["51"] = Instance.new("TextLabel", Dropdown["4d"])
				Dropdown["51"]["BorderSizePixel"] = 0
				Dropdown["51"]["TextXAlignment"] = Enum.TextXAlignment.Right
				Dropdown["51"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55)
				Dropdown["51"]["TextSize"] = 14
				Dropdown["51"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				Dropdown["51"]["TextColor3"] = ThemesColors[Chosen_Theme]["SecondaryText-BG"]
				Dropdown["51"]["BackgroundTransparency"] = 1
				Dropdown["51"]["AnchorPoint"] = Vector2.new(1, 0)
				Dropdown["51"]["Size"] = UDim2.new(0, 200, 0, 25)
				Dropdown["51"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Dropdown["51"]["Text"] = [[Option]]
				Dropdown["51"]["Position"] = UDim2.new(1, -43, 0, 14)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.TextLabel
				Dropdown["52"] = Instance.new("ImageLabel", Dropdown["4d"])
				Dropdown["52"]["BorderSizePixel"] = 0
				Dropdown["52"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55)
				Dropdown["52"]["ImageColor3"] = Color3.fromRGB(126, 126, 126)
				Dropdown["52"]["AnchorPoint"] = Vector2.new(1, 0)
				Dropdown["52"]["Image"] = [[rbxassetid://10709790948]]
				Dropdown["52"]["Size"] = UDim2.new(0, 25, 0, 25)
				Dropdown["52"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Dropdown["52"]["BackgroundTransparency"] = 1
				Dropdown["52"]["Name"] = [[TextLabel]]
				Dropdown["52"]["Position"] = UDim2.new(1, -12, 0, 14)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.OptionsHolder
				Dropdown["53"] = Instance.new("ScrollingFrame", Dropdown["4d"])
				Dropdown["53"]["Visible"] = false
				Dropdown["53"]["BorderSizePixel"] = 0
				Dropdown["53"]["CanvasSize"] = UDim2.new(0, 0, 0, 97)
				Dropdown["53"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				Dropdown["53"]["Name"] = [[OptionsHolder]]
				Dropdown["53"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
				Dropdown["53"]["Size"] = UDim2.new(1, -8, 1, -62)
				Dropdown["53"]["ScrollBarImageColor3"] = Color3.fromRGB(202, 202, 202)
				Dropdown["53"]["Position"] = UDim2.new(0, 4, 0, 56)
				Dropdown["53"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				Dropdown["53"]["ScrollBarThickness"] = 0

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.OptionsHolder.UIListLayout
				Dropdown["54"] = Instance.new("UIListLayout", Dropdown["53"])
				Dropdown["54"]["Padding"] = UDim.new(0, 4)
				Dropdown["54"]["SortOrder"] = Enum.SortOrder.LayoutOrder
			end
			do
				function Dropdown:Refresh(new)
					if type(new) ~= "table" then
						new = {"One", "Two", "Three"}
					end
					if #new < 1 then
						new = {"One", "Two", "Three"}
					end
					for i, v in next, (Dropdown["53"]:GetChildren()) do
						if v:IsA("TextButton") then
							v:Destroy()
						end
					end

					for i = 1, #new do
						local Option_Button = {}
						-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.OptionsHolder.Button
						Option_Button["55"] = Instance.new("TextButton", Dropdown["53"])
						Option_Button["55"]["Active"] = false
						Option_Button["55"]["BorderSizePixel"] = 0
						Option_Button["55"]["AutoButtonColor"] = false
						Option_Button["55"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
						Option_Button["55"]["Selectable"] = false
						Option_Button["55"]["Size"] = UDim2.new(1, 0, 0, 50)
						Option_Button["55"]["Name"] = [[Button]]
						Option_Button["55"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
						Option_Button["55"]["Text"] = [[]]
						Option_Button["55"]["Position"] = UDim2.new(0, 0, 0.05176, 0)

						-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.OptionsHolder.Button.UICorner
						Option_Button["56"] = Instance.new("UICorner", Option_Button["55"])
						Option_Button["56"]["CornerRadius"] = UDim.new(0, 3)

						-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.OptionsHolder.Button.TitleLabel
						Option_Button["57"] = Instance.new("TextLabel", Option_Button["55"])
						Option_Button["57"]["BorderSizePixel"] = 0
						Option_Button["57"]["TextXAlignment"] = Enum.TextXAlignment.Left
						Option_Button["57"]["BackgroundColor3"] = Color3.fromRGB(48, 48, 48)
						Option_Button["57"]["TextSize"] = 15
						Option_Button["57"]["FontFace"] =
							Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
						Option_Button["57"]["TextColor3"] = ThemesColors[Chosen_Theme]["SecondaryText-BG"]
						Option_Button["57"]["BackgroundTransparency"] = 1
						Option_Button["57"]["Size"] = UDim2.new(1, -49, 0, 50)
						Option_Button["57"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
						Option_Button["57"]["Text"] = tostring(new[i])
						Option_Button["57"]["Name"] = [[TitleLabel]]

						-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.OptionsHolder.Button.TitleLabel.UIPadding
						Option_Button["58"] = Instance.new("UIPadding", Option_Button["57"])
						Option_Button["58"]["PaddingLeft"] = UDim.new(0, 12)

						-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.OptionsHolder.Button.TextLabel
						Option_Button["59"] = Instance.new("ImageLabel", Option_Button["55"])
						Option_Button["59"]["BorderSizePixel"] = 0
						Option_Button["59"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55)
						Option_Button["59"]["ImageColor3"] = Color3.fromRGB(126, 126, 126)
						Option_Button["59"]["AnchorPoint"] = Vector2.new(1, 0)
						Option_Button["59"]["Image"] = [[rbxassetid://10734898355]]
						Option_Button["59"]["Size"] = UDim2.new(0, 25, 0, 25)
						Option_Button["59"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
						Option_Button["59"]["BackgroundTransparency"] = 1
						Option_Button["59"]["Name"] = [[TextLabel]]
						Option_Button["59"]["Position"] = UDim2.new(1, -12, 0, 14)

						Option_Button["55"].MouseButton1Up:Connect(
							function()
								Dropdown["51"]["Text"] = tostring(new[i])
								options.Callback(tostring(new[i]))
							end
						)
					end
					local count = 0
					for k, v in next, (Dropdown["53"]:GetChildren()) do
						if v:IsA("TextButton") then
							count = count + v.Size.Y.Scale
						end
					end
					Dropdown["53"]["CanvasSize"] = UDim2.new(0, 0, count, 0)
					options.Options = new
				end
				function Dropdown:Set(value)
					Dropdown["51"]["Text"] = tostring(value)
					options.Callback(tostring(value))
				end
				local function tablelength(T)
					local count = 0
					for _ in next, (T) do
						count = count + 1
					end
					return count
				end

				Dropdown["4d"].MouseButton1Up:Connect(
					function()
						if not Dropdown.Status then
							Dropdown.Status = true
							local Tween_Done = false
							local btns = tablelength(options.Value)
							local size = 6 + (50 * btns) + 6
							ElementalUI:Tween(
								Dropdown["4d"],
								{.3, "Linear", "InOut"},
								{Size = UDim2.new(1, 0, 0, size)},
								function()
									Tween_Done = true
								end
							)
							repeat
								wait()
							until Tween_Done
							Dropdown["52"]["Image"] = options.OpenIcon
							Dropdown["53"]["Visible"] = true
							Dropdown:Refresh(options.Options)
						else
							Dropdown.Status = false
							local Tween_Done = false
							ElementalUI:Tween(
								Dropdown["4d"],
								{.3, "Linear", "InOut"},
								{Size = UDim2.new(1, 0, 0, 50)},
								function()
									Tween_Done = true
								end
							)
							repeat
								wait()
							until Tween_Done
							Dropdown["52"]["Image"] = options.CloseIcon
							Dropdown["53"]["Visible"] = false
						end
					end
				)
			end
			return Dropdown
		end
		function Tab:FrameDisplay(options)
			local options = options or {}
			local Return = {}
			ElementalUI:Validate(
				{
					Name = "Display your ass here",
					Frame = nil,
					OpenIcon = [[rbxassetid://10709791523]],
					CloseIcon = [[rbxassetid://10709790948]]
				},
				options
			)
			if options.Frame == nil then
				return "Kill yourself"
			end
			local FrameDisplayer = {Status = false}

			do
				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.FrameDisplayer
				FrameDisplayer["69"] = Instance.new("TextButton", Tab["14"])
				FrameDisplayer["69"]["BorderSizePixel"] = 0
				FrameDisplayer["69"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				FrameDisplayer["69"]["Size"] = UDim2.new(1, 0, 0, 50)
				FrameDisplayer["69"]["Position"] = UDim2.new(0, 0, 0, 0)
				FrameDisplayer["69"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				FrameDisplayer["69"]["Name"] = [[FrameDisplayer]]
				FrameDisplayer["69"]["Text"] = [[]]
				FrameDisplayer["69"]["AutoButtonColor"] = false

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.FrameDisplayer.UICorner
				FrameDisplayer["6a"] = Instance.new("UICorner", FrameDisplayer["69"])
				FrameDisplayer["6a"]["CornerRadius"] = UDim.new(0, 3)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.FrameDisplayer.TextLabel
				FrameDisplayer["6b"] = Instance.new("TextLabel", FrameDisplayer["69"])
				FrameDisplayer["6b"]["BorderSizePixel"] = 0
				FrameDisplayer["6b"]["TextXAlignment"] = Enum.TextXAlignment.Left
				FrameDisplayer["6b"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				FrameDisplayer["6b"]["TextSize"] = 15
				FrameDisplayer["6b"]["FontFace"] =
					Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				FrameDisplayer["6b"]["TextColor3"] = ThemesColors[Chosen_Theme]["SecondaryText-BG"]
				FrameDisplayer["6b"]["Size"] = UDim2.new(1, 0, 0, 50)
				FrameDisplayer["6b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				FrameDisplayer["6b"]["Text"] = options.Name

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.Dropdown.OptionsHolder
				FrameDisplayer["53"] = Instance.new("Frame", FrameDisplayer["69"])
				FrameDisplayer["53"]["Visible"] = false
				FrameDisplayer["53"]["BorderSizePixel"] = 0
				FrameDisplayer["53"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				FrameDisplayer["53"]["Name"] = [[OptionsHolder]]
				FrameDisplayer["53"]["Size"] = UDim2.new(1, -8, 1, -62)
				FrameDisplayer["53"]["Position"] = UDim2.new(0, 4, 0, 56)
				FrameDisplayer["53"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.FrameDisplayer.TextLabel.UIPadding
				FrameDisplayer["6c"] = Instance.new("UIPadding", FrameDisplayer["6b"])
				FrameDisplayer["6c"]["PaddingLeft"] = UDim.new(0, 12)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.FrameDisplayer.Frame
				FrameDisplayer["6d"] = options.Frame:Clone()
				FrameDisplayer["6d"]["Parent"] = FrameDisplayer["53"]
				if
					options.Frame.Size.Y.Scale == 0 or
					options.Frame.Size.X.Scale == 0 and not (options.Frame.Size.X.Offset <= 437)
				then
					FrameDisplayer["6d"]["Size"] =
						UDim2.new(0, options.Frame.Size.X.Offset, 0, options.Frame.Size.Y.Offset)
				else
					return "An error occured: Frame has a Scale size or XOffset is > to 200"
				end
				FrameDisplayer["6d"]["Visible"] = true
				FrameDisplayer["6d"]["BorderSizePixel"] = 0
				FrameDisplayer["6d"]["BackgroundColor3"] = ThemesColors[Chosen_Theme]["Second-BG"]
				FrameDisplayer["6d"]["AnchorPoint"] = Vector2.new(0.5, 0)
				FrameDisplayer["6d"]["Position"] = UDim2.new(0.5, 0, 0, 0)
				FrameDisplayer["6d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				for k, v in next, (FrameDisplayer["6d"]:GetChildren()) do
					if v:IsA("UIStroke") or v:IsA("UICorner") then
						v:Destroy()
					end
				end
				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.FrameDisplayer.Frame.UIStroke
				FrameDisplayer["6e"] = Instance.new("UIStroke", FrameDisplayer["6d"])
				FrameDisplayer["6e"]["Color"] = Color3.fromRGB(231, 231, 233)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.FrameDisplayer.Frame.UICorner
				FrameDisplayer["6f"] = Instance.new("UICorner", FrameDisplayer["6d"])
				FrameDisplayer["6f"]["CornerRadius"] = UDim.new(0, 3)

				-- StarterGui.Personal.Elemental/Hub.Monarch.Frame.TabsHolder.Tab_Name.FrameDisplayer.Check
				FrameDisplayer["70"] = Instance.new("ImageButton", FrameDisplayer["69"])
				FrameDisplayer["70"]["BorderSizePixel"] = 0
				FrameDisplayer["70"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
				FrameDisplayer["70"]["ImageColor3"] = Color3.fromRGB(120, 120, 120)
				FrameDisplayer["70"]["AnchorPoint"] = Vector2.new(1, 0)
				FrameDisplayer["70"]["Image"] = [[rbxassetid://10709791523]]
				FrameDisplayer["70"]["Size"] = UDim2.new(0, 25, 0, 25)
				FrameDisplayer["70"]["BackgroundTransparency"] = 1
				FrameDisplayer["70"]["Name"] = [[Check]]
				FrameDisplayer["70"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
				FrameDisplayer["70"]["Position"] = UDim2.new(1, -12, 0, 14)
			end
			do
				FrameDisplayer["69"].MouseButton1Up:Connect(
					function()
						if not FrameDisplayer.Status then
							FrameDisplayer.Status = true
							local Tween_Done = false
							ElementalUI:Tween(
								FrameDisplayer["69"],
								{.3, "Linear", "InOut"},
								{Size = UDim2.new(1, 0, 0, 50 + options.Frame.Size.Y.Offset + 12)},
								function()
									Tween_Done = true
								end
							)
							repeat
								wait()
							until Tween_Done
							FrameDisplayer["70"]["Image"] = options.OpenIcon
							FrameDisplayer["53"]["Visible"] = true
							local count = 0

							for k, v in next, (InternalGUI["9"]:GetChildren()) do
								if v:IsA("TextButton") or v:IsA("Frame") then
									count = count + v.Size.Y.Scale
								end
							end
							InternalGUI["9"]["CanvasSize"] = UDim2.new(0, 0, 0, count)
						else
							FrameDisplayer.Status = false
							local Tween_Done = false
							FrameDisplayer["53"]["Visible"] = false
							ElementalUI:Tween(
								FrameDisplayer["69"],
								{.3, "Linear", "InOut"},
								{Size = UDim2.new(1, 0, 0, 50)},
								function()
									Tween_Done = true
								end
							)
							repeat
								wait()
							until Tween_Done
							FrameDisplayer["70"]["Image"] = options.CloseIcon
							local count = 0

							for k, v in next, (InternalGUI["9"]:GetChildren()) do
								if v:IsA("TextButton") or v:IsA("Frame") then
									count = count + v.Size.Y.Scale
								end
							end
							InternalGUI["9"]["CanvasSize"] = UDim2.new(0, 0, 0, count)
						end
					end
				)
				function Return:Remove()
					FrameDisplayer["6d"]:Destroy()
					FrameDisplayer["69"]:Destroy()
				end
				function Return:Connect(Event, Func)
					FrameDisplayer["6d"][Event]:Connect(Func)
				end
				Return.Frame = FrameDisplayer["6d"]
			end
			return Return
		end
		return Tab
	end
	local count = 0

	for k, v in next, (InternalGUI["9"]:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("Frame") then
			count = count + v.Size.Y.Scale
		end
	end
	InternalGUI["9"]["CanvasSize"] = UDim2.new(0, 0, 0, count)
	InternalGUI:MakeDraggable(InternalGUI["2"])
	return InternalGUI
end

return ElementalUI