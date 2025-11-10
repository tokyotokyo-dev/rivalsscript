        return function(dependencies)
            local player = dependencies.player
            if not player then
                error("GUI: В dependencies отсутствует player (nil). Проверьте скрипт-загрузчик или executer.")
            end
            local uis = dependencies.uis
            local camera = dependencies.camera
            local setUnloadScript = dependencies.setUnloadScript
            local saveConfig = dependencies.saveConfig
            local updateESP = dependencies.updateESP
            local updateChams = dependencies.updateChams
            local Color3_new = dependencies.Color3_new
            local Color3_fromRGB = dependencies.Color3_fromRGB
            local TweenService = dependencies.TweenService

            local getEspEnabled = dependencies.getEspEnabled
            local setEspEnabled = dependencies.setEspEnabled
            local getEspShowHealth = dependencies.getEspShowHealth
            local setEspShowHealth = dependencies.setEspShowHealth
            local getEspShowAmmo = dependencies.getEspShowAmmo
            local setEspShowAmmo = dependencies.setEspShowAmmo
            local getEspShowWeapon = dependencies.getEspShowWeapon
            local setEspShowWeapon = dependencies.setEspShowWeapon
            local getEspShowSkeleton = dependencies.getEspShowSkeleton
            local setEspShowSkeleton = dependencies.setEspShowSkeleton
            local getEspBoxColor = dependencies.getEspBoxColor
            local setEspBoxColor = dependencies.setEspBoxColor
            local getBoxEspEnabled = dependencies.getBoxEspEnabled
            local setBoxEspEnabled = dependencies.setBoxEspEnabled

            local getChamsEnabled = dependencies.getChamsEnabled
            local setChamsEnabled = dependencies.setChamsEnabled
            local getChamsPrimaryColor = dependencies.getChamsPrimaryColor
            local setChamsPrimaryColor = dependencies.setChamsPrimaryColor
            local getChamsFillTransparency = dependencies.getChamsFillTransparency
            local setChamsFillTransparency = dependencies.setChamsFillTransparency
            local getChamsOutlineTransparency = dependencies.getChamsOutlineTransparency
            local setChamsOutlineTransparency = dependencies.setChamsOutlineTransparency

            local getAimEnabled = dependencies.getAimEnabled
            local setAimEnabled = dependencies.setAimEnabled
            local getAimFov = dependencies.getAimFov
            local setAimFov = dependencies.setAimFov
            local getAimSmoothness = dependencies.getAimSmoothness
            local setAimSmoothness = dependencies.setAimSmoothness
            local getAimTarget = dependencies.getAimTarget
            local setAimTarget = dependencies.setAimTarget
            local getAimKeyInfo = dependencies.getAimKeyInfo
            local setAimKeyBinding = dependencies.setAimKey

            local currentlyDraggingSlider = nil

            print("GUI Load: Creating ScreenGui...")
            local successGui, gui = pcall(Instance.new, "ScreenGui")
            if not successGui or not gui then
                warn("GUI Load: Failed to create ScreenGui.", gui)
                return { mainGui = nil, toggleGuiVisibility = function() end } -- Return dummy table
            end
            gui.Name = "SaintHubRIvals"
            gui.ResetOnSpawn = false

            print("GUI Load: Waiting for PlayerGui...")
            local playerGui = player:WaitForChild("PlayerGui")
            if not playerGui then
                warn("GUI Load: 'PlayerGui' is nil when trying to set gui.Parent in gui.lua.")
                return { mainGui = gui, toggleGuiVisibility = function() end } -- Return dummy table to prevent further errors
            end
            gui.Parent = playerGui
            print("GUI Load: ScreenGui parented to PlayerGui.")

            print("GUI Load: Creating mainFrame...")
            local successMainFrame, mainFrame = pcall(Instance.new, "Frame", gui)
            if not successMainFrame or not mainFrame then
                warn("GUI Load: Failed to create mainFrame.", mainFrame)
                return { mainGui = gui, toggleGuiVisibility = function() end } -- Return dummy table
            end
            mainFrame.Size = UDim2.new(0, 720, 0, 420)
            mainFrame.Position = UDim2.new(0.5, -360, 0.5, -210)
            mainFrame.BackgroundColor3 = Color3_fromRGB(18, 18, 18)
            mainFrame.BorderSizePixel = 0
            mainFrame.Visible = false
            Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

            local function attachTitleBar(frame)
                local bar = Instance.new("Frame", frame)
                bar.Size = UDim2.new(1, 0, 0, 56)
                bar.BackgroundColor3 = Color3_fromRGB(30, 30, 30)
                bar.BorderSizePixel = 0
                Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 12)

                local label = Instance.new("TextLabel", bar)
                label.Size = UDim2.new(1, -140, 1, 0)
                label.Position = UDim2.new(0, 20, 0, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamBold
                label.TextSize = 22
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextColor3 = Color3_fromRGB(255, 255, 255)
                label.Text = "SaintHubRIvals"

                local closeButton = Instance.new("TextButton", bar)
                closeButton.Size = UDim2.new(0, 32, 0, 32)
                closeButton.Position = UDim2.new(1, -44, 0.5, -16)
                closeButton.BackgroundColor3 = Color3_fromRGB(60, 60, 60)
                closeButton.TextColor3 = Color3_fromRGB(255, 255, 255)
                closeButton.Text = "✕"
                closeButton.Font = Enum.Font.GothamBold
                closeButton.TextSize = 16
                closeButton.AutoButtonColor = false
                Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)
                closeButton.MouseButton1Click:Connect(function()
                    frame.Visible = false
                end)

                local dragRegion = Instance.new("TextButton", bar)
                dragRegion.Size = UDim2.new(1, -90, 1, 0)
                dragRegion.BackgroundTransparency = 1
                dragRegion.AutoButtonColor = false
                dragRegion.Text = ""

                local dragging = false
                local dragStart = Vector2.new()
                local dragOrigin = frame.Position

                dragRegion.MouseButton1Down:Connect(function()
                    dragging = true
                dragStart = uis:GetMouseLocation()
                    dragOrigin = frame.Position
            end)

            uis.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local delta = uis:GetMouseLocation() - dragStart
                        frame.Position = UDim2.new(dragOrigin.X.Scale, dragOrigin.X.Offset + delta.X, dragOrigin.Y.Scale, dragOrigin.Y.Offset + delta.Y)
                end
            end)

            uis.InputEnded:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                        dragging = false
                    end
                end)
            end

            attachTitleBar(mainFrame)

            local navFrame = Instance.new("Frame", mainFrame)
            navFrame.Size = UDim2.new(0, 210, 1, -70)
            navFrame.Position = UDim2.new(0, 0, 0, 64)
            navFrame.BackgroundColor3 = Color3_fromRGB(25, 25, 25)
            navFrame.BorderSizePixel = 0
            navFrame.ZIndex = 2
            Instance.new("UICorner", navFrame).CornerRadius = UDim.new(0, 12)

            local navLayout = Instance.new("UIListLayout", navFrame)
            navLayout.Padding = UDim.new(0, 8)
            navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            navLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local fovCircle = Instance.new("Frame", gui)
            fovCircle.Size = UDim2.new(0, getAimFov() * 2, 0, getAimFov() * 2)
            fovCircle.Position = UDim2.new(0.5, -getAimFov(), 0.5, -getAimFov())
            fovCircle.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
            fovCircle.BackgroundTransparency = 0.8
            fovCircle.BorderSizePixel = 0
            fovCircle.ZIndex = 0
            fovCircle.Visible = getAimEnabled()
            Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)

            local function updateFov()
                local fov = getAimFov()
                fovCircle.Size = UDim2.new(0, fov * 2, 0, fov * 2)
                fovCircle.Position = UDim2.new(0.5, -fov, 0.5, -fov)
                fovCircle.Visible = getAimEnabled()
            end

            local contentFrames = {}

            local function createContentFrame()
                local frame = Instance.new("ScrollingFrame", mainFrame)
                frame.ZIndex = 1
                frame.Visible = false
                frame.Size = UDim2.new(1, -220, 1, -72)
                frame.Position = UDim2.new(0, 220, 0, 64)
                frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
                frame.CanvasSize = UDim2.new(0, 0, 0, 0)
                frame.BackgroundTransparency = 1
                frame.BorderSizePixel = 0
                frame.ScrollBarThickness = 6

                local layout = Instance.new("UIListLayout", frame)
                layout.Padding = UDim.new(0, 10)
                layout.FillDirection = Enum.FillDirection.Vertical
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                layout.SortOrder = Enum.SortOrder.LayoutOrder

                return frame
            end

            local function createTabButton(tabName, index)
                local button = Instance.new("TextButton", navFrame)
                button.Name = tabName
                button.Size = UDim2.new(1, -24, 0, 44)
                button.Position = UDim2.new(0, 12, 0, 12 + (index - 1) * 48)
                button.BackgroundColor3 = Color3_fromRGB(35, 35, 35)
                button.TextColor3 = Color3_fromRGB(255, 255, 255)
                button.Text = tabName
                button.Font = Enum.Font.GothamSemibold
                button.TextSize = 16
                button.AutoButtonColor = false
                Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
                button.MouseButton1Click:Connect(function()
                    switchTo(tabName)
                end)
            end

            local function switchTo(tabName)
                for name, frame in pairs(contentFrames) do
                    frame.Visible = (name == tabName)
                end
                for _, button in ipairs(navFrame:GetChildren()) do
                    if button:IsA("TextButton") then
                        local toActive = (button.Name == tabName)
                        local targetColor = toActive and Color3_fromRGB(75, 75, 75) or Color3_fromRGB(35, 35, 35)
                        local success, err = pcall(function()
                            if TweenService then
                                TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                    BackgroundColor3 = targetColor
                                }):Play()
                            else
                                warn("[GUI] TweenService is nil in switchTo function.")
                            end
                        end)
                        if not success then
                            warn("[GUI] TweenService error in switchTo: ", err)
                        end
                    end
                end
                if tabName == "ESP" then
                    if updateESP then
                        pcall(updateESP)
                    else
                        warn("[GUI] updateESP is nil!")
                    end
                elseif tabName == "Chams" then
                    if updateChams then
                        pcall(updateChams)
                    else
                        warn("[GUI] updateChams is nil!")
                    end
                end
            end

            local function component(color, channel)
                if not color then return 0 end
                if channel == "r" then
                    return color.R or 0
                elseif channel == "g" then
                    return color.G or 0
                else
                    return color.B or 0
                end
            end

            local function addHeader(parent, text)
                local label = Instance.new("TextLabel", parent)
                label.Size = UDim2.new(1, -30, 0, 28)
                label.BackgroundColor3 = Color3_fromRGB(35, 35, 35)
                label.TextColor3 = Color3_fromRGB(255, 255, 255)
                label.Text = text
                label.Font = Enum.Font.GothamSemibold
                label.TextSize = 16
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.AutomaticSize = Enum.AutomaticSize.Y
                label.LayoutOrder = parent:GetChildren() and (#parent:GetChildren() + 1) or 1
                Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)
                return label
            end

            local function addToggle(parent, text, getter, setter, onChange)
                local frame = Instance.new("Frame", parent)
                frame.Size = UDim2.new(1, -30, 0, 28)
                frame.BackgroundTransparency = 1
                frame.LayoutOrder = parent:GetChildren() and (#parent:GetChildren() + 1) or 1

                local label = Instance.new("TextLabel", frame)
                label.Size = UDim2.new(1, -70, 1, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.Text = text
                label.TextColor3 = Color3_fromRGB(220, 220, 220)
                label.TextXAlignment = Enum.TextXAlignment.Left

                local track = Instance.new("Frame", frame)
                track.Size = UDim2.new(0, 46, 0, 22)
                track.Position = UDim2.new(1, -46, 0, 3)
                track.BackgroundColor3 = Color3_fromRGB(80, 80, 80)
                track.BorderSizePixel = 0
                Instance.new("UICorner", track).CornerRadius = UDim.new(0, 11)

                local knob = Instance.new("TextButton", track)
                knob.Size = UDim2.new(0.5, 0, 1, 0)
                knob.Position = UDim2.new(0, 0, 0, 0)
                knob.BackgroundColor3 = Color3_fromRGB(200, 200, 200)
                knob.Text = ""
                knob.AutoButtonColor = false
                knob.BorderSizePixel = 0
                Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 11)

                local state = (getter and getter()) or false
                local function refresh()
                    if state then
                        track.BackgroundColor3 = Color3_fromRGB(0, 170, 0)
                        knob.Position = UDim2.new(0.5, 0, 0, 0)
                    else
                        track.BackgroundColor3 = Color3_fromRGB(80, 80, 80)
                        knob.Position = UDim2.new(0, 0, 0, 0)
                    end
                end
                refresh()

                knob.MouseButton1Click:Connect(function()
                    state = not state
                    refresh()
                    if setter then setter(state) end
                    if onChange then pcall(onChange) end
                    saveConfig()
                end)
            end

            local function addSlider(parent, labelText, value, minValue, maxValue, onValueChanged)
                local container = Instance.new("Frame", parent)
                container.Size = UDim2.new(1, -30, 0, 54)
                container.BackgroundTransparency = 1

                local label = Instance.new("TextLabel", container)
                label.Size = UDim2.new(1, 0, 0, 20)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextColor3 = Color3_fromRGB(220, 220, 220)
                label.Text = string.format(labelText, value)

                local track = Instance.new("Frame", container)
                track.Size = UDim2.new(1, -20, 0, 10)
                track.Position = UDim2.new(0, 0, 0, 30)
                track.BackgroundColor3 = Color3_fromRGB(70, 70, 70)
                track.BorderSizePixel = 0
                Instance.new("UICorner", track).CornerRadius = UDim.new(0, 5)

                local knob = Instance.new("TextButton", track)
                knob.Size = UDim2.new(0, 12, 0, 12)
                knob.BackgroundColor3 = Color3_fromRGB(220, 220, 220)
                knob.BorderSizePixel = 0
                knob.AutoButtonColor = false
                knob.Text = ""
                Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 6)

                local slider = {
                    Label = label,
                    Track = track,
                    Knob = knob,
                    Min = minValue,
                    Max = maxValue,
                    Format = labelText,
                    Callback = onValueChanged,
                }

                function slider:Update(newValue, skipCallback)
                    newValue = math.clamp(newValue, self.Min, self.Max)
                    local fraction = (newValue - self.Min) / (self.Max - self.Min)
                    self.Knob.Position = UDim2.new(fraction, -6, -0.1, 0)
                    self.Label.Text = string.format(self.Format, newValue)
                    if not skipCallback then
                        self.Callback(newValue)
                    end
                end
                
                function slider:Drag(mousePos)
                    local relative = math.clamp(mousePos.X - self.Track.AbsolutePosition.X, 0, self.Track.AbsoluteSize.X)
                    local fraction = relative / self.Track.AbsoluteSize.X
                    local newValue = self.Min + (self.Max - self.Min) * fraction
                    self:Update(newValue, false)
                end

                knob.MouseButton1Down:Connect(function()
                    currentlyDraggingSlider = slider
                end)

                slider:Update(value, true)
                return container
            end

            local function addColorSlider(parent, labelPrefix, getter, setter, channel, previewCallback, onUpdated)
                local currentColor = getter()
                local value = math.clamp(component(currentColor, channel) * 255, 0, 255)
                local slider = addSlider(parent, labelPrefix .. "%.0f", value, 0, 255, function(v)
                    local color = getter()
                    local r, g, b = color.R, color.G, color.B
                    if channel == "r" then
                        r = v / 255
                    elseif channel == "g" then
                        g = v / 255
                    else
                        b = v / 255
                    end
                    setter(Color3_new(r, g, b))
                    if previewCallback then previewCallback() end
                    if onUpdated then onUpdated() end
                    saveConfig()
                end)
                return slider
            end

            local function createColorPalette(parent, initialColor, onColorSelected)
                local container = Instance.new("Frame", parent)
                container.Size = UDim2.new(1, -30, 0, 40)
                container.BackgroundTransparency = 1
                container.LayoutOrder = (#parent:GetChildren()) + 1

                -- Ensure initialColor is not nil
                if not initialColor then
                    initialColor = Color3.new(1, 1, 1) -- Default to white if nil
                end

                local palette = Instance.new("Frame", container)
                palette.Size = UDim2.new(1, 0, 0, 28)
                palette.Position = UDim2.new(0, 0, 0, 4)
                palette.BackgroundTransparency = 0
                palette.BackgroundColor3 = Color3.new(1, 1, 1) -- This will be covered by the gradient
                palette.BorderSizePixel = 0

                local hueGradient = Instance.new("UIGradient")
                hueGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.0, Color3.fromHSV(0, 1, 1)),       -- Red
                    ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),  -- Yellow
                    ColorSequenceKeypoint.new(1 / 3, Color3.fromHSV(1 / 3, 1, 1)),  -- Green
                    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),      -- Cyan
                    ColorSequenceKeypoint.new(2 / 3, Color3.fromHSV(2 / 3, 1, 1)),  -- Blue
                    ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),  -- Magenta
                    ColorSequenceKeypoint.new(1.0, Color3.fromHSV(1, 1, 1))         -- Red (wrap-around)
                })
                hueGradient.Rotation = 0
                hueGradient.Parent = palette

                local paletteOutline = Instance.new("UIStroke")
                paletteOutline.Thickness = 1
                paletteOutline.Color = Color3_fromRGB(90, 90, 90)
                paletteOutline.Transparency = 0.2
                paletteOutline.Parent = palette

                local grabber = Instance.new("Frame", palette)
                grabber.Size = UDim2.new(0, 10, 0, 10)
                grabber.AnchorPoint = Vector2.new(0.5, 0.5)
                grabber.BorderSizePixel = 0
                grabber.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
                Instance.new("UICorner", grabber).CornerRadius = UDim.new(1, 0)

                local function applyHue(hue, shouldNotify)
                    hue = math.clamp(hue or 0, 0, 1)
                    local color = Color3.fromHSV(hue, 1, 1)
                    grabber.Position = UDim2.new(hue, 0, 0.5, 0)
                    if shouldNotify and onColorSelected then
                        onColorSelected(color)
                    end
                end

                local function updateFromPosition(x)
                    local relative = palette.AbsolutePosition
                    local size = palette.AbsoluteSize
                    local width = math.max(size.X, 1)
                    local hue = math.clamp((x - relative.X) / width, 0, 1)
                    applyHue(hue, true)
                end

                palette.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        updateFromPosition(input.Position.X)
                    end
                end)

                palette.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            updateFromPosition(input.Position.X)
                        end
                    elseif input.UserInputType == Enum.UserInputType.Touch then
                        updateFromPosition(input.Position.X)
                    end
                end)

                task.defer(function()
                    local initialHue = select(1, initialColor:ToHSV())
                    applyHue(initialHue, false)
                end)

                return container
            end

            local function buildAimbotTab(frame)
                addHeader(frame, "Aimbot")
                addToggle(frame, "Aimbot Enabled", getAimEnabled, setAimEnabled, updateFov)
                addSlider(frame, "FOV: %.0f", getAimFov(), 10, 300, function(v)
                    setAimFov(v)
                    updateFov()
                    saveConfig()
                end)
                addSlider(frame, "Smoothness: %.2f", getAimSmoothness(), 0.05, 0.99, function(v)
                    setAimSmoothness(v)
                    saveConfig()
                end)

                local targetButton = Instance.new("TextButton", frame)
                targetButton.Size = UDim2.new(0, 210, 0, 34)
                targetButton.BackgroundColor3 = Color3_fromRGB(70, 70, 70)
                targetButton.TextColor3 = Color3_fromRGB(255, 255, 255)
                targetButton.Font = Enum.Font.GothamSemibold
                targetButton.TextSize = 14
                targetButton.Text = "Target: " .. getAimTarget()
                targetButton.AutoButtonColor = false
                Instance.new("UICorner", targetButton).CornerRadius = UDim.new(0, 8)
                targetButton.MouseButton1Click:Connect(function()
                    local nextTarget = getAimTarget() == "Head" and "Chest" or "Head"
                    setAimTarget(nextTarget)
                    targetButton.Text = "Target: " .. nextTarget
                saveConfig()
            end)
            end

            local function buildEspTab(frame)
                addHeader(frame, "ESP")
                addToggle(frame, "ESP Enabled", getEspEnabled, setEspEnabled, function(state)
                    if state then
                        if getChamsEnabled() then
                            setChamsEnabled(false)
                            pcall(updateChams)
                        end
                    end
                    pcall(updateESP)
                    saveConfig()
                end)
                addToggle(frame, "Box ESP", getBoxEspEnabled, setBoxEspEnabled, updateESP)
                addToggle(frame, "Show Health", getEspShowHealth, setEspShowHealth, updateESP)
                addToggle(frame, "Show Ammo", getEspShowAmmo, setEspShowAmmo, updateESP)
                addToggle(frame, "Show Weapon", getEspShowWeapon, setEspShowWeapon, updateESP)
                addToggle(frame, "Show Skeleton", getEspShowSkeleton, setEspShowSkeleton, updateESP)

                addHeader(frame, "Box Color")
                local preview = Instance.new("Frame", frame)
                preview.Size = UDim2.new(0, 40, 0, 20)
                preview.BackgroundColor3 = getEspBoxColor()
                preview.BorderSizePixel = 0
                Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)

                local function refresh()
                    preview.BackgroundColor3 = getEspBoxColor()
                end

                addColorSlider(frame, "R: ", getEspBoxColor, setEspBoxColor, "r", refresh, updateESP)
                addColorSlider(frame, "G: ", getEspBoxColor, setEspBoxColor, "g", refresh, updateESP)
                addColorSlider(frame, "B: ", getEspBoxColor, setEspBoxColor, "b", refresh, updateESP)
            end

            local function paletteSection(frame, title, getter, setter)
                addHeader(frame, title)
                local previewContainer = Instance.new("Frame", frame)
                previewContainer.Size = UDim2.new(1, -30, 0, 20)
                previewContainer.BackgroundTransparency = 1

                local preview = Instance.new("Frame", previewContainer)
                preview.Size = UDim2.new(0, 42, 0, 20)
                preview.BackgroundColor3 = getter()
                preview.BorderSizePixel = 0
                Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)

                local function refreshPreview()
                    preview.BackgroundColor3 = getter()
                end

                createColorPalette(frame, getter(), function(color)
                    setter(color)
                    refreshPreview()
                    pcall(updateChams)
                    saveConfig()
                end)
            end

            local function buildChamsTab(frame)
                addHeader(frame, "Chams")
                addToggle(frame, "Chams Enabled", getChamsEnabled, setChamsEnabled, function(state)
                    if state then
                        if getEspEnabled() then
                            setEspEnabled(false)
                            pcall(updateESP)
                        end
                    end
                    pcall(updateChams)
                    saveConfig()
                end)

                paletteSection(frame, "Chams Color", getChamsPrimaryColor, setChamsPrimaryColor)
                addSlider(frame, "Fill Transparency: %.0f%%", getChamsFillTransparency() * 100, 0, 100, function(v)
                    setChamsFillTransparency(v / 100)
                    pcall(updateChams)
                    saveConfig()
                end)
                addSlider(frame, "Outline Transparency: %.0f%%", getChamsOutlineTransparency() * 100, 0, 100, function(v)
                    setChamsOutlineTransparency(v / 100)
                    pcall(updateChams)
                    saveConfig()
                end)
            end

            local function buildConfigTab(frame)
                addHeader(frame, "Actions")

                local refreshButton = Instance.new("TextButton", frame)
                refreshButton.Size = UDim2.new(0, 220, 0, 36)
                refreshButton.BackgroundColor3 = Color3_fromRGB(75, 75, 75)
                refreshButton.TextColor3 = Color3_fromRGB(255, 255, 255)
                refreshButton.Font = Enum.Font.GothamSemibold
                refreshButton.TextSize = 14
                refreshButton.Text = "Refresh ESP/Chams"
                refreshButton.AutoButtonColor = false
                Instance.new("UICorner", refreshButton).CornerRadius = UDim.new(0, 8)
                refreshButton.MouseButton1Click:Connect(function()
                    updateESP()
                    updateChams()
                end)

                local unloadButton = Instance.new("TextButton", frame)
                unloadButton.Size = UDim2.new(0, 220, 0, 36)
                unloadButton.BackgroundColor3 = Color3_fromRGB(140, 50, 50)
                unloadButton.TextColor3 = Color3_fromRGB(255, 255, 255)
                unloadButton.Font = Enum.Font.GothamSemibold
                unloadButton.TextSize = 14
                unloadButton.Text = "Unload Script"
                unloadButton.AutoButtonColor = false
                Instance.new("UICorner", unloadButton).CornerRadius = UDim.new(0, 8)
                unloadButton.MouseButton1Click:Connect(function()
                    setUnloadScript(true)
                end)
            end

            local tabBuilders = {
                Aimbot = buildAimbotTab,
                ESP = buildEspTab,
                Chams = buildChamsTab,
                Config = buildConfigTab,
            }

            for index, tabName in ipairs({"Aimbot", "ESP", "Chams", "Config"}) do
                createTabButton(tabName, index)
                local contentFrame = createContentFrame()
                contentFrames[tabName] = contentFrame
                tabBuilders[tabName](contentFrame)
                -- Только Aimbot по умолчанию видим, остальные нет
                contentFrame.Visible = (tabName == "Aimbot")
            end

            switchTo("Aimbot")

            updateFov()

            uis.InputChanged:Connect(function(input)
                if currentlyDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    currentlyDraggingSlider:Drag(input.Position)
                end
            end)

            uis.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    currentlyDraggingSlider = nil
                end
            end)

            local function toggleGuiVisibility()
                mainFrame.Visible = not mainFrame.Visible
            end

            return {
                mainGui = gui,
                toggleGuiVisibility = toggleGuiVisibility,
            }
        end       