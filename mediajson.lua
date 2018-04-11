#!/usr/bin/env lua5.3
--[[ AUXILIARY FUNCTIONS ]]--
--TODO: consertar indentaçao
function removeJunkAtrib(rem)
    rem = string.sub(rem, 1, 42)
    rem = string.gsub(rem,":","")
    while string.sub(rem,-1,-1) == " " do
      rem = string.sub(rem,1,-2)
    end
    return rem
end

function increaseIndex(x)
  x = x + 1
  return x
end

--[[ MAIN FUNCTIONS ]]
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
        if debug then
                for i, x in ipairs(resultado) do print(x) end
        end
        return resultado
end

function jsonProcessing(inputArray)
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
      outputJsonG = string.sub(outputJsonG, 1, -1)
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
      outputJsonV = string.sub(outputJsonV, 1, -1)
      contVideo = contVideo + 1
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
      outputJsonA = string.sub(outputJsonA, 1, -1)
      contAudio = contAudio + 1
    end

    --[[ OTHER SESSION CONVERSION ]]--
    if inputArray[i] == "Other" then
      while not(inputArray[i] == "") do
        table.insert(atrib.other, removeJunkAtrib(inputArray[i]))
        table.insert(value.other, string.sub(inputArray[i], 44, -1))
        i = increaseIndex(i)
      end
      for i in ipairs(atrib.other) do
        outputJsonO = outputJsonO..'\n"'..atrib.other[i]..'":"'..value.other[i]..'",'
      end
      outputJsonO = string.sub(outputJsonO, 1, -1)
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
  -- codigo temporario

  print(outputJsonG.."\n----------")
  print(outputJsonV.."\n----------")
  print(outputJsonA.."\n----------")
  print(outputJsonO.."\n----------")


  -- lembrar de remover
  outputJson = "concluido"
  --fim codigo temporario
  return outputJson
end

function jsonOutput(jsonString)
    print("-INICIO-\n"..jsonString.."\n---FIM---")
        -- Place here the piece of code that turns jsonString into a json file with the CODPROGRAMA_DESCRIPTION.json naming.
        return -- Place here the boolean value point to successful json file creation
end

-- Piece of code that runs the function in it's correct order. Already done.
--os.execute('mediainfo "'..arg[1]..'" >> temp.txt')
jsonOutput(jsonProcessing(fileToArray("mediainfo.txt")))
--os.execute('rm temp.txt')
