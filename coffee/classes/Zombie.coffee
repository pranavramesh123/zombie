class game.Zombie extends game.Sprite
    constructor: (startingSide, spritesheet, speed, startingLocation = 0) ->
        canvas = document.createElement 'canvas'
        canvas.className = 'zombie-canvas half-canvas ' + startingSide
        canvas.width = 400
        canvas.height = 450
        game.canvasContainer.insertBefore canvas, game.playerCanvas
        super canvas, startingSide
        sprite = new Image()
        sprite.src = '../img/spritesheets/zombies/' + spritesheet + '.png'
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
        @walkingFrames = [
            {
                start:
                    x: 0
                    y: 0
                width: 72
                height: 144
            },
            {
                start:
                    x: 73
                    y: 0
                width: 86
                height: 144
            },
            {
                start:
                    x: 160
                    y: 0
                width: 77
                height: 144
            },
            {
                start:
                    x: 238
                    y: 0
                width: 62
                height: 144
            },
            {
                start:
                    x: 301
                    y: 0
                width: 59
                height: 144
            },
            {
                start:
                    x: 361
                    y: 0
                width: 71
                height: 144
            },
            {
                start:
                    x: 433
                    y: 0
                width: 74
                height: 144
            },
            {
                start:
                    x: 508
                    y: 0
                width: 59
                height: 144
            },
            {
                start:
                    x: 568
                    y: 0
                width: 65
                height: 144
            }
        ]
        @dyingFrames = [
            {
                minWaitTime: 0
                start:
                    x: 634
                    y: 0
                width: 92
                height: 144
                offset:
                    x: 50
                    y: 144+75
            },
            {
                minWaitTime: 60
                start:
                    x: 727
                    y: 0
                width: 86
                height: 144
                offset:
                    x: 100
                    y: 144+75
            },
            {
                minWaitTime: 60
                start:
                    x: 814
                    y: 0
                width: 137
                height: 144
                offset:
                    x: 150
                    y: 144+75
            },
            {
                minWaitTime: 60
                start:
                    x: 952
                    y: 0
                width: 164
                height: 144
                offset:
                    x: 200
                    y: 144+75
            },
            {
                minWaitTime: 60
                start:
                    x: 1117
                    y: 0
                width: 164
                height: 144
                offset:
                    x: 200
                    y: 144+75
            }
        ]
        @bitingFrames = [
            {
                minWaitTime: 0
                start:
                    x: 1282
                    y: 0
                width: 86
                height: 144
                frontFrame:
                    start:
                        x: 1509
                        y: 117
                    width: 42
                    height: 27
                    offset:
                        x: -10
                        y: 153
            },
            {
                minWaitTime: 75
                start:
                    x: 1369
                    y: 0
                width: 65
                height: 144
                frontFrame:
                    start:
                        x: 1509
                        y: 117
                    width: 42
                    height: 27
                    offset:
                        x: -10
                        y: 153
            },
            {
                minWaitTime: 75
                start:
                    x: 1435
                    y: 0
                width: 62
                height: 144
                frontFrame:
                    start:
                        x: 1509
                        y: 93
                    width: 42
                    height: 45
                    offset:
                        x: -10
                        y: 177
            }
        ]
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
            game.displayMessage 'Close call! +10', 2000
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