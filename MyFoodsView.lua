-----------------------------------------------------------------------------------------
--
-- MyFoodsView.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local json = require( "json" )
local widget = require ("widget")
local utils = require ("utils")


local scene = composer.newScene()

function scene:create( event )
    print ('My Foods View- create')
	local sceneGroup = self.view

	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 213/255,213/255,213/255 )	-- white

	local title = display.newText( "My Foods", display.contentCenterX, 20, native.systemFont, 24 )
	title:setFillColor( 0 )	-- black

	sceneGroup:insert( background )
	sceneGroup:insert( title )

end

function scene:show( event )
    print ('view 1  - show')
	local sceneGroup = self.view
	local phase = event.phase
	print ( "phase" )
    print ( phase )
    
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
        display.remove(lookUpBox)
        lookUpBox = nil

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