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
    scoreDisplay: $('#score')
    killCountDisplay: $('#killcount')
    zombieSprites: []
    jqElements:
        bonusContainer: $('#bonus-container')
        bonusMessage: $('#bonus-message')
        bonus: $('#bonus')
    frameSpeedIndex: 80
    ammoContainer: $('#ammo-container')
    controlKeys:
        shootLeft: 74
        shootRight: 76
        reload: 75
        pause: 32
    images:
        noShell: '/img/noshellicon.png'
        shell: '/img/shellicon.png'
    scorekeeper: new Worker '/js/compiled/workers/scorekeeper.js'
    baseVerticalOffset: 5
    gameInProgress: false
    prepareToStartOver: () ->
        @scoreDisplay.html 0
        @killCountDisplay.html 0
        @ammoContainer.find('img').each () ->
            $(this).removeClass('used').get(0).src = game.images.shell
        @zombieDeathBed.right.clearRect(0, 0, 400, 415)
        @zombieDeathBed.left.clearRect(0, 0, 400, 415)
        @zombieCanvas.right.clearRect(0, 0, 400, 415)
        @zombieCanvas.left.clearRect(0, 0, 400, 415)
        @topCanvas.right.clearRect(0, 0, 400, 415)
        @topCanvas.left.clearRect(0, 0, 400, 415)
        @playerCanvasContext.clearRect(0, 0, 800, 415)

game.zombieCanvas.right.translate game.playerCanvas.width/2, 0
game.zombieCanvas.right.scale -1, 1

game.zombieDeathBed.right.translate game.playerCanvas.width/2, 0
game.zombieDeathBed.right.scale -1, 1

game.topCanvas.right.translate game.playerCanvas.width/2, 0
game.topCanvas.right.scale -1, 1

game.scorekeeper.onmessage = (event) ->
    game.currentGame.updateScore event.data.scoreIncrement
    game.currentGame.updateScoreDisplay()
    game.currentGame.displayMessage(event.data.scoreMessages.join('<br>'), 2000) if event.data.scoreMessages?
    game.currentGame.player.bonusStats = event.data.bonusStats