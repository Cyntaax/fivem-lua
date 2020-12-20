API:On("something", function(player, arg1, arg2)
    print("Players health during this request was", player:Health())

    player:Health(190)
end)
