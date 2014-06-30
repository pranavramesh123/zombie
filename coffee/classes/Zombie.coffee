class game.Zombie extends game.Sprite
    constructor: (startingSide, spritesheet, speed, startingLocation = 0) ->
        canvas = document.createElement 'canvas'
        canvas.className = 'zombie-canvas half-canvas ' + startingSide
        canvas.width = 400
        canvas.height = 450
        game.canvasContainer.insertBefore canvas, game.playerCanvas
        super canvas, startingSide
        sprite = new Image()
        sprite.src = spritesheet.src
        @speed = speed
        @currentLocation = startingLocation
        @side = startingSide
        sprite.onload = () =>
            @sprite = sprite
            this.cycleThroughInfiniteFrames(
                @walkingFrames,
                (() =>
                    this.bite() if @currentLocation >= game.Zombie.lungingPoint
                ),
                {speed: @speed, stop: game.Zombie.lungingPoint}
                
            )
        @walkingFrames = spritesheet.walkingFrames
        @dyingFrames = spritesheet.dyingFrames
        @bitingFrames = spritesheet.bitingFrames
    @lungingPoint: 346
    @seeWhoGetsShot: (shotDirection) ->
        return false unless game.zombies[shotDirection].length > 0
        farthestLocation = 0
        for zombie, index in game.zombies[shotDirection]
            thisZombieLocation = zombie.currentLocation + zombie.walkingFrames[zombie.currentFrame].width
            if thisZombieLocation > farthestLocation
                farthestLocation = thisZombieLocation
                doomedZombieIndex = index
        game.zombies[shotDirection][doomedZombieIndex].getShot(doomedZombieIndex) if doomedZombieIndex?
        
    checkIfBeenShot: (shotDirection) ->
        if shotDirection is 'right' and @currentLocation > @canvas.width/2
            this.getShot()
        else if shotDirection is 'left' and @currentLocation < @canvas.width/2
            this.getShot()
        
    getShot: (doomedZombieIndex) ->
        game.updateScore 5
        if game.player.magazine.shells < 1
            game.bonusStats.killsOnOneShell++ 
            if game.bonusStats.killsOnOneShell > 1
                game.updateScore 5
                game.displayMessage game.bonusStats.killsOnOneShell + ' kills on one shell! +10'
        if @currentLocation >= game.Zombie.lungingPoint - 50
            game.updateScore 5
            game.displayMessage 'Close call! +10', 2000, true
        game.updateScoreDisplay()
        if @currentLocation >= game.Zombie.lungingPoint
            game.topCanvas.left.clearRect 0, 0, game.playerCanvas.width/2, game.playerCanvas.height
            game.topCanvas.right.clearRect 0, 0, game.playerCanvas.width/2, game.playerCanvas.height
        @nextAnimation = () =>
            this.cycleThroughFiniteFrames(
                @dyingFrames,
                (() =>
                    game.zombies[@side].splice(doomedZombieIndex, 1)
                    position = @dyingFrames[@dyingFrames.length - 1]
                    game.zombieDeathBed[@side].drawImage(
                        @sprite, position.start.x, position.start.y, position.width, position.height,
                        @currentLocation - position.offset.x, @canvas.height - position.offset.y, position.width, position.height
                    )
                    game.canvasContainer.removeChild(@canvas)
                ),
            )
    bite: () ->
        @nextAnimation = () =>
            this.cycleThroughFiniteFrames(
                @bitingFrames,
                (() =>
                    game.player.getBitten()
                )
            )