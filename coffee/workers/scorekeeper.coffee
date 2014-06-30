self.onmessage = (event) ->
    scoreIncrement = 5
    player = JSON.parse event.data.player
    zombie = JSON.parse event.data.zombie
    if player.magazine.shells < 1
        player.bonusStats.killsOnOneShell++ 
        if player.bonusStats.killsOnOneShell > 1
            scoreIncrement += 5
            scoreMessage = player.bonusStats.killsOnOneShell + ' kills on one shell! +10'
    if zombie.currentLocation >= zombie.lungingPoint - 50
        scoreIncrement += 5
        scoreMessage = 'Close call! +10'
    
    postMessage(
        scoreIncrement: scoreIncrement
        scoreMessage: scoreMessage
        bonusStats: player.bonusStats
    )