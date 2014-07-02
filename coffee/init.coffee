window.game = 
    canvasContainer: document.getElementById 'canvas-container'
    playerCanvas: document.getElementById 'player-canvas'
    playerCanvasContext: document.getElementById('player-canvas').getContext '2d'
    topCanvas:
        left: document.getElementById('top-canvas-left').getContext '2d'
        right: document.getElementById('top-canvas-right').getContext '2d'
    zombieCanvas:
        left: document.getElementById('zombie-canvas-left').getContext '2d'
        right: document.getElementById('zombie-canvas-right').getContext '2d'
    zombieDeathBed:
        left: document.getElementById('zombie-deathbed-left').getContext '2d'
        right: document.getElementById('zombie-deathbed-right').getContext '2d'
    nextZombie: null
    isGoing: false
    maxNumberOfZombies: 9
    score: 0
    intensityIndex: 0
    scoreDisplay: $('#score')
    killCountDisplay: $('#killcount')
    killCount: 0
    addToKillCount: () ->
        @killCount++
        @killCountDisplay.html(@killCount)
    jqElements:
        bonusContainer: $('#bonus-container')
        bonusMessage: $('#bonus-message')
        bonus: $('#bonus')
    updateScore: (addition) ->
        @score += addition
    updateScoreDisplay: () ->
        @scoreDisplay.html @score
    frameSpeedIndex: 80
    ammoContainer: $('#ammo-container')
    reloadButton: $('#reload')
    controlKeys:
        shootLeft: 74
        shootRight: 76
        reload: 75
    images:
        noShell: '/img/noshellicon.png'
        shell: '/img/shellicon.png'
    zombieSprites: []
    shootingSpeed: 450 # original was 600
    reloadSpeed: 275 # original was 375
    nextZombieTimeoutLength: null
    nextZombieTimeoutStart: null
    generateZombies: () ->
        return if @isGoing is false
        @nextZombieTimeoutLength = 2000 - game.Utilities.randomIntBetween(600, 1400) if @nextZombieTimeoutLength is null
        @nextZombieTimeoutStart = new Date()
        @nextZombie = setTimeout () =>
            @nextZombieTimeoutLength = null
            comeFrom = if Math.random() >= .5 then 'left' else 'right'
            speed = game.Utilities.randomIntBetween 90, 110
            if game.zombies['left'].length + game.zombies['right'].length < @maxNumberOfZombies
                spriteIndex = Math.floor Math.random() * @zombieSprites.length
                game.zombies[comeFrom].push new game.Zombie comeFrom, @zombieSprites[spriteIndex], speed, -75
            @generateZombies()
        , @nextZombieTimeoutLength
    stop: () ->
        @isGoing = false
        @isPaused = true
        clearTimeout @nextZombie
        @nextZombieTimeoutLength -= new Date() - @nextZombieTimeoutStart
    start: () ->
        @isGoing = true
        @isPaused = false
        @generateZombies()
        @executeGameLoop()
    currentGameFrame: null
    togglePause: () ->
        if @isPaused is true
            game.start()
        else
            game.stop()
    isPaused: true
    lastFrame: null
    executeGameLoop: () ->
        if @isPaused is false
            time = new Date().getTime()
            for zombie in @zombies.left
                zombie.updatePosition(time) if zombie?
            for zombie in @zombies.right
                zombie.updatePosition(time) if zombie?
            @zombieCanvas.left.clearRect 0, 0, 400, 415
            @zombieCanvas.right.clearRect 0, 0, 400, 415
            
            for zombie in @zombies.left
                zombie.redraw() if zombie?
            for zombie in @zombies.right
                zombie.redraw() if zombie?
            
            if game.player.isShooting or game.player.isReloading
                @playerCanvasContext.clearRect 0, 0, @playerCanvas.width, @playerCanvas.height
                game.player.updatePosition time
                game.player.redraw()
        else
            (zombie.lastFrame = new Date().getTime()) for zombie in @zombies.left
            (zombie.lastFrame = new Date().getTime()) for zombie in @zombies.right
        game.Utilities.getFrame () => @executeGameLoop()
        
    messageTimeout: null
    displayMessage: (message, disappear = null, pulsating = false) ->
        clearTimeout @messageTimeout
        $('#current-message').remove()
        newMessageElement = document.createElement 'div'
        newMessageElement.className = 'zooming'
        newMessageElement.id = 'current-message'
        newMessageElement.innerHTML = message
        document.getElementById('info').appendChild(newMessageElement)
        if disappear? then @messageTimeout = setTimeout (() => $('#current-message').remove()), disappear
    scorekeeper: new Worker '/js/compiled/workers/scorekeeper.js'
    baseVerticalOffset: 5

game.zombieCanvas.right.translate game.playerCanvas.width/2, 0
game.zombieCanvas.right.scale -1, 1

game.zombieDeathBed.right.translate game.playerCanvas.width/2, 0
game.zombieDeathBed.right.scale -1, 1

game.topCanvas.right.translate game.playerCanvas.width/2, 0
game.topCanvas.right.scale -1, 1

game.zombieCanvas.left.fillStyle = '#F5F5F5'
game.zombieCanvas.right.fillStyle = '#F5F5F5'

game.scorekeeper.onmessage = (event) ->
    game.updateScore event.data.scoreIncrement
    game.updateScoreDisplay()
    game.displayMessage(event.data.scoreMessages.join('<br>'), 2000, true) if event.data.scoreMessages?
    game.player.bonusStats = event.data.bonusStats