-----------------------------------------------------------------------------------------
--
-- view3.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
	background:setFillColor(1)
	
    --배경
	local bg = display.newImageRect("image/background.png", 1280, 720)
	bg.x, bg.y= display.contentWidth/2, display.contentHeight/2
	--바닥
	local ground = display.newImageRect("image/floor.png", 1280, 120)
	ground.x, ground.y = display.contentWidth/2, 660
	--우체통
	local postbox = display.newImageRect("image/postbox.png", 250, 300)
    postbox.x, postbox.y = display.contentWidth*0.9, display.contentHeight*0.7

	--음악
	--local music = audio.loadSound("music1.mp3")
	--audio.play(music)
	
    local title = display.newText("game 설명", display.contentCenterX, 100)
    title.size = 80
    title:setFillColor(0)

	local txt = "편지나 소포를 드래그해서 우체통에 넣으면 점수를 획득합니다.\n"
				.. "100단위 이상의 점수를 얻었고 3개 이상의 우편물을 넣으면 배송이 가능해요.\n"
				.. "배송이 가능해지면 클릭 버튼이 생기는데, 이 버튼을 누르면 제한 시간이 10초 증가!\n"
				.. "단, 버튼을 누를 때마다 시간이 흘러가는 속도가 점점 빨라져요.\n"
				.. "게임을 시작하려면 click버튼을 누르세요!"

	local newTextParams = { text = txt, 
						x = display.contentCenterX + 10, 
						y = title.y + 225, 
						width = 1000, height = 300, 
						font = native.systemFont, fontSize = 27, 
						align = "center"}
	local explain = display.newText(newTextParams)
	explain:setFillColor(0)

	local object = {}
    local obGroup = display.newGroup()
    --편지
	object[1] = display.newImageRect(obGroup, "image/letter.png", 100,110)
	--소포
	object[2] = display.newImageRect(obGroup, "image/box.png", 100,110)

    for i=1,#object do
        object[i].x, object[i].y = 450 + 300* (i-1), display.contentHeight*0.65
    end

    local score = {}
    local scoreGroup = display.newGroup()
    score[1] = display.newText(scoreGroup, "+10", 550, object[1].y)
    score[2] = display.newText(scoreGroup, "+30", 850, object[2].y)

    for i=1,#score do
        score[i].size = 20
        score[i]:setFillColor(0)
    end

    local click = display.newImageRect("image/click.png", 200, 100)
	click.x, click.y = display.contentWidth*0.9-5, display.contentHeight*0.7

    local function touch(event)
		--audio.pause(music)
        composer.gotoScene("view1")
    end
    click:addEventListener("tap",touch)

	--레이어정리
	sceneGroup:insert(background)
	sceneGroup:insert(bg)
	sceneGroup:insert(ground)
	sceneGroup:insert(postbox)
	sceneGroup:insert(click)
    sceneGroup:insert(obGroup)
	sceneGroup:insert(scoreGroup)
	sceneGroup:insert(title)
    sceneGroup:insert(explain)
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
		composer.removeScene("guide")
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