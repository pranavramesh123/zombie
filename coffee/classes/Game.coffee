class cac.Game

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
        cac.killCountDisplay.html(@killCount)
    updateScore: (addition) ->
        @score += addition
    updateScoreDisplay: () ->
        cac.scoreDisplay.html @score
    generateZombies: () ->
        @nextZombieTimeoutLength = 2000 - cac.Utilities.randomIntBetween(600, 1400) if @nextZombieTimeoutLength is null
        @nextZombieTimeoutStart = new Date()
        @nextZombie = setTimeout () =>
            @nextZombieTimeoutLength = null
            comeFrom = if Math.random() >= .5 then 'left' else 'right'
            speed = cac.Utilities.randomIntBetween 90, 110
            if @zombies['left'].length + @zombies['right'].length < @maxNumberOfZombies
                spriteIndex = Math.floor Math.random() * cac.zombieSprites.length
                @zombies[comeFrom].push new cac.Zombie comeFrom, cac.zombieSprites[spriteIndex], speed, -75
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
        cac.prepareToStartOver()
        @player = new cac.Player cac.playerCanvas, 'left'
        @startTime = new Date()
        cac.gameInProgress = true
        @isActive = true
        @resume()
    end: (message) ->
        @pause()
        @isActive = false
        cac.gameInProgress = false
        @displayMessage(message)
        survivalTime = (new Date() - @startTime)/1000
        roundedSurvivalTime = Math.floor survivalTime 
        if survivalTime < 60
            displaySurvivalTime = if roundedSurvivalTime is 1 then roundedSurvivalTime + ' second' else roundedSurvivalTime + ' seconds'
        else
            minutes = Math.floor(roundedSurvivalTime/60)
            seconds = roundedSurvivalTime%60
            formattedMinutes = if minutes is 1 then minutes + ' minute' else minutes + ' minutes'
            formattedSeconds = if seconds is 1 then seconds + ' second' else seconds + ' seconds'
            displaySurvivalTime = formattedMinutes + ' and ' + formattedSeconds
        thingsToShow = [
            'Survival Time: ' + displaySurvivalTime,
            'Zombies Killed: ' + @killCount,
            'Score: ' + @score
        ]
        if window.localStorage.getItem('records')?
            records = JSON.parse window.localStorage.getItem('records')
            if survivalTime > parseInt records.survivalTime
                records.survivalTime = survivalTime
                thingsToShow[0] += cac.newRecordSpan
            if @killCount > parseInt records.killCount
                records.killCount = @killCount
                thingsToShow[1] += cac.newRecordSpan
            if @score > parseInt records.score
                records.score = @score
                thingsToShow[2] += cac.newRecordSpan
            window.localStorage.setItem 'records', JSON.stringify records
        else
            window.localStorage.setItem 'records', JSON.stringify
                survivalTime: survivalTime
                killCount: @killCount
                score: @score
            thingsToShow = (thing += cac.newRecordSpan for thing in thingsToShow)
        setTimeout(
            () =>
                $('#current-message').remove()
                $('#stats').html(thingsToShow.join('<br>')).parent().add('#created-by').removeClass('hidden')
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
            cac.zombieCanvas.left.clearRect 0, 0, 400, 415
            cac.zombieCanvas.right.clearRect 0, 0, 400, 415
            
            for zombie in @zombies.left
                zombie.redraw() if zombie?
            for zombie in @zombies.right
                zombie.redraw() if zombie?
            
            if @player.isShooting or @player.isReloading or @player.isGettingBitten
                cac.playerCanvasContext.clearRect 0, 0, cac.playerCanvas.width, cac.playerCanvas.height
                @player.updatePosition time
                @player.redraw()
        else
            (zombie.lastFrame = new Date().getTime()) for zombie in @zombies.left
            (zombie.lastFrame = new Date().getTime()) for zombie in @zombies.right
        cac.Utilities.getFrame () => @executeGameLoop()
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