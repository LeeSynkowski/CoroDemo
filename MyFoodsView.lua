-----------------------------------------------------------------------------------------
--
-- MyFoodsView.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local json = require( "json" )
local widget = require ("widget")
local utils = require ("utils")
local path = system.pathForFile( "MyFoods.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

-- Handle the "applicationExit" event to close the database
local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then              
        db:close()
    end
end



local scene = composer.newScene()

local function onRowRender( event )
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
    if  (event.phase == "press") and (not event.isError ) then

        local checkForItemQuery = [[SELECT * FROM myFoods WHERE name =']]..event.row.params.rowTitle..[[';]]
     
        local nutrients = nil

        for r in db:nrows( checkForItemQuery ) do
            nutrients = r.nutrients
        end
        
        local splitNutrients = utils.split ( nutrients, "; " )     
        
        local options = {}
        
        options.params = {}
        options.params.nutrients = splitNutrients
        options.params.name = event.row.params.rowTitle

        utils.print_r ( splitNutrients )
        composer.gotoScene( "MyFoodsDataView" , options)
        
    end
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
    print ('My Foods View - create')
	local sceneGroup = self.view

	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 213/255,213/255,213/255 )	-- white

	local title = display.newText( "My Foods", display.contentCenterX, 20, native.systemFont, 24 )
	title:setFillColor( 0 )	-- black

	sceneGroup:insert( background )
	sceneGroup:insert( title )
    sceneGroup:insert( displayTable )

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
            --For each row in the DB, add it to the display table
        displayTable:deleteAllRows()
        local getAllRowsQuery = [[SELECT * FROM myFoods ORDER BY name]]

        for row in db:nrows( getAllRowsQuery) do
             displayTable:insertRow {
                    params = {
                        rowTitle = row.name
                    }
                }
        end
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