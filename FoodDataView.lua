local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
local widget = require ("widget")
local utils = require ("utils")

local foodNameTitle = nil
local sceneGroupReference = nil

function string:split( inSplitPattern, outResults )
 
   if not outResults then
      outResults = {}
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

local function buttonBackHandler()
    composer.gotoScene( "LookUpView")
end

local function buttonAddToMyFoodsHandler()
    
end

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
    print ('FoodDataView - create')
	local sceneGroup = self.view
    sceneGroupReference = sceneGroup
	
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
    
    local foodName = tostring(event.params.response.report.food.name)
    foodNameTitle = display.newText( foodName, display.contentCenterX, 50, native.systemFont, 24 )
    foodNameTitle:setFillColor( 0 )	-- black 
    
    local buttonLookup = widget.newButton{label="Back",x = display.contentWidth/3-30, y = title.y + 350, onRelease=buttonBackHandler}

    local buttonAddToMyFoods = widget.newButton{label="Add to My Foods",x = (2 * display.contentWidth)/3, y = title.y + 350, onRelease=buttonAddToMyFoodsHandler}
    
	
	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
    sceneGroup:insert( title )
    sceneGroup:insert( buttonLookup )
    sceneGroup:insert( buttonAddToMyFoods )
    sceneGroup:insert( displayTable )
    sceneGroup:insert( foodNameTitle )    
    
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
    print ('FoodDataView  - show')
    
    --utils.print_r (event.params.response.report.food.nutrients)
    itemList = event.params.response.report.food.nutrients
    
    utils.print_r ( event.params.response.report.food.name )
    
	local sceneGroup = self.view
	local phase = event.phase
	print ( "phase" )
    print ( phase )
    
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

        utils.print_r ( foodName )
        foodNameTitle:removeSelf()
        foodNameTitle = nil
        local foodName = tostring(event.params.response.report.food.name)  
        
        --local titleTable = string.split(foodName,",")
        local titleTable = foodName:split(",")
        
        displayTitle = titleTable[1] .. " : " .. titleTable[2]

        
        foodNameTitle = display.newText(displayTitle, display.contentCenterX, 50, native.systemFont, 16 )
        
        foodNameTitle:setFillColor( 0 )	-- black  
        
        sceneGroupReference:insert( foodNameTitle )
        
        --foodNameTitle.text("test")
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
    print ('FoodDataView  - hide')
    
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
    print ('FoodDataView - destroy')
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

---------------------------------------------------------------------------------
return scene