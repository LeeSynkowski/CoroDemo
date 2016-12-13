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
local sqlite3 = require( "sqlite3" )
 
local path = system.pathForFile( "MyFoods.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

--Database Setup
local function setUpMyFoods() 
    local tablesetup = [[CREATE TABLE IF NOT EXISTS myFoods (id INTEGER PRIMARY KEY autoincrement, name, nutrients);]]
    db:exec( tablesetup )        
end

-- event listeners for tab buttons:
local function onLookUpView( event )
    print('First View button press')
	composer.gotoScene( "LookUpView" )
end

local function onScanView( event )
    print('Second View button press')
	composer.gotoScene( "ScanView" )
end

local function onMyFoodsView( event )
    print('My Foods button press')
	composer.gotoScene( "MyFoodsView" )
end

-- table to setup buttons
local tabButtons = {
	{ label="Look Up Foods", defaultFile="LookUpIcon.png", overFile="LookUpIconDown.png", width = 32, height = 32, onPress=onLookUpView, selected=true },
	{ label="Scan Barcode", defaultFile="BarCodeScanIcon.png", overFile="BarCodeScanIconDown.png", width = 32, height = 32, onPress=onScanView },
    { label="My Foods", defaultFile="MyFoodsIcon.png", overFile="MyFoodsIconDown.png", width = 32, height = 32, onPress=onMyFoodsView },
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
	top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
	buttons = tabButtons,
    bottomFill = {213,213,213,255}
    --background="TabBarBackground.png"
}

onLookUpView()	-- invoke first tab button's onPress event manually
setUpMyFoods()     