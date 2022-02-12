-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
		
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 0 )	-- white
		
	local halfW = display.contentWidth * 0.5

	local halfH = display.contentHeight * 0.5
	local vertices = { 0,-110, 27,-35, 105,-35, 43,16, 65,90, 0,45, -65,90, -43,15, -105,-35, -27,-35, }

	local rect = display.newRect(50, 150, 50, 50);
	local circle = display.newCircle(150, 150, 50);
	local star = display.newPolygon( halfW, halfH, vertices )

	local sound1 = audio.loadSound( "Calimba.mp3" );
	local sound2 = audio.loadSound( "Calimba.mp3" );
	local sound3 = audio.loadSound( "Calimba.mp3" );
	

	local function onObjectTouch( event )

		if event.phase == "began" then

    		if event.target == rect then 

	        	audio.play(sound1)

	elseif event.target == circle then

	audio.play(sound2)

	elseif event.target == star then

	audio.play(sound3)

	end

		end

		return true

	end

	

	rect:addEventListener( "touch", onObjectTouch )

	circle:addEventListener( "touch", onObjectTouch )

	star:addEventListener( "touch", onObjectTouch )
	end

	function scene:show( event )
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