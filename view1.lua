-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
local widget = require "widget"

local function handleResponse( event )
    print( "Making web request" )
    if not event.isError then
        local response = json.decode( event.response )
        print( event.response )
    else
        print( "Error" )
    end
    return
end
 

 
local function buttonLookupHandler()
    print( "Handled button press" )
    network.request( "http://api.nal.usda.gov/ndb/reports/?ndbno=01009&type=b&format=json&api_key=SNDRhsmOk7iBqsoE3Z00wpvO6xWuT9YOEnvw8uF1", "GET", handleResponse )
    
end

function scene:create( event )
    print ('view 1  - create')
	local sceneGroup = self.view
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 1 )	-- white
	
	-- create some text
	local title = display.newText( "First View", display.contentCenterX, 125, native.systemFont, 32 )
	title:setFillColor( 0 )	-- black
	
    --[[	local newTextParams = { text = "Loaded by the first tab's\n\"onPress\" listener\nspecified in the 'tabButtons' table", 
						x = display.contentCenterX + 10, 
						y = title.y + 215, 
						width = 310, height = 310, 
						font = native.systemFont, fontSize = 14, 
						align = "center" }
	local summary = display.newText( newTextParams )
	summary:setFillColor( 0 ) -- black
    ]]
    
    
	local buttonLookup = widget.newButton{label="Look Up",x = display.contentCenterX + 10, y = title.y + 215, onRelease=buttonLookupHandler}
    
    
	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( title )
	sceneGroup:insert( buttonLookup )
end

function scene:show( event )
    print ('view 1  - show')
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
    print ('view 1  - hide')
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
    print ('view 1  - destroy')
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