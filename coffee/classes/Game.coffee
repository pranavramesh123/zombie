class cac.Game

    constructor: (gofast) ->
        @gofast = gofast
        @nextZombie = null
        @maxNumberOfZombies = 12
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
        @logicInterval = null
        @zombies =
            left: []
            right: []
        @intensityIndex = 1
        if cac.gofast is false
            @speedRange =
                bottom: 90
                top: 110
            @zombieTimeoutBase = 2000
            @zombieTimeoutRange =
                bottom: 600
                top: 1400
        else
            @speedRange =
                bottom: 160
                top: 230
            @zombieTimeoutBase = 1000
            @zombieTimeoutRange =
                bottom: 300
                top: 500
                
    addToKillCount: () ->
        @killCount++
        cac.jqElements.killCountDisplay.html @killCount
        
    updateScore: (addition) ->
        @score += addition
        
    updateScoreDisplay: () ->
        cac.jqElements.scoreDisplay.html @score
        
    generateZombies: () ->
        @nextZombieTimeoutLength = @zombieTimeoutBase - (cac.Utilities.randomIntBetween(@zombieTimeoutRange.bottom, @zombieTimeoutRange.top * @intensityIndex)) if @nextZombieTimeoutLength is null
        @nextZombieTimeoutStart = new Date()
        @nextZombie = setTimeout () =>
            @nextZombieTimeoutLength = null
            comeFrom = if Math.random() >= .5 then 'left' else 'right'
            speed = cac.Utilities.randomIntBetween(@speedRange.bottom, @speedRange.top * @intensityIndex)
            if @zombies['left'].length + @zombies['right'].length < @maxNumberOfZombies
                spriteIndex = Math.floor Math.random() * cac.zombieSprites.length
                @zombies[comeFrom].push new cac.Zombie comeFrom, cac.zombieSprites[spriteIndex], speed, -75
            @intensityIndex += .005
            @generateZombies()
        , @nextZombieTimeoutLength
        
    pause: () ->
        @displayMessage ['Paused', '<span class="sub-message">Hit Space or tap the top bar to unpause</span>']
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
        @player = new cac.Player cac.playerCanvas, 'left', @gofast
        @player.redraw()
        @startTime = new Date()
        cac.gameInProgress = true
        @isActive = true
        @resume()
        @logicInterval = setInterval (() => @executeLogicLoop()), 16
        
    end: (message) ->
        @pause()
        clearInterval @logicInterval
        @isActive = false
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
        try
            if window.localStorage.getItem('records')?
                records = JSON.parse window.localStorage.getItem 'records'
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
        catch
        setTimeout(
            () =>
                $('#current-message').remove()
                $('#stats').html(thingsToShow.join('<br>')).parent().add('#created-by').removeClass('hidden')
                cac.gameInProgress = false
            , 1000
        )
        @player.ctx.restore()
        
    togglePause: ->
        return if @isActive is false
        if @isPaused is true
            @resume()
        else
            @pause()
    
    executeLogicLoop: ->
        if @isPaused is false
            time = new Date().getTime()
            for zombie in @zombies.left
                zombie.updatePosition(time) if zombie?
            for zombie in @zombies.right
                zombie.updatePosition(time) if zombie?
            @player.updatePosition time if @player.isShooting or @player.isReloading or @player.isGettingBitten
        else
            (zombie.lastFrame = new Date().getTime()) for zombie in @zombies.left
            (zombie.lastFrame = new Date().getTime()) for zombie in @zombies.right
            
    executeGameLoop: ->
        cac.zombieCanvasContexts.left.clearRect 0, 0, cac.playerCanvas.width/2, cac.playerCanvas.height
        cac.zombieCanvasContexts.right.clearRect 0, 0, cac.playerCanvas.width/2, cac.playerCanvas.height
        
        cac.topCanvasContexts.left.clearRect 0, 0, cac.playerCanvas.width/2, cac.playerCanvas.height
        cac.topCanvasContexts.right.clearRect 0, 0, cac.playerCanvas.width/2, cac.playerCanvas.height
        
        for zombie in @zombies.left
            zombie.redraw() if zombie?
        for zombie in @zombies.right
            zombie.redraw() if zombie?
        
        cac.playerCanvasContext.clearRect 0, 0, cac.playerCanvas.width, cac.playerCanvas.height
        @player.redraw()
        if @isPaused is false
            cac.Utilities.getFrame => @executeGameLoop()
        
    displayMessage: (message, disappear = null, removeLast = true, size = 'large') ->
        clearTimeout @messageTimeout
        $('#current-message').remove() if removeLast is true
        if typeof message is 'object'
            newMessageContent = message.join '<br>'
        else
            newMessageContent = message
        newMessage = '<div id="current-message" class="zooming ' + size + '">' + newMessageContent + '</div>'
        $('#info').append newMessage
        if disappear? then @messageTimeout = setTimeout (() => $('#current-message').remove()), disappear