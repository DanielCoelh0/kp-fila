-- Sendo que o início da procura de equipa é feito através de uma ação do jogador/jogadores em questão, decidi criar um comando
-- que podesse ativar esta ação, ação esta como pretendido no enunciado, montar um sistema de fila que permitisse preencher as equipas tanto
-- vermelha como a azul, com os jogadores, tendo em conta que estes se já estivessem num grupos, não poderiam ser separados.

RegisterCommand('fila', function(source)
    local src = source
    TriggerClientEvent('kp-fila:client:FillPlayerTeam', src)
end)