



hud={
    s=Vector2(guiGetScreenSize()),
    scale=function(x,y,w,h)
        x=(x/1920)*hud.s["x"]
        y=(y/1080)*hud.s["y"]
        w=(w/1920)*hud.s["x"]
        h=(h/1080)*hud.s["y"]
        return x,y,w,h
    end,
    speed=function (theElement, unit)
        local elementType = getElementType(theElement)
        unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
        local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
        return (Vector3(getElementVelocity(theElement)) * mult).length
    end,
    point=function (liczba)  
        local format = liczba  
        while true do      
            format, k = string.gsub(format, "^(-?%d+)(%d%d%d)", '%1 %2')    
            if ( k==0 ) then      
                break  
            end  
        end  
        return format
    end,
    heartbg=dxCreateTexture("images/heart_bg.png"),
    heart=dxCreateTexture("images/heart.png"),
    shieldbg=dxCreateTexture("images/shield_bg.png"),
    shield=dxCreateTexture("images/shield.png"),
    runbg=dxCreateTexture("images/run_bg.png"),
    run=dxCreateTexture("images/run.png"),
    oxygenbg=dxCreateTexture("images/oxygen_bg.png"),
    oxygen=dxCreateTexture("images/oxygen.png"),
    health=getElementHealth(localPlayer),
    armor=getPedArmor(localPlayer),
    money=getPlayerMoney(localPlayer),
    breath=100,
    elements={
        "clock","ammo","armour","health","money","weapon","breath","wanted"
    }
}
local pos={
    ["bg"]={hud.scale(1437, 16, 483, 48)},
    ["heart"]={hud.scale(1823, 48, 50, 45)},
    ["shield"]={hud.scale(1732, 43, 50, 54)},
    ["run"]={hud.scale(1642, 48, 50, 45)},
    ["oxygen"]={hud.scale(1553, 48, 50, 45)},
    ["line"]={hud.scale(1517, 113, 1920, 113)},
    ["txt"]={hud.scale(1556, 135, 1872, 174)},
    font=dxCreateFont("font.ttf",(25/1920)*hud.s["x"],false,"antialiased"),
    font2=dxCreateFont("font.ttf",(30/1920)*hud.s["x"],false,"antialiased"),
}
for _,v in ipairs(hud["elements"])do
    setPlayerHudComponentVisible(v,false)
end

addEventHandler("onClientResourceStop",resourceRoot,function()
    for _,v in ipairs(hud["elements"])do
        setPlayerHudComponentVisible(v,true)
    end
end)



