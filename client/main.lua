-- Variável que vai guardar a informação da Equipa final, quando a mesma já estiver preenchida e pronta a iniciar partida
local finalTeams = {
    ["blue"] = { players = {} },
    ["red"] = { players = {} }
}

-- Adiciona um novo jogador à equipa equivalente pelo parâmetro passado
local function AddPlayerToTeam(team, currentGroup, players)
    for _, player in pairs(players) do
        finalTeams[team].players[#finalTeams[team].players + 1] = {
            id = player.id,
            name = player.name,
            group = currentGroup
        }
    end
end

-- Evento chamado quando executado o comando /fila
RegisterNetEvent('kp-fila:client:FillPlayerTeam', function()

    -- Para ter a certeza que as equipas eram bem preenchidas e que estas tinham jogadores suficientes, decidi criar um sistema que permitisse
    -- ordenar as mesmas, pelo número de jogadores, fazendo com que então, as equipas maiores, fossem as primeiras a serem inseridas tanto na
    -- equipa azul como na vermelha

    -- Armazenamos numa nova tabela, o número de jogadores por grupo com o identificador de cada uma
    local teamPlayerCounts = {}
    for groupName, groupData in pairs(Config.queue) do
        teamPlayerCounts[groupName] = #groupData.players
    end

    -- Criamos uma lista para armazenar nomes grupos que irão ser ordenados consoante o número de jogadores por grupo
    local avaiableGroups = {}
    for groupName in pairs(teamPlayerCounts) do
        avaiableGroups[#avaiableGroups+1] = groupName
    end

    -- Ordena o nome dos grupos, consoante o número de jogadores
    table.sort(avaiableGroups, function(a, b)
        return teamPlayerCounts[a] > teamPlayerCounts[b]
    end)

    -- Adicionamos os dados ordenados numa nova tabela
    local sortedConfigQueue = {}
    for _, groupName in ipairs(avaiableGroups) do
        sortedConfigQueue[groupName] = Config.queue[groupName]
    end    

    
    -- Sendo que iremos remover os jogadores da lista de espera, é necessário que se verifique se as mesmas têm alguém em espera para ser
    -- inseridos numa equipa, caso contrário, evitamos que o servidor corra mais um processo
    while next(avaiableGroups) ~= nil and next(sortedConfigQueue) ~= nil do
        
        -- Percorremos todos os grupos, para que estes encontrem uma equipa.
        -- Caso as equipas estejam cheias, irá despertar o último else, matém com que o jogador fique à procura da equipa
        for _, currentGroup in pairs(avaiableGroups) do
                
            -- Definimos uma variável para o grupo a adicionar na equipa
            -- Iremos fazer um sort da mesma, para que possamos começar pelos grupos com mais jogadores, evitando assim,
            -- futuros problemas como haver equipas sem jogadores, visto que os mesmos, não podem ser separados do seu grupo
            local groupData = sortedConfigQueue[currentGroup]
    
            -- Verifica se a equipa azul já tem um máximo de 5 jogadores, caso contrário, iremos preencher a equipa vermelha
            if #finalTeams["blue"].players < 5 and (#finalTeams["blue"].players + #groupData.players) <= 5 then
                    
                -- Adiciona à equipa passada por parâmetro, também os jogadores do grpo passado como parâmetro
                AddPlayerToTeam("blue", currentGroup, groupData.players)
                avaiableGroups[currentGroup] = nil
                sortedConfigQueue[currentGroup] = nil
    
            elseif #finalTeams["red"].players < 5 and (#finalTeams["red"].players + #groupData.players) <= 5 then
    
                -- Adiciona à equipa passada por parâmetro, também os jogadores do grpo passado como parâmetro
                AddPlayerToTeam("red", currentGroup, groupData.players)
                avaiableGroups[currentGroup] = nil
                sortedConfigQueue[currentGroup] = nil
            else
                print("A procurar equipa!... Ambas as equipas estão cheias!!!")
            end
        end

        -- Percorre a tabela semelhante à do enunciado, e mostra os dados da mesma na consola do servidor
        for teamName, teamData in pairs(finalTeams) do
            print("")
            print("Equipa: " .. teamName)
            for _, player in pairs(teamData.players) do
                print("ID: " .. player.id .. " | Name: " .. player.name .. " | Group: " .. player.group)
            end
        end

        Wait(1000)
    end
end)