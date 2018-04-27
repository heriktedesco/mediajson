#!/usr/bin/env lua5.3
--[[
     Version of the mediaJSON script with a Graphical Interface:
     Uses Lenity to provide dialogs for the whole process.
]]--

-- https://github.com/LPLBrasil/Lenity : Created by Gustavo H M Silva
l = require 'lenity'

nameFile = l.fileselection("JSON")

nameLto = l.entry("Nome da LTO", "Escreva qual LTO deseja gravar.")

commandJson = 'mediajson "'..nameFile..'" "'..nameLto..'"'

-- Missing verification "." (point) and call variables.
for i = nameFile:len(), 1, -1 do
  if nameFile:sub(i , i) == "/" then
    filePath, filename = nameFile:sub(1, i), nameFile:sub(i + 1, nameFile:len())
    break
  end
end

os.execute(commandJson)

jsonFile = string.sub(nameFile, 1, -5)..".json"

if not(nameLto == "") then
  l.textinfo("Confirmação", jsonFile, nil, nil, nil, nil, nil, 1000, 800)
else
  l.info("Confirmação", "Você não escolheu a LTO para ser gravada.")
end

print(nameFile)
print(nameLto)
