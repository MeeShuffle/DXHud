




addCommandHandler("updatehud",function(plr)
    print("[DXHud] Łączenie z GitHub...")
    print("[DXHud] Przygotowywanie do pobierania...")
    fetchRemote("https://raw.githubusercontent.com/sirphantasm/DXHud/main/DXHud/meta.xml",function(data,error,path)
        if error==0 then
            if fileExists("download.xml") then
                fileDelete("download.xml")
            end
            local file=fileCreate("download.xml")
            fileWrite(file,data)
            fileClose(file)
            print("[DXHud] Lista plików pobrana, szykuję do pobrania...")
            prepare()
        end
    end,"",false,"meta.xml")
end)



function prepare()
    files={}
    local xml = xmlLoadFile("download.xml")
	for k,v in pairs(xmlNodeGetChildren(xml)) do
		if xmlNodeGetName(v) == "script" or xmlNodeGetName(v) == "file" then
			local path = xmlNodeGetAttribute(v,"src")
            table.insert(files,path)
        end
    end
    print("[DXHud] Pliki przygotowane do pobrania...")
    xmlUnloadFile(xml)
    fileCount=0
    download()
end



function download()
    fileCount=fileCount+1
    if fileCount>#files then
        finish()
        return
    end
    fetchRemote("https://raw.githubusercontent.com/sirphantasm/DXHud/main/DXHud/"..files[fileCount],function(data,error,sciezka)
        if error==0 then
            if fileExists(sciezka) then
                fileDelete(sciezka)
            end
            local file=fileCreate(sciezka)
            fileWrite(file,data)
            fileClose(file)
            print(sciezka.." pobrane..")
            download()
        end
    end,"",false,files[fileCount])
end


function finish()
    print("Pobieranie zakończone, zrestartuj zasób DXHud")
    local xml=fileOpen("download.xml")
    local size = fileGetSize(xml)
    local xml_content=fileRead(xml,size)
    fileClose(xml)
    if fileExists("meta.xml") then
        fileDelete("meta.xml")
    end
    local meta=fileCreate("meta.xml")
    fileWrite(meta,xml_content)
    fileClose(meta)
    fileDelete("download.xml")
    fetchRemote("https://raw.githubusercontent.com/sirphantasm/DXHud/main/DXHud/version.txt",function(data,error,sciezka)
        if error==0 then
            if fileExists(sciezka) then
                fileDelete(sciezka)
            end
            local file=fileCreate(sciezka)
            fileWrite(file,data)
            fileClose(file)
        end
    end,"",false,"version.txt")
end




function checkVersion()
    fetchRemote("https://raw.githubusercontent.com/sirphantasm/DXHud/main/DXHud/version.txt",function(data,error,sciezka)
        if error==0 then
            if not fileExists(sciezka) then
                local file=fileCreate(sciezka)
                fileWrite(file,"1.0")
            else
                local file=fileOpen("version.txt")
                local size=fileGetSize(file)
                local content=fileRead(file,size)
                if data~=content then
                    print("Dostępna jest nowsza wersja DXHud by sirphantasm#1234 ("..data.."). Obecna wersja ("..content..").")
                    print("Wpisz /updatehud aby pobrać aktualizację")
                end
            end
        end
    end,"",false,"version.txt")
end
setTimer(checkVersion,60000,0)
addCommandHandler("hudwersja",checkVersion)