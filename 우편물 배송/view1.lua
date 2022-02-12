-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
	background:setFillColor(1)

	local sound = audio.loadSound("sound.mp3")
	--배경
	local bg = display.newImageRect("image/background.png", 1280, 720)
	bg.x, bg.y= display.contentWidth/2, display.contentHeight/2
	--바닥
	local ground = display.newImageRect("image/floor.png", 1280, 120)
	ground.x, ground.y = display.contentWidth/2, 660
	--경고
	local warning = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
	warning:setFillColor(255,0,0)
	warning.alpha = 0
	--우체통
	local postbox = display.newImageRect("image/postbox.png", 250, 300)
	postbox.x, postbox.y = display.contentWidth*0.9, display.contentHeight*0.7
	
	--편지
	local letter = {}
	local letterGroup = display.newGroup()

	for i = 1, 5 do
		letter[i] = display.newImageRect(letterGroup, "image/letter.png", 100,110)
		letter[i].x, letter[i].y = display.contentWidth/2 + math.random(-600, 600), display.contentHeight*0.2 + math.random(-100, 120)
	end
	--소포
	local box = {}
	local boxGroup = display.newGroup()
	--소포 랜덤 배치
	for i = 1, 5 do
		box[i] = display.newImageRect(boxGroup, "image/box.png", 100,110)
		box[i].x, box[i].y = display.contentWidth/2 + math.random(-600, 600), display.contentHeight*0.2 + math.random(-100, 120)
	end

	--점수
	local score = 0
	local showScore = display.newText(score, display.contentWidth*0.2, display.contentHeight*0.2)
	showScore:setFillColor(0)
	showScore.size = 100

	--버튼 누른 횟수
	local clickNum = 1
	--편지&소포 담은 횟수
	local lbnum = 0
	--버튼
	local click = display.newImageRect("image/click.png", 200, 100)
	click.x, click.y = display.contentWidth*0.9-5, display.contentHeight*0.7
	click.alpha = 0

	--편지&소포 드래그해서 우체통에 넣기
	for i=1,5 do
		box[i].id = i .. "번 box"
		letter[i].id = i.."번 letter"
	end

	--받는 점수 return함수
	local function getSc(target)
		local flag = 0

		for i=1, 5 do
			if(target.id == i .."번 box") then
				flag = 1
				break
			elseif(target.id == i .."번 letter") then
				flag = 2
				break
			end
		end

		if flag ==1 then
			return 30
		elseif flag == 2 then
			return 10
		else
			return 0
		end
	end

	local function catch(event)
		local getScore = getSc(event.target)
		
		if(event.phase == "began") then
			print("시작")
			
			print(event.target.id .. "드래그!")

			display.getCurrentStage():setFocus(event.target)
			event.target.isFocus = true

		elseif(event.phase == "moved") then
			if(event.target.isFocus) then
				event.target.x = event.xStart+event.xDelta
				event.target.y = event.yStart+event.yDelta
			end
		elseif(event.phase == "ended" or event.phase == "cancelled") then
			if(event.target.isFocus) then
				print("끝")
				
				if event.target.x < postbox.x + 100 and event.target.x>postbox.x - 100
				and event.target.y<postbox.y + 100 and event.target.y > postbox.y - 100 then
					audio.play(sound)
					display.remove(event.target)
					score = score + getScore
					showScore.text = score
					lbnum = lbnum + 1
					
					--버튼은 점수가 100단위 이상이고 
					--담은 편지(소포)가 4개 이상이어야 뜬다
					if ((score>=(100*clickNum)) and (lbnum >= 4))then
						click.alpha = 1
						clickNum = clickNum + 1
						lbnum = 0
					end
				else
					event.target.x = event.xStart
					event.target.y = event.yStart
				end

				display.getCurrentStage():setFocus(nil)
				event.target.isFocus = false
			end
			display.getCurrentStage():setFocus(nil)
			event.target.isFocus = false
		end
	end

	for i=1,5 do
		box[i]:addEventListener("touch", catch)
		letter[i]:addEventListener("touch", catch)
	end

	--시간 제한
	local limit = 15
	local dt = 2000
	local showLimit = display.newText(limit, display.contentWidth*0.9, display.contentHeight*0.1)
	showLimit:setFillColor(0)
	showLimit.size=80
	
	local function timeAttack(event)
		limit = limit - 1
		showLimit.text = limit
		if limit <= 5 then
			warning.alpha = 0.6
			transition.to( warning, { time=500, delay=10, alpha=0 } )
		end
		if limit == 0 then
			display.remove(warning)
			composer.setVariable("showScore",score)
			composer.gotoScene("ending")
		end
	end
	timer.performWithDelay(dt,timeAttack,0)
	
	--수레 이동
	local function cartMove()
		local cart2 = display.newImageRect("image/cart2.png", 350,300)
		cart2.x = postbox.x
		cart2.y = 560
		transition.to( cart2, { time=2000, x=-175} )
	end
	
	--버튼 클릭했을 때
	local function tapButton(event)
		click.alpha = 0
		dt = dt-0.005
		print(dt)
		timer.performWithDelay(dt,timeAttack,0)
		
		cartMove()
		for i=1,5 do
			display.remove(box[i])
			display.remove(letter[i])
		end
		limit = limit + 10
		showLimit.text = limit

		for i = 1, 5 do
			box[i] = display.newImageRect(boxGroup, "image/box.png", 100,110)
			box[i].x, box[i].y = display.contentWidth/2 + math.random(-600, 600), display.contentHeight*0.2 + math.random(-100, 120)
			letter[i] = display.newImageRect(letterGroup, "image/letter.png", 100,110)
			letter[i].x, letter[i].y = display.contentWidth/2 + math.random(-600, 600), display.contentHeight*0.2 + math.random(-100, 120)
		end
		for i=1,5 do
			box[i].id = i .. "번 box"
			letter[i].id = i .. "번 letter"
		end
		for i=1,5 do
			box[i]:addEventListener("touch", catch)
			letter[i]:addEventListener("touch", catch)			
		end

	end

	--이벤트 등록
	click:addEventListener("tap",tapButton)
	--레이어정리
	sceneGroup:insert(background)
	sceneGroup:insert(bg)
	sceneGroup:insert(ground)
	sceneGroup:insert(postbox)
	sceneGroup:insert(warning)
	sceneGroup:insert(click)
	sceneGroup:insert(boxGroup)
	sceneGroup:insert(letterGroup)
	sceneGroup:insert(showScore)
	sceneGroup:insert(showLimit)
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
		composer.removeScene("view1")
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