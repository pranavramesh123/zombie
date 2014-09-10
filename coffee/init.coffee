#   Copyright (C) 2014 Greg Weston
#   
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

window.cac = 
    canvasContainer: document.getElementById 'canvas-container'
    playerCanvas: document.getElementById 'player-canvas'
    playerCanvasContext: document.getElementById('player-canvas').getContext '2d'
    topCanvasContexts:
        left: document.getElementById('top-canvas-left').getContext '2d'
        right: document.getElementById('top-canvas-right').getContext '2d'
    zombieCanvasContexts:
        left: document.getElementById('zombie-canvas-left').getContext '2d'
        right: document.getElementById('zombie-canvas-right').getContext '2d'
    zombieGraveyardContexts:
        left: document.getElementById('zombie-graveyard-left').getContext '2d'
        right: document.getElementById('zombie-graveyard-right').getContext '2d'
    zombieSprites: []
    jqElements:
        bonusContainer: $('#bonus-container')
        bonusMessage: $('#bonus-message')
        bonus: $('#bonus')
        killCountDisplay: $('#killcount')
        scoreDisplay: $('#score')
        ammoContainer: $('#ammo-container')
        loadingProgressBar: $('#loading-progress')
    frameSpeedIndex: 80 # Used to calculate time between sprite frames, based on speed
    controlKeys:
        shootLeft: 37 # Left arrow
        shootRight: 39 # Right arrow
        reload: 40 # Down arrow
        pause: 32 # Spacebar
    newRecordSpan: '<span class="new-record">New Record!</span>'
    reloadRange: 60
    images:
        noShell: '/img/noshellicon.png'
        shell: '/img/shellicon.png'
    scorekeeper: new Worker '/js/compiled/workers/scorekeeper.js'
    baseVerticalOffset: 5 # For spritesheet coordinates
    gameInProgress: false
    prepareToStartOver: () ->
        @jqElements.scoreDisplay.html 0
        @jqElements.killCountDisplay.html 0
        @jqElements.ammoContainer.find('img').each () ->
            $(this).removeClass('used').get(0).src = cac.images.shell
        @zombieGraveyardContexts.right.clearRect(0, 0, @playerCanvas.width/2, @playerCanvas.height)
        @zombieGraveyardContexts.left.clearRect(0, 0, @playerCanvas.width/2, @playerCanvas.height)
        @zombieCanvasContexts.right.clearRect(0, 0, @playerCanvas.width/2, @playerCanvas.height)
        @zombieCanvasContexts.left.clearRect(0, 0, @playerCanvas.width/2, @playerCanvas.height)
        @topCanvasContexts.right.clearRect(0, 0, @playerCanvas.width/2, @playerCanvas.height)
        @topCanvasContexts.left.clearRect(0, 0, @playerCanvas.width/2, @playerCanvas.height)
        @playerCanvasContext.clearRect(0, 0, @playerCanvas.width, @playerCanvas.height)
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
    playerSprite: null
    spritesLoaded: 0
    loadSprite: (url) ->
        img = new Image()
        img.src = url
        img.onload = () ->
            cac.spritesLoaded++
            if this.src.indexOf("/img/spritesheets/player.png") isnt -1
                cac.playerSprite = this
                cac.playerCanvasContext.drawImage this, 129, 0, 75, 126, cac.playerCanvas.width/2 - 51, cac.playerCanvas.height - (126 + cac.baseVerticalOffset), 75, 126
    loadSprites: () ->
        if cac.spritesLoaded < cac.allSprites.length
            cac.loadSprite cac.allSprites[cac.spritesLoaded]
        return (cac.spritesLoaded/cac.allSprites.length) * 100
    spriteLoadingInterval: null
    gofast: false

# Load all sprites, and display progress in loading bar.
cac.spriteLoadingInterval = setInterval () ->
    progress = cac.loadSprites()
    if progress >= 100
        $('.show-when-ready').removeClass 'hidden'
        $('.hide-when-ready').addClass 'hidden'
        cac.readyToStart = true
        return clearInterval cac.spriteLoadingInterval
    cac.jqElements.loadingProgressBar.css 'width', progress + '%'
, 16

# Horizontally mirroring the "right" side canvases. This is done so that the same code and sprites can be used
# for zombies approaching from either side.
cac.zombieCanvasContexts.right.translate cac.playerCanvas.width/2, 0
cac.zombieCanvasContexts.right.scale -1, 1
cac.zombieGraveyardContexts.right.translate cac.playerCanvas.width/2, 0
cac.zombieGraveyardContexts.right.scale -1, 1
cac.topCanvasContexts.right.translate cac.playerCanvas.width/2, 0
cac.topCanvasContexts.right.scale -1, 1

# React after the "scorekeeper" worker calculates a score change.
cac.scorekeeper.onmessage = (event) ->
    cac.currentGame.updateScore event.data.scoreIncrement
    cac.currentGame.updateScoreDisplay()
    cac.currentGame.displayMessage(event.data.scoreMessages.join('<br>'), 2000) if event.data.scoreMessages? and event.data.scoreMessages.length > 0
    cac.currentGame.player.bonusStats = event.data.bonusStats

# Draw the background
background = document.getElementById 'background'
bgctx = background.getContext '2d'
backgroundScene = new Image()
backgroundScene.src = '/img/background.png'
backgroundScene.onload = ->
    bgctx.drawImage(backgroundScene, 0, 0)
    
