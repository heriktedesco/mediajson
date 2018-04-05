#!/usr/bin/env lua5.3
  
function filetoarray(filename)
    -- Place here the piece of code that opens the file, create an array and insert each line of the file in it. 

    return -- Place here array with values to be returned.
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
json = require 'json'
os.execute('mediainfo "'..arg[1]..'" >> temp.txt')
jsonContent = json.encode(jsonprocessing(filetoarray("temp.txt")))
jsonOutput(jsonContent)