hud.render=function()
    --dxDrawRectangle(pos["bg"][1],pos["bg"][2],pos["bg"][3],pos["bg"][4], tocolor(0, 0, 0, 187), false)

    ---HEALTH
    
    if math.ceil(getElementHealth(localPlayer))>math.ceil(hud.health) then
        hud.health=hud.health+1
    elseif math.ceil(getElementHealth(localPlayer))<math.ceil(hud.health) then
        hud.health=hud.health-1
    end
    dxDrawImageSection(pos["heart"][1],pos["heart"][2]+pos["heart"][4],pos["heart"][3],-(pos["heart"][4])*(math.ceil(hud.health)/100),0,0,pos["heart"][3],-(pos["heart"][4])*(math.ceil(hud.health)/100),hud.heart)
    dxDrawImage(pos["heart"][1],pos["heart"][2],pos["heart"][3],pos["heart"][4], hud.heartbg, 0, 0, 0, tocolor(0, 0, 0, 255), false)
    --ARMOR
    
    if math.ceil(getPedArmor(localPlayer))>math.ceil(hud.armor) then
        hud.armor=hud.armor+1
    elseif math.ceil(getPedArmor(localPlayer))<math.ceil(hud.armor) then
        hud.armor=hud.armor-1
    end
    dxDrawImageSection(pos["shield"][1],pos["shield"][2]+pos["shield"][4],pos["shield"][3],-pos["shield"][4]*(math.ceil(hud.armor)/100),0,0,pos["shield"][3],-pos["shield"][4]*(math.ceil(hud.armor)/100),hud.shield)
    dxDrawImage(pos["shield"][1],pos["shield"][2],pos["shield"][3],pos["shield"][4], hud.shieldbg, 0, 0, 0, tocolor(0, 0, 0, 255), false)

    --BREATH
    dxDrawImageSection(pos["run"][1],pos["run"][2]+pos["run"][4],pos["run"][3],-pos["run"][4]*(math.ceil(hud.breath)/100),0,0,pos["run"][3],-pos["run"][4]*(math.ceil(hud.breath)/100),hud.run)
    dxDrawImage(pos["run"][1],pos["run"][2],pos["run"][3],pos["run"][4], "images/run_bg.png", 0, 0, 0, tocolor(0, 0, 0, 255), false)

    --OXYGEN (only in water)
    if isElementInWater(localPlayer) then
        local o2=getPedOxygenLevel(localPlayer)
        dxDrawImageSection(pos["oxygen"][1],pos["oxygen"][2]+pos["oxygen"][4],pos["oxygen"][3],-pos["oxygen"][4]*(math.ceil(o2)/1000),0,0,pos["oxygen"][3],-pos["oxygen"][4]*(math.ceil(o2)/1000),hud.oxygen)
    end
    dxDrawImage(pos["oxygen"][1],pos["oxygen"][2],pos["oxygen"][3],pos["oxygen"][4], hud.oxygenbg, 0, 0, 0, tocolor(0, 0, 0, 255), false)

    --LINE AND MONEY
    if hud.money ~= getPlayerMoney(localPlayer) then
        local checkMoney = hud.money - getPlayerMoney(localPlayer)
        if checkMoney == math.abs(checkMoney) then
            if tonumber(hud.money-getPlayerMoney(localPlayer))>1000000 then
                hud.money = hud.money - 100000
            elseif tonumber(hud.money-getPlayerMoney(localPlayer))>100000 then
                hud.money = hud.money - 10000
            elseif tonumber(hud.money-getPlayerMoney(localPlayer))>10000 then
                hud.money = hud.money - 1000
            elseif tonumber(hud.money-getPlayerMoney(localPlayer))>1000 then
                hud.money=hud.money-100
            elseif tonumber(hud.money-getPlayerMoney(localPlayer))>100 then
                hud.money=hud.money-10
            else
                hud.money=hud.money-1
            end
        else
            if tonumber(getPlayerMoney(localPlayer)-hud.money)>1000000 then
                hud.money = hud.money + 100000
            elseif tonumber(getPlayerMoney(localPlayer)-hud.money)>100000 then
                hud.money = hud.money + 10000
            elseif tonumber(getPlayerMoney(localPlayer)-hud.money)>10000 then
                hud.money = hud.money + 1000
            elseif tonumber(getPlayerMoney(localPlayer)-hud.money)>1000 then
                hud.money=hud.money+100
            elseif tonumber(getPlayerMoney(localPlayer)-hud.money)>100 then
                hud.money=hud.money+10
            else
                hud.money=hud.money+1
            end
        end
        dxDrawText(hud.point(string.format('%08d', hud.money)).."  $", pos["txt"][1]+1,pos["txt"][2]+1,pos["txt"][3]+1,pos["txt"][4]+1, tocolor(0, 0, 0, 255), 1.00, pos.font2, "right", "center", false, false, false, true, false)
        dxDrawText(hud.point(string.format('%08d', hud.money)).."  #c102d3$", pos["txt"][1],pos["txt"][2],pos["txt"][3],pos["txt"][4], tocolor(255, 255, 255, 255), 1.00, pos.font2, "right", "center", false, false, false, true, false)
    else
        dxDrawText(hud.point(string.format('%08d', hud.money)).."  $", pos["txt"][1]+1,pos["txt"][2]+1,pos["txt"][3]+1,pos["txt"][4]+1, tocolor(0, 0, 0, 255), 1.00, pos.font, "right", "center", false, false, false, true, false)
        dxDrawText(hud.point(string.format('%08d', hud.money)).."  #c102d3$", pos["txt"][1],pos["txt"][2],pos["txt"][3],pos["txt"][4], tocolor(255, 255, 255, 255), 1.00, pos.font, "right", "center", false, false, false, true, false)
    end
    
    dxDrawLine(pos["line"][1]+1,pos["line"][2]+1,pos["line"][3]+1,pos["line"][4]+1, tocolor(0, 0, 0, 182), 2, false)
    dxDrawLine(pos["line"][1],pos["line"][2],pos["line"][3],pos["line"][4], tocolor(193, 2, 211, 182), 2, false)
    


    --CALCULATE BREATH
    if not isPedInVehicle(localPlayer) and not doesPedHaveJetPack(localPlayer) then
        local pSpeed = hud.speed(localPlayer,0)
        if pSpeed >= 7.5 and pSpeed <= 10 and hud.breath >= 0 then
            hud.breath = hud.breath - 0.3
        elseif pSpeed >= 5 and pSpeed <= 7 and hud.breath >= 0 then 
            
        elseif pSpeed ==0 and hud.breath <= 100 then 
            hud.breath = hud.breath + 0.1
        end
        if hud.breath <20 then
            setControlState("sprint", false)
            setControlState("jump", false)
            toggleControl("sprint", false)
            toggleControl("jump", false)
        elseif hud.breath >= 20 then
            toggleControl("sprint", true)
            toggleControl("jump", true)
        end
    elseif isPedInVehicle(localPlayer) or doesPedHaveJetPack(localPlayer) then
        if hud.breath <= 100 then 
            hud.breath = hud.breath + 0.03
        end
    end
end
addEventHandler("onClientRender",root,hud.render)



