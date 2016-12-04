-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require "widget"
local rb_reader = require "rb-reader"

local barCodeText

local scene = composer.newScene()

display.setDefault( "background", 213/255,213/255,213/255 )

local newStepper

-- shows the reader on screen
local readerShowOptions = {
        x = display.contentCenterX,
        y = display.contentCenterY,
        width = display.contentWidth * 0.94,
        height = display.contentHeight * 0.5,
        --fill = { type="image", filename="bar.jpg" } -- this param is optional, being used here to fill where the camera will appear
    }
 
-- showing an image instead of camera when running on Simulator
--if system.getInfo("environment") == "simulator" then readerShowOptions.fill={ type="image", filename="bar.jpg" }; end 

local function afterRead(event)
    -- return event.result (boolean), event.code (string)
    
    print("Read result=", event.result)
    print("Code=", event.code) 

    if event.result then
        barCodeText.text= "BAR CODE FOUND = " .. event.code 
    else
        barCodeText.text= "BAR NOT FOUND"
    end  

end

local function buttonReadHandler()    
    
    barCodeText.text= "READING"
    
    -- read the bar code on screen
    rb_reader.read{
                    onComplete=afterRead
                }
end

local originalGuideWidth

-- widget that allows you to set a new width for the reader line
local function sliderListener( event )
    
    -- update reader line width
    local newReaderWidth = originalGuideWidth + (event.value-50)*5
    rb_reader:setReaderWidth(newReaderWidth)
            
    return true
end

-- Called when the scene's view does not exist.
function scene:create( event )
	local sceneGroup = self.view

	-- create a white background to fill screen    
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 1 )	-- white
	
    local horizontalSlider = widget.newSlider{
        left = display.contentCenterX,
        top = (display.contentHeight) - 120,
        width = 150,
        listener = sliderListener,
    }

    local buttonRead = widget.newButton{label="READ",x = display.contentWidth/2, y = horizontalSlider.y + 30, onRelease=buttonReadHandler}
    
    rb_reader.show(readerShowOptions,sceneGroup)
    originalGuideWidth = rb_reader:getReaderWidth()

    horizontalSlider.x = display.contentCenterX
        
    barCodeText = display.newText{text="BAR CODE READER SAMPLE\nClick on READ to read the bar code", font=native.systemFontBold, width=display.contentWidth, align="center"}
    barCodeText.x = display.contentCenterX
    barCodeText.y = display.screenOriginY + 130
    barCodeText:setFillColor(0,0,0)

	-- add objects to the group
	sceneGroup:insert( background )
    sceneGroup:insert( rb_reader.readerLine )
    sceneGroup:insert( rb_reader.cameraShape )
    sceneGroup:insert( horizontalSlider )
    sceneGroup:insert( buttonRead )
    sceneGroup:insert( barCodeText )
    
end

function scene:show( event )
    print ('view 2  - show')
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
    print ('view 2  - hide')
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
    print ('view 2  - destroy')
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
