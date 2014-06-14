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
    updateScore: (addition) ->
        @score += addition
        @scoreDisplay.html @score
    frameSpeedIndex: 87
    ammoContainer: $('#ammo-container')
    images:
        noShell: '/img/noshellicon.png'
        shell: '/img/shellicon.png'
    zombieSprites: [
        #'suit-blue'
        #'suit-grey'
        'newwalk'
    ]
    generateZombies: () ->
        return if @isGoing is false
        @nextZombie = setTimeout () =>
            comeFrom = if Math.random() >= .5 then 'left' else 'right'
            speed = Math.random() * 100 + 60
            if game.zombies['left'].length + game.zombies['right'].length < @maxNumberOfZombies
                spriteIndex = Math.floor Math.random() * @zombieSprites.length
                game.zombies[comeFrom].push new game.Zombie comeFrom, @zombieSprites[spriteIndex], speed, -75
            @generateZombies()
        , 2000 - Math.random() * 900 + @intensityIndex
    stop: () ->
        @isGoing = false
        clearTimeout(@nextZombie)
    start: () ->
        @isGoing = true
        @generateZombies()
    displayMessage: (message, disappear = null) ->
        messageElement = document.getElementById('message')
        messageElement.innerHTML = message
        if disappear? then setTimeout (() -> messageElement.innerHTML = ''), disappear
        
game.zombieDeathBed.right.translate game.playerCanvas.width/2, 0
game.zombieDeathBed.right.scale -1, 1

game.topCanvas.right.translate game.playerCanvas.width/2, 0
game.topCanvas.right.scale -1, 1
