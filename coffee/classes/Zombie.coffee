class game.Zombie extends game.Sprite
    constructor: (startingSide, spritesheet, speed, startingLocation = 0) ->
        canvas = document.getElementById('zombie-canvas-' + startingSide)
        super canvas, startingSide
        sprite = new Image()
        randomIndex = Math.floor Math.random() * spritesheet.src.length
        sprite.src = spritesheet.src[randomIndex]
        @speed = speed
        @currentLocation = startingLocation
        @side = startingSide
        @lungingPoint = 346
        @walkingFrames = spritesheet.walkingFrames
        @dyingFrames = spritesheet.dyingFrames
        @bitingFrames = spritesheet.bitingFrames
        @animationLooping = true
        @animationLoopCallback = () => this.bite() if @currentLocation >= @lungingPoint and @isBiting is false
        @index = null
        @isBiting = false
        sprite.onload = () =>
            @sprite = sprite
            @currentFrameList = @walkingFrames
    @seeWhoGetsShot: (shotDirection) ->
        return false unless game.currentGame.zombies[shotDirection].length > 0
        farthestLocation = 0
        for zombie, index in game.currentGame.zombies[shotDirection]
            thisZombieLocation = zombie.currentLocation + zombie.walkingFrames[zombie.currentFrame].width
            if thisZombieLocation > farthestLocation
                farthestLocation = thisZombieLocation
                doomedZombieIndex = index
        if doomedZombieIndex?
            game.currentGame.zombies[shotDirection][doomedZombieIndex].index = doomedZombieIndex
            game.currentGame.zombies[shotDirection][doomedZombieIndex].getShot()
        
    checkIfBeenShot: (shotDirection) ->
        if shotDirection is 'right' and @currentLocation > @canvas.width/2
            this.getShot()
        else if shotDirection is 'left' and @currentLocation < @canvas.width/2
            this.getShot()
        
    getShot: (doomedZombieIndex) ->
        game.currentGame.addToKillCount()
        game.scorekeeper.postMessage(
            player: JSON.stringify({
                bonusStats: game.currentGame.player.bonusStats
                currentDirection: game.currentGame.player.currentDirection
                magazine: game.currentGame.player.magazine
            })
            zombie: JSON.stringify({
                currentLocation: @currentLocation
                lungingPoint: @lungingPoint
                side: @side
                speed: @speed
            })
            killTime: new Date().getTime()
        )
        if @currentLocation >= @lungingPoint
            game.topCanvas.left.clearRect 0, 0, game.playerCanvas.width/2, game.playerCanvas.height
            game.topCanvas.right.clearRect 0, 0, game.playerCanvas.width/2, game.playerCanvas.height
        @speed = 0
        @animationLooping = false
        @currentFrame = 0
        @currentFrameList = @dyingFrames
        @animationEndCallback = () => this.die()
    die: () ->
        game.currentGame.zombies[@side].splice(@index, 1)
        position = @dyingFrames[@dyingFrames.length - 1]
        game.zombieDeathBed[@side].drawImage(
            @sprite, position.start.x, position.start.y, position.width, position.height,
            @currentLocation - position.offset.x, @canvas.height - position.offset.y, position.width, position.height
        )
    bite: () ->
        @isBiting = true
        @speed = 0
        @animationLooping = false
        @currentFrame = 0
        @currentFrameList = @bitingFrames
        @animationEndCallback = () -> game.currentGame.player.getBitten()