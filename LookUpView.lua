-----------------------------------------------------------------------------------------
--
-- LookUpView.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
local widget = require ("widget")
local utils = require ("utils")


--store text to this field
local lookUpText

local itemList

local function textListener( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        lookUpText = event.target.text

    elseif ( event.phase == "editing" ) then
        lookUpText = event.text
    end
end

-- Create text field
local lookUpBox = native.newTextField( display.contentCenterX, 60, 280, 30 )
lookUpBox:addEventListener( "userInput", textListener )

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

local function handleDetailLookUp( event )
    local options = {}
    
    if not event.isError then
        local response = json.decode( event.response )
        options.params = {}
        options.params.response = response
    end
    
    composer.gotoScene( "FoodDataView" , options)
end

local function onRowTouch ( event )
    if  event.phase == "press" then
        print ( "Row ndbno:")
        local ndbno = event.row.params.ndbno 
        print (ndbno)
        network.request( "http://api.nal.usda.gov/ndb/reports/?ndbno="..ndbno.."&type=f&format=json&api_key=SNDRhsmOk7iBqsoE3Z00wpvO6xWuT9YOEnvw8uF1","GET", handleDetailLookUp )
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

local function handleResponse( event )
    local response = json.decode( event.response )
    if ((not event.isError) and (response.list ~= nil)) then
        
        print ("Response")
        utils.print_r (response)
        
        itemList = response.list.item
        
        for k, v in pairs(itemList) do
            local rowText = v.name
            
            local cleanText = rowText:gsub("'","") 
            
            displayTable:insertRow {
                params = {
                    rowTitle = cleanText,
                    ndbno = v.ndbno
                }
            }
        end

    else
        print( "Error" )
    end
    return
end

local function buttonLookupHandler()
    print( "Handled button press" )
    print(" Look up text ")
    print( lookUpText )
    displayTable:deleteAllRows()
    --food type by number
    --network.request( "http://api.nal.usda.gov/ndb/reports/?ndbno=01009&type=b&format=json&api_key=SNDRhsmOk7iBqsoE3Z00wpvO6xWuT9YOEnvw8uF1",
    --food list
    --network.request( "http://api.nal.usda.gov/ndb/list?format=json&lt=f&sort=n&api_key=SNDRhsmOk7iBqsoE3Z00wpvO6xWuT9YOEnvw8uF1", 
    --query by name
    if lookUpText ~= nil then
        network.request( "http://api.nal.usda.gov/ndb/search/?format=json&q="..lookUpText.."&sort=n&max=25&offset=0&api_key=SNDRhsmOk7iBqsoE3Z00wpvO6xWuT9YOEnvw8uF1",  
        "GET", handleResponse )
    end
    
end

function scene:create( event )
    print ('LookUpView  - create')
	local sceneGroup = self.view
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 213/255,213/255,213/255 )	-- white
	
	-- create some text
	local title = display.newText( "Find a Food...", display.contentCenterX, 20, native.systemFont, 24 )
	title:setFillColor( 0 )	-- black
	
    local buttonLookup = widget.newButton{label="Look Up",x = display.contentCenterX + 10, y = title.y + 350, onRelease=buttonLookupHandler}

	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( title )
	sceneGroup:insert( buttonLookup )
    sceneGroup:insert( displayTable )
    sceneGroup:insert( lookUpBox )   

end

function scene:show( event )
    print ('LookUpView  - show')
	local sceneGroup = self.view
	local phase = event.phase
	print ( "phase" )
    print ( phase )
    
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
        if lookUpBox == nil then
            lookUpBox = native.newTextField( display.contentCenterX, 60, 280, 30 )
            lookUpBox:addEventListener( "userInput", textListener )
        end
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
    print ('LookUpView  - hide')
    
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
    print ('LookUpView  - destroy')
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