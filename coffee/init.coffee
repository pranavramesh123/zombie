window.game = 
    canvasContainer: document.getElementById 'canvas-container'
    playerCanvas: document.getElementById 'player-canvas'
    topCanvas:
        left: document.getElementById('top-canvas-left').getContext '2d'
        right: document.getElementById('top-canvas-right').getContext '2d'
    zombieDeathBed:
        left: document.getElementById('zombie-deathbed-left').getContext '2d'
        right: document.getElementById('zombie-deathbed-right').getContext '2d'
    nextZombie: null
    isGoing: false
    maxNumberOfZombies: 9
    score: 0
    intensityIndex: 0
    scoreDisplay: $('#score')
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
    shootingSpeed: 500 # original was 600
    reloadSpeed: 300 # original was 375
    generateZombies: () ->
        return if @isGoing is false
        @nextZombie = setTimeout () =>
            comeFrom = if Math.random() >= .5 then 'left' else 'right'
            speed = game.Utilities.randomIntBetween 90, 110
            if game.zombies['left'].length + game.zombies['right'].length < @maxNumberOfZombies
                spriteIndex = Math.floor Math.random() * @zombieSprites.length
                game.zombies[comeFrom].push new game.Zombie comeFrom, @zombieSprites[spriteIndex], speed, -75
            @generateZombies()
        , 2000 - game.Utilities.randomIntBetween(600, 1400)
    stop: () ->
        @isGoing = false
        clearTimeout(@nextZombie)
    start: () ->
        @isGoing = true
        @generateZombies()
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

game.zombieDeathBed.right.translate game.playerCanvas.width/2, 0
game.zombieDeathBed.right.scale -1, 1

game.topCanvas.right.translate game.playerCanvas.width/2, 0
game.topCanvas.right.scale -1, 1

game.scorekeeper.onmessage = (event) ->
    game.updateScore event.data.scoreIncrement
    game.updateScoreDisplay()
    game.displayMessage(event.data.scoreMessage, 2000, true) if event.data.scoreMessage?
    game.player.bonusStats = event.data.bonusStats