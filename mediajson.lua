#!/usr/bin/env lua5.3
--[[ AUXILIARY FUNCTIONS ]]--
function removeJunkAtrib(rem)
    rem = string.sub(rem, 1, 41)
    while string.sub(rem,-1,-1) == " " do
      rem = string.sub(rem,1,-2)
    end
    return rem
end

function increaseIndex(x)
  return x + 1
end

function finishJsonFormatting(dataType, data)
  return '\n\t"'..dataType..'":\n\t\t[{'..string.sub(string.gsub(string.gsub(data, '\n"','\n\t\t\t"'), ',\n\t\t\t"Name"','\n\t\t},\n\t\t{\n\t\t\t"Name"'), 1, -2)..'\n\t\t}],'
end

function finishJsonFormOther(data)
  return '\n\t"'..'Other'..'":\n\t\t[{'..string.sub(string.gsub(data, '\n"','\n\t\t\t"'), 1, -2)..'\n\t\t}]\n}'
end

function finishJsonFormGeneral(data)
  return string.gsub("{".. data, '\n"','\n\t"')
end

function retBoolDot(S,y)
  y = y * -1
  return string.sub(S, y, y) == "."
end
-- diretorio = arg[1] ...... filename campo da array lista de arquivo ....... i .......
function genJsonInFolder(directory, filename, lto, limiter)
  limiter = limiter * -1
  tempFile = string.sub(filename, 1, limiter)..'.temp'
  filePath = string.gsub(directory, ' ', '\\ ')..'/'..string.gsub(filename, ' ', '\\ ')
  os.execute('mediainfo '..filePath..' >> "'..tempFile..'"')
  isSuccessfull = jsonOutput(jsonProcessing(fileToArray(tempFile), directory, lto), ' '..string.sub(filename, 1, limiter), true)
  os.execute('rm "'..tempFile..'"')
  return isSuccessfull
end

function dirJson(dir, lto)
  os.execute('ls '..string.gsub(dir, ' ', '\\ ')..' >> templist')
  filesList = fileToArray("templist")
  os.execute("rm templist")
  for i,x in ipairs(filesList) do
    if string.sub(x, -4, -1) == ".mxf" then
      isSuccessfull = genJsonInFolder(dir, x, lto, 5)
    elseif string.sub(x, -3, -1) == ".ts" then
      isSuccessfull = genJsonInFolder(dir, x, lto, 4)
    end
  end
  return isSuccessfull
end

--[[ MAIN FUNCTIONS ]]--
function fileToArray(arquivo, debug)
    if debug == nil then debug = false end
    assert(not(arquivo == nil), "Nenhum nome de arquivo foi informado para funcao fileToArray.")
    arquivo = io.open(arquivo, "r")
    assert(not(arquivo == nil), "Arquivo nao encontrado.")
    resultado = {}
    l = arquivo:read "*l"
    while not(l == nil) do
        table.insert(resultado, l)
        l = arquivo:read "*l"
    end
    arquivo:close()
    return resultado
end

