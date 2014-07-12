window.cac = 
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
    reloadRange: 60
    newRecordSpan: '<span class="new-record">New Record!</span>'
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
            $(this).removeClass('used').get(0).src = cac.images.shell
        @zombieDeathBed.right.clearRect(0, 0, 400, 415)
        @zombieDeathBed.left.clearRect(0, 0, 400, 415)
        @zombieCanvas.right.clearRect(0, 0, 400, 415)
        @zombieCanvas.left.clearRect(0, 0, 400, 415)
        @topCanvas.right.clearRect(0, 0, 400, 415)
        @topCanvas.left.clearRect(0, 0, 400, 415)
        @playerCanvasContext.clearRect(0, 0, 800, 415)
    readyToStart: false
    allSprites: [
        "/img/spritesheets/player.png",
        "/img/spritesheets/zombies/afrobeard-black.png",
        "/img/spritesheets/zombies/afrobeard-grey.png",
        "/img/spritesheets/zombies/beater-white.png",
        "/img/spritesheets/zombies/beater-black.png",
        "/img/spritesheets/zombies/dress-yellow.png",
        "/img/spritesheets/zombies/dress-blue.png",
        "/img/spritesheets/zombies/suit-blue.png",
        "/img/spritesheets/zombies/suit-brown.png",
        "/img/spritesheets/zombies/tee-grey.png",
        "/img/spritesheets/zombies/tee-none.png"
    ]
    spritesLoaded: 0
    loadSprite: (url) ->
        img = new Image()
        img.src = url
        img.onload = () ->
            cac.spritesLoaded++
    loadSprites: () ->
        if cac.spritesLoaded < cac.allSprites.length
            cac.loadSprite cac.allSprites[cac.spritesLoaded]
        return (cac.spritesLoaded/cac.allSprites.length) * 100
    spriteLoadingInterval: null
    loadingProgressBar: $('#loading-progress')
    
cac.spriteLoadingInterval = setInterval () ->
    progress = cac.loadSprites()
    if progress >= 100
        $('.show-when-ready').removeClass('hidden')
        $('.hide-when-ready').addClass('hidden')
        cac.readyToStart = true
        return clearInterval cac.spriteLoadingInterval
    cac.loadingProgressBar.css 'width', progress + '%'
, 16

cac.zombieCanvas.right.translate cac.playerCanvas.width/2, 0
cac.zombieCanvas.right.scale -1, 1

cac.zombieDeathBed.right.translate cac.playerCanvas.width/2, 0
cac.zombieDeathBed.right.scale -1, 1

cac.topCanvas.right.translate cac.playerCanvas.width/2, 0
cac.topCanvas.right.scale -1, 1

cac.scorekeeper.onmessage = (event) ->
    cac.currentGame.updateScore event.data.scoreIncrement
    cac.currentGame.updateScoreDisplay()
    cac.currentGame.displayMessage(event.data.scoreMessages.join('<br>'), 2000) if event.data.scoreMessages?
    cac.currentGame.player.bonusStats = event.data.bonusStats
    
