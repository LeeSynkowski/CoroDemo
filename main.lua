-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"


-- event listeners for tab buttons:
local function onFirstView( event )
    print('First View button press')
	composer.gotoScene( "view1" )
end

local function onSecondView( event )
    print('Second View button press')
	composer.gotoScene( "view2" )
end


-- create a tabBar widget with two buttons at the bottom of the screen

-- table to setup buttons
local tabButtons = {
	{ label="First", defaultFile="icon1.png", overFile="icon1-down.png", width = 32, height = 32, onPress=onFirstView, selected=true },
	{ label="Second", defaultFile="icon2.png", overFile="icon2-down.png", width = 32, height = 32, onPress=onSecondView },
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
	top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}
--------------------------------------------------END Original Main Section
--------------------------------------------------------------
-- Example of using Red Beach Reader Library to read bar code
-- 
-- Some features:
-- . Reads bar code using camera
-- . Can read several times at once to improve the 
-- . Obey to group behaviors, specially useful for use together with storyboard
--
-- Restrictions:
-- . Only reads UPC 12 digit bar code for now
--
--
--
-- How to use the lib
--  1) require the lib
--  2) call show function to show the reader (please see params on the sample code or inside the lib)
--  3) call read function to read the bar code on screen (please see params on the sample code or inside the lib)
--
--
-------------------------------------------------------

--[[
display.setDefault( "background", 244/255,223/255,151/255 )
local barCodeText
local newStepper


-- requiring the lib
local rb_reader = require "rb-reader"

-- shows the reader on screen
local readerShowOptions = {
        x = display.contentCenterX,
        y = display.contentCenterY,
        width = display.contentWidth * 0.94,
        height = display.contentHeight * 0.5,
        --fill = { type="image", filename="bar.jpg" } -- this param is optional, being used here to fill where the camera will appear
    }
    
--if system.getInfo("environment") == "simulator" then readerShowOptions.fill={ type="image", filename="bar.jpg" }; end -- showing an image instead of camera when running on Simulator
rb_reader.show(readerShowOptions)



-- onComplete listener.
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

local originalGuideWidth = rb_reader:getReaderWidth()

local function buttonReadHandler()    
    
    barCodeText.text= "READING"
    
    -- read the bar code on screen
    rb_reader.read{
                    readCount = newStepper:getValue(),
                    onComplete=afterRead
                }
end








-- title text
barCodeText = display.newText{text="BAR CODE READER SAMPLE\nClick on READ to read the bar code", font=native.systemFontBold, width=display.contentWidth, align="center"}
barCodeText.x = display.contentCenterX
barCodeText.y = display.screenOriginY + 30
barCodeText:setFillColor(0,0,0)



local widget = require "widget"

-- text showing the current width of the reader line
local readerWidthText = display.newText{text="Reader width = " .. originalGuideWidth}
readerWidthText:setFillColor(0,0,0)
readerWidthText.x = display.contentCenterX

-- widget that allows you to set a new width for the reader line
local function sliderListener( event )
    
    -- update reader line width
    local newReaderWidth = originalGuideWidth + (event.value-50)*5
    rb_reader:setReaderWidth(newReaderWidth)
    
    -- update text on screen
    readerWidthText.text = "Reader width = " .. newReaderWidth
    readerWidthText.x = display.contentCenterX
            
    return true
end
local horizontalSlider = widget.newSlider{
    left = display.contentCenterX,
    top = (display.contentHeight - display.screenOriginY) - 50,
    width = 150,
    listener = sliderListener,
}
horizontalSlider.x = display.contentCenterX
readerWidthText.y = horizontalSlider.y - 30


-- text showing the current number of reads (readCount)
local currentValue = display.newText{ text="#Read: 3"}
currentValue.anchorX = 0
currentValue.anchorY = 0
currentValue:setFillColor( 0 )

-- widget that allows you to set the number of reads (readCount) that will be made
local function stepperListener( event )
        currentValue.text = "#Read: " .. event.value
end
newStepper = widget.newStepper{
    left = 20,
    top = horizontalSlider.y,
    initialValue = 3,
    minimumValue = 1,
    maximumValue = 20,
    onPress = stepperListener,
}
newStepper.y = horizontalSlider.y        
currentValue.y = newStepper.contentBounds.yMin - 25
currentValue.x = newStepper.x - 30


-- button "READ"
local buttonRead = widget.newButton{label="READ",x = display.contentWidth  - 30, y = horizontalSlider.y, onRelease=buttonReadHandler}

]]





onFirstView()	-- invoke first tab button's onPress event manually

-- test change
