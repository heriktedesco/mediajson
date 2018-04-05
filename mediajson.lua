#!/usr/bin/env lua5.3
  
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
        -- Place here the piece of code that create the fields and it's values from the inputArray as a new strings array
        -- that will be handed over to rxi's Json.lua module
        return -- Place here array with fields and values to be returned.
end

function jsonOutput(jsonString)
        -- Place here the piece of code that turns jsonString into a json file with the CODPROGRAMA_DESCRIPTION.json naming.
        return -- Place here the boolean value point to successful json file creation
end

-- Piece of code that runs the function in it's correct order. Already done.
os.execute('mediainfo "'..arg[1]..'" >> temp.txt')
jsonOutput(jsonprocessing(fileToArray("temp.txt")))
os.execute('rm temp.txt')