function jsonProcessing(inputArray, nomeArquivo, lto)
  atrib = {}
    atrib.video = {}
    atrib.audio = {}
    atrib.other = {}
  value = {}
    value.video = {}
    value.audio = {}
    value.other = {}
  outputJsonG = ''
  outputJsonV = ''
  outputJsonA = ''
  outputJsonO = ''
  contVideo = 1
  contAudio = 1

  for i in ipairs (inputArray) do
    --[[ GENERAL SESSION CONVERSION ]]--
    if inputArray[i] == "General" then
      i = increaseIndex(i)
      while not(inputArray[i] == "") do
        table.insert(atrib, removeJunkAtrib(inputArray[i]))
        table.insert(value, string.sub(inputArray[i], 44, -1))
        i = increaseIndex(i)
      end
      for i in ipairs(atrib) do
        outputJsonG = outputJsonG..'\n"'..atrib[i]..'":"'..value[i]..'",'
      end
        outputJsonG = outputJsonG..'\n"Codigo de Programa": "'..string.sub(nomeArquivo, 1, 7)..'",'
        outputJsonG = outputJsonG..'\n"TAPE Number": "'..lto..'",'
    end

    --[[ VIDEO SESSION CONVERSION ]]--
    if string.sub(inputArray[i], 1, 5) == "Video" then
      table.insert(atrib.video, "Name")
      table.insert(value.video, "Video #".. contVideo)
      i = increaseIndex(i)
      while not(inputArray[i] == "") do
        table.insert(atrib.video, removeJunkAtrib(inputArray[i]))
        table.insert(value.video, string.sub(inputArray[i], 44, -1))
        i = increaseIndex(i)
      end
      for i in ipairs(atrib.video) do
        outputJsonV = outputJsonV..'\n"'..atrib.video[i]..'":"'..value.video[i]..'",'
      end
      contVideo = increaseIndex(contVideo)
    end

    --[[ AUDIO SESSION CONVERSION ]]--
    if string.sub(inputArray[i], 1, 5) == "Audio" then
      table.insert(atrib.audio, "Name")
      table.insert(value.audio, "Audio #".. contAudio)
      i = increaseIndex(i)
      while not(inputArray[i] == "") do
        table.insert(atrib.audio, removeJunkAtrib(inputArray[i]))
        table.insert(value.audio, string.sub(inputArray[i], 44, -1))
        i = increaseIndex(i)
      end
      for i in ipairs(atrib.audio) do
        outputJsonA = outputJsonA..'\n"'..atrib.audio[i]..'":"'..value.audio[i]..'",'
      end
      contAudio = increaseIndex(contAudio)
    end

    --[[ OTHER SESSION CONVERSION ]]--
    if inputArray[i] == "Other" then
      i = increaseIndex(i)
      while not(inputArray[i] == nil) do
        table.insert(atrib.other, removeJunkAtrib(inputArray[i]))
        table.insert(value.other, string.sub(inputArray[i], 44, -1))
        i = increaseIndex(i)
      end
      for i in ipairs(atrib.other) do
        if not(atrib.other[i] == '') then
          outputJsonO = outputJsonO..'\n"'..atrib.other[i]..'":"'..value.other[i]..'",'
        end
      end
    end

    atrib = {}
      atrib.video = {}
      atrib.audio = {}
      atrib.other = {}
    value = {}
      value.video = {}
      value.audio = {}
      value.other = {}
  end
  return finishJsonFormGeneral(outputJsonG)..finishJsonFormatting('Video', outputJsonV)..finishJsonFormatting('Audio', outputJsonA)..finishJsonFormOther(outputJsonO)
end

function jsonOutput(jsonString, subFile, flagDir)
  for i = arg[1]:len(), 1, -1 do
    if arg[1]:sub(i,i) == '.' then
      _ = i
      break
    end
  end

  if not subFile then
    fileName = arg[1]:sub(1,_).."json"
  else
    fileName = arg[1]:sub(1, -2).." - arquivo "..subFile..".json"
  end
  receiveJson = io.open(fileName, "w")
  receiveJson:write(jsonString)
  receiveJson:close()
  if fileToArray(fileName) == nil then
    return false
  else
    return true
  end
end

assert(not(arg[1] == nil), "Name of the Movie not mentioned in the script arguments! Aborting...")
assert(not(arg[2] == nil), "Name of the Destination Tape not mentioned in the script arguments! Aborting...")
if not(retBoolDot(arg[1], 5) or retBoolDot(arg[1], 4) or retBoolDot(arg[1], 3)) then
  isSuccessfull = dirJson(arg[1], arg[2])
else
  tempFile = string.sub(arg[1], 1, -5)..'.temp'
  os.execute('mediainfo "'..arg[1]..'" >> "'..tempFile..'"')
  isSuccessfull = jsonOutput(jsonProcessing(fileToArray(tempFile), arg[1], arg[2]), false)
  os.execute('rm "'..tempFile..'"')
end
if isSuccessfull then
    print("JSON creation completed")
    return 1
else
    print("Some error happened when creating the file's JSON!")
    return 0
end
