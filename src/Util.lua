--[[

]]

-- rotate vector the specified radian angle (positive is clockwise)
function rotateVector(x, y, radians)
    local rsin = math.sin(radians)
    local rcos = math.cos(radians)
    local xrot = rcos * x - rsin * y
    local yrot = rsin * x + rcos * y
    return xrot, yrot
end

function rotateTable(table, radians)
    for n = 1, #table, 2 do
        local xrot, yrot = rotateVector(table[n], table[n + 1], radians)
        table[n] = xrot
        table[n + 1] = yrot
    end
end

function multiplyTable(table, factor)
    for k, v in pairs(table) do
        table[k] = v * factor
    end
end

function addTable(table, increment)
    for k, v in pairs(table) do
        table[k] = v + increment
    end
end

function addPointTable(table, point)
    odd = true
    for k, v in pairs(table) do
        if odd then
            table[k] = v + point[1]
            odd = false
        else
            table[k] = v + point[2]
            odd = true
        end
    end
end

function floorTable(table)
    for k, v in pairs(table) do
        table[k] = math.floor(v)
    end
end

function getVectorMag(x, y)
    return math.sqrt(x^2 + y^2)
end

function unitizeVector(x, y)
    local mag = math.sqrt(x^2 + y^2)
    return x / mag, y / mag
end

function getImageHalfDimensions(imageTag)
    local image = gTextures[imageTag]
    local iWidth, iHeight = image:getDimensions()
    local iWidth_2, iHeight_2 = iWidth / 2, iHeight / 2
    return iWidth_2, iHeight_2
end

-- forcing up to be 0 degrees
function drawArc(drawmode, arctype, x, y, radius, angle1, angle2, segments)
    love.graphics.arc(drawmode, arctype, x, y, radius, angle1 - PI_2, angle2 - PI_2, segments)
end

-- TODO: requires modularization 8/4/18 -AW
function drawSelectionsText(title, y)
    
    love.graphics.setFont(gFonts['futureearth64'])
    local textWidth = love.graphics.getFont():getWidth(title)
    local textHeight = love.graphics.getFont():getHeight(title)
    
    -- draw semi-transparent rect
    love.graphics.setColor(255, 255, 255, 128)        
    love.graphics.rectangle('fill',                                                
        VIRTUAL_WIDTH / 2 - textWidth / 2 - (MENU_BOX_PAD_X + 6) / 2 + TEXT_BUFFER_X,
        VIRTUAL_HEIGHT / 2 - MENU_BOX_PAD_Y / 2 + y + TEXT_BUFFER_Y,
        textWidth + MENU_BOX_PAD_X + 6,
        textHeight + MENU_BOX_PAD_Y, 6)

    -- draw text shadows
    
    drawTextShadow(title, VIRTUAL_HEIGHT / 2 + y)
    
    love.graphics.setColor(200, 0, 200, 255)
    love.graphics.printf(title,
        0, VIRTUAL_HEIGHT / 2 + y,
            VIRTUAL_WIDTH, 'center')
end


function drawMenu(currentOption, y, tags)

    local maxTextWidth = 0
    local maxTextHeight = 0
    for k, tag in pairs(tags) do
        local textWidth = love.graphics.getFont():getWidth(tag)
        local textHeight = love.graphics.getFont():getHeight(tag)
        if textWidth > maxTextWidth then
            maxTextWidth = textWidth
        end
        if textHeight > maxTextHeight then
            maxTextHeight = textHeight
        end
    end

    -- draw rect behind start and quit game text
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill',                                                
        VIRTUAL_WIDTH / 2 - maxTextWidth / 2 - (MENU_BOX_PAD_X + 6) / 2 + TEXT_BUFFER_X,
        VIRTUAL_HEIGHT / 2 - ((#tags + 1) * (MENU_BOX_PAD_Y / 2)) + y + TEXT_BUFFER_Y,
        maxTextWidth + MENU_BOX_PAD_X + 6,
        #tags * (maxTextHeight + MENU_BOX_PAD_Y / 2) + MENU_BOX_PAD_Y, 6)
        
    for k, tag in pairs(tags) do
        love.graphics.setFont(gFonts['futureearth64'])
        
        height = VIRTUAL_HEIGHT / 2 + y + 8 + MENU_TEXT_JUMP * (k - 1)
        drawTextShadow(tag, height)

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