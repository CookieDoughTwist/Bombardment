--[[

]]

--[[
    
]]
function drawSelectionsText(title, y)
    
    love.graphics.setFont(gFonts['futureearth32'])
    local width = love.graphics.getFont():getWidth(title)
    
    -- draw semi-transparent rect
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y - 11, 150, 58, 6)

    -- draw text shadows
    
    drawTextShadow(title, VIRTUAL_HEIGHT / 2 + y)
    
    love.graphics.setColor(200, 0, 200, 255)
    love.graphics.printf(title,
        0, VIRTUAL_HEIGHT / 2 + y,
            VIRTUAL_WIDTH, 'center')
end


function DrawMenu(currentOption, y, tags)
    -- draw rect behind start and quit game text
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill',
        VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 8 + MENU_TEXT_JUMP * #tags, 6)

    for k, tag in pairs(tags) do
        love.graphics.setFont(gFonts['futureearth32'])
        height = VIRTUAL_HEIGHT / 2 + y + 8 + MENU_TEXT_JUMP * (k - 1)
        drawTextShadow(tag, height
            )

        if currentOption == k then
            love.graphics.setColor(99, 155, 255, 255)
        else
            love.graphics.setColor(48, 96, 130, 255)
        end
        
        love.graphics.printf(tag, 0, height, VIRTUAL_WIDTH, 'center')
    end
end

--[[
    Helper function for drawing just text backgrounds; draws several layers of the same text, in
    black, over top of one another for a thicker shadow.
]]
function drawTextShadow(text, y)
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
    io.flush()
end