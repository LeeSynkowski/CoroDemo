local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
local widget = require ("widget")
local utils = require ("utils")

local function onRowRender( event )
    print('--------------------called row render')
    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local message = event.row.params.rowTitle
    
    local rowTitle = display.newText( row, message , 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )

    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 0
    rowTitle.y = rowHeight * 0.5   
    row:insert(rowTitle)
end

local function onRowTouch ( event )

end


local displayTable = widget.newTableView{
    left = 20,
    top = 70,
    height = 270,
    width = 280,
    onRowRender = onRowRender,
    onRowTouch = onRowTouch,
    listener = scrollListener
}

function scene:create( event )
    print ('view 3  - create')
	local sceneGroup = self.view
	
    --utils.print_r (event.params.response.report.food.nutrients)
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 213/255,213/255,213/255 )	-- red
	
	-- create some text
	local title = display.newText( "Nutrient Info", display.contentCenterX, 20, native.systemFont, 24 )
	title:setFillColor( 0 )	-- black
	
	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
    sceneGroup:insert( title )
    sceneGroup:insert( displayTable )
    
    itemList = event.params.response.report.food.nutrients
    
    utils.print_r ( itemList )
    for k, v in pairs(itemList) do
        displayTable:insertRow {
            params = {
                rowTitle = v.name..': '..v.value..' '..v.unit,
            }
        }
    end

    
end

function scene:show( event )
    print ('view 3  - show')
    
    --utils.print_r (event.params.response.report.food.nutrients)
    
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
    print ('view 3  - hide')
    
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
    print ('view 3  - destroy')
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