class game.Game

    constructor: () ->
        @nextZombie = null
        @maxNumberOfZombies = 9
        @score = 0
        @killCount = 0
        @nextZombieTimeoutLength = null
        @nextZombieTimeoutStart = null
        @startTime = null
        @isActive = false
        @messageTimeout = null
        @isPaused = true
        @lastFrame = null
        @currentGameFrame = null
        @zombies =
            left: []
            right: []
    addToKillCount: () ->
        @killCount++
        game.killCountDisplay.html(@killCount)
    updateScore: (addition) ->
        @score += addition
    updateScoreDisplay: () ->
        game.scoreDisplay.html @score
    generateZombies: () ->
        @nextZombieTimeoutLength = 2000 - game.Utilities.randomIntBetween(600, 1400) if @nextZombieTimeoutLength is null
        @nextZombieTimeoutStart = new Date()
        @nextZombie = setTimeout () =>
            @nextZombieTimeoutLength = null
            comeFrom = if Math.random() >= .5 then 'left' else 'right'
            speed = game.Utilities.randomIntBetween 90, 110
            if @zombies['left'].length + @zombies['right'].length < @maxNumberOfZombies
                spriteIndex = Math.floor Math.random() * game.zombieSprites.length
                @zombies[comeFrom].push new game.Zombie comeFrom, game.zombieSprites[spriteIndex], speed, -75
            @generateZombies()
        , @nextZombieTimeoutLength
    pause: () ->
        @displayMessage 'Paused'
        @isPaused = true
        clearTimeout @nextZombie
        @nextZombieTimeoutLength -= new Date() - @nextZombieTimeoutStart
    resume: () ->
        $('#current-message').remove()
        @isPaused = false
        @generateZombies()
        @executeGameLoop()
    start: () ->
        game.prepareToStartOver()
        @player = new game.Player game.playerCanvas, 'left'
        @startTime = new Date()
        game.gameInProgress = true
        @isActive = true
        @resume()
    end: (message) ->
        @pause()
        @isActive = false
        game.gameInProgress = false
        @displayMessage(message)
        thingsToShow =
            'Survival Time: ' + (new Date() - @startTime)/1000 + ' seconds<br>' +
            'Zombies Killed: ' + @killCount + '<br>' +
            'Score: ' + @score + '<br>'
        setTimeout(
            () =>
                $('#current-message').remove()
                $('#stats').html(thingsToShow).parent().removeClass('hidden')
            , 1000
        )
        @player.ctx.restore()
    togglePause: () ->
        console.log @isActive
        return if @isActive is false
        if @isPaused is true
            @resume()
        else
            @pause()
    executeGameLoop: () ->
        if @isPaused is false
            time = new Date().getTime()
            for zombie in @zombies.left
                zombie.updatePosition(time) if zombie?
            for zombie in @zombies.right
                zombie.updatePosition(time) if zombie?
            game.zombieCanvas.left.clearRect 0, 0, 400, 415
            game.zombieCanvas.right.clearRect 0, 0, 400, 415
            
            for zombie in @zombies.left
                zombie.redraw() if zombie?
            for zombie in @zombies.right
                zombie.redraw() if zombie?
            
            if @player.isShooting or @player.isReloading or @player.isGettingBitten
                game.playerCanvasContext.clearRect 0, 0, game.playerCanvas.width, game.playerCanvas.height
                @player.updatePosition time
                @player.redraw()
        else
            (zombie.lastFrame = new Date().getTime()) for zombie in @zombies.left
            (zombie.lastFrame = new Date().getTime()) for zombie in @zombies.right
        game.Utilities.getFrame () => @executeGameLoop()
    displayMessage: (message, disappear = null, removeLast = true, size = 'large') ->
        clearTimeout @messageTimeout
        $('#current-message').remove() if removeLast is true
        newMessageElement = document.createElement 'div'
        newMessageElement.className = 'zooming ' + size
        newMessageElement.id = 'current-message'
        if typeof message is 'object'
            newMessageElement.innerHTML = message.join '<br>'
        else
            newMessageElement.innerHTML = message
        document.getElementById('info').appendChild(newMessageElement)
        if disappear? then @messageTimeout = setTimeout (() => $('#current-message').remove()), disappear