#!/usr/bin/env lua5.3
-- https://github.com/LPLBrasil/Lenity : Created by Gustavo H M Silva
l = require 'lenity'
--[[
     Version of the mediaJSON script with a Graphical Interface:
     Uses Lenity to provide dialogs for the whole process.
]]--

nameFile = l.fileselection("JSON")
nameLto = l.entry("Nome da LTO", "Escreva qual LTO deseja gravar.")

for i = nameFile:len(), 1, -1 do
  if nameFile:sub(i, i) == '.' then _ = i end
  if nameFile:sub(i, i) == "/" then
    filePath, filename, filenameNoExtension = nameFile:sub(1, i), nameFile:sub(i+1, nameFile:len()), nameFile:sub(i+1,_)
    break
  end
end

commandJson = 'cd '..filePath..' && ./mediajson.lua "'..filename..'" "'..nameLto..'"'
print(commandJson)
os.execute(commandJson)

if not(nameLto == "") then
  l.textinfo("Confirmação", filenameNoExtension.."json",0,0,0,0,0,1000,800)
else
  l.info("Confirmação", "Você não escolheu a LTO para ser gravada.")
end
