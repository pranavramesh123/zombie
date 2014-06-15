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
    bonusStats:
        killsOnOneShell: 0
    updateScore: (addition) ->
        @score += addition
    updateScoreDisplay: () ->
        @scoreDisplay.html @score
    frameSpeedIndex: 80
    ammoContainer: $('#ammo-container')
    images:
        noShell: '/img/noshellicon.png'
        shell: '/img/shellicon.png'
    zombieSprites: [
        #'suit-blue'
        #'suit-grey'
        'newerwalk'
    ]
    shootingSpeed: 550 # 600
    reloadSpeed: 350 # 375
    generateZombies: () ->
        return if @isGoing is false
        @nextZombie = setTimeout () =>
            comeFrom = if Math.random() >= .5 then 'left' else 'right'
            speed = Math.floor(Math.random() * 50) + 70
            if game.zombies['left'].length + game.zombies['right'].length < @maxNumberOfZombies
                spriteIndex = Math.floor Math.random() * @zombieSprites.length
                game.zombies[comeFrom].push new game.Zombie comeFrom, @zombieSprites[spriteIndex], speed, -75
            @generateZombies()
        , 2000 - Math.random() * 1450 + @intensityIndex
    stop: () ->
        @isGoing = false
        clearTimeout(@nextZombie)
    start: () ->
        @isGoing = true
        @generateZombies()
    messageElement: document.getElementById('game-message')
    displayMessage: (message, disappear = null) ->
        @messageElement.innerHTML = message
        if disappear? then setTimeout (() => @messageElement.innerHTML = ''), disappear
        
game.zombieDeathBed.right.translate game.playerCanvas.width/2, 0
game.zombieDeathBed.right.scale -1, 1

game.topCanvas.right.translate game.playerCanvas.width/2, 0
game.topCanvas.right.scale -1, 1
