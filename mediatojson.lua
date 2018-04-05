
function fileToArray(arquivo, debug)
  if debug == nil then debug = false end
  assert(not(arquivo == nil), "Nenhum nome de arquivo foi informado para funcao fileToArray")
  arquivo = io.open(arquivo, "r")
  assert(not(arquivo == nil), "arquivo nao encontrado")
  resultado = {}
  l = arquivo:read "*l"
  while not(l == nil) do
    table.insert(resultado, l)
    l = arquivo:read "*l"
  end
  if debug then
    for i, x in ipairs(resultado) do
      print(x)
    end
  end
  return resultado
end

function jsonProcessing(dados)


end

json = '{\n\t"name": "rick.mp4"\n}'


function jsonOutput(json)


end
