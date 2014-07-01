self.onmessage = (event) ->
    scoreIncrement = 5
    scoreMessages = []
    player = JSON.parse event.data.player
    zombie = JSON.parse event.data.zombie
    player.bonusStats.killLog.pop() if player.bonusStats.killLog.length >= 20
    player.bonusStats.killLog.unshift(
        time: event.data.killTime
        shellsRemaining: player.magazine.shells
        direction: player.currentDirection
        zombieLocation: zombie.currentLocation
    )
    #if player.magazine.shells < 1
    #    player.bonusStats.killsOnOneShell++ 
    #    if player.bonusStats.killsOnOneShell > 1
    #        scoreIncrement += player.bonusStats.killsOnOneShell - 1
    #        scoreMessages.push player.bonusStats.killsOnOneShell + ' kills on one shell! +' + scoreIncrement
    #else
    #    player.bonusStats.killsOnOneShell = 0
    #
    #for kill, index in player.bonusStats.killLog
    #    if kill.zombieLocation < 0
            
    
    if zombie.currentLocation >= zombie.lungingPoint - 50
        scoreIncrement += 5
        scoreMessages.push 'Close call! +5'
    if zombie.currentLocation < 0
        scoreIncrement += 2
        scoreMessages.push 'Long range! +2'
    
    postMessage(
        scoreIncrement: scoreIncrement
        scoreMessages: scoreMessages
        bonusStats: player.bonusStats
    )

## Keep a log of the last ~20 kills, each entry has data about the kill
# Several kills in quick succession
# 3 close calls in a row
# 6 close calls in a row
