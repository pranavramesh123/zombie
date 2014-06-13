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
    generateZombies: () ->
        randomNum = Math.random()
        return if @isGoing is false
        @nextZombie = setTimeout () =>
            comeFrom = if randomNum >= .5 then 'left' else 'right'
            speed = randomNum * 100 + 25
            game.zombies[comeFrom].push new game.Zombie comeFrom, 'firstzombie', speed, -75
            @generateZombies()
        , 2000 - randomNum * 700
    stop: () ->
        @isGoing = false
        clearTimeout(@nextZombie)
    start: () ->
        @isGoing = true
        @generateZombies()
        
game.zombieDeathBed.right.translate game.playerCanvas.width/2, 0
game.zombieDeathBed.right.scale -1, 1

game.topCanvas.right.translate game.playerCanvas.width/2, 0
game.topCanvas.right.scale -1, 1
