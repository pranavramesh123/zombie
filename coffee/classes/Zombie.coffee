class game.Zombie extends game.Sprite
    constructor: (startingSide, spritesheet, speed, startingLocation = 0) ->
        canvas = document.createElement 'canvas'
        canvas.className = 'zombie-canvas ' + startingSide
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
                width: 57
                height: 144
                offset:
                    x: 3
                    y: 144+75
            },
            {
                start:
                    x: 57
                    y: 0
                width: 78
                height: 144
                offset:
                    x: 9
                    y: 144+75
            },
            {
                start:
                    x: 135
                    y: 0
                width: 72
                height: 144
                offset:
                    x: 12
                    y: 144+75
            },
            {
                start:
                    x: 207
                    y: 0
                width: 60
                height: 144
                offset:
                    x: 15
                    y: 144+75
            },
            {
                start:
                    x: 267
                    y: 0
                width: 42
                height: 144
                offset:
                    x: 0
                    y: 144+75
            },
            {
                start:
                    x: 309
                    y: 0
                width: 60
                height: 144
                offset:
                    x: 6
                    y: 144+75
            },
            {
                start:
                    x: 369
                    y: 0
                width: 63
                height: 144
                offset:
                    x: 6
                    y: 144+75
            },
            {
                start:
                    x: 432
                    y: 0
                width: 48
                height: 144
                offset:
                    x: 6
                    y: 144+75
            },
            {
                start:
                    x: 480
                    y: 0
                width: 48
                height: 144
                offset:
                    x: -6
                    y: 144+75
            }
        ]
        @dyingFrames = [
            {
                minWaitTime: 0
                start:
                    x: 528
                    y: 0
                width: 90
                height: 144
                offset:
                    x: 50
                    y: 144+75
            },
            {
                minWaitTime: 60
                start:
                    x: 618
                    y: 0
                width: 84
                height: 144
                offset:
                    x: 100
                    y: 144+75
            },
            {
                minWaitTime: 60
                start:
                    x: 702
                    y: 0
                width: 135
                height: 144
                offset:
                    x: 150
                    y: 144+75
            },
            {
                minWaitTime: 60
                start:
                    x: 837
                    y: 0
                width: 162
                height: 144
                offset:
                    x: 200
                    y: 144+75
            },
            {
                minWaitTime: 60
                start:
                    x: 999
                    y: 0
                width: 162
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
                    x: 1164
                    y: 0
                width: 84
                height: 144
                frontFrame:
                    start:
                        x: 1386
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
                    x: 1251
                    y: 0
                width: 63
                height: 144
                frontFrame:
                    start:
                        x: 1386
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
                    x: 1317
                    y: 0
                width: 60
                height: 144
                frontFrame:
                    start:
                        x: 1386
                        y: 93
                    width: 42
                    height: 45
                    offset:
                        x: -10
                        y: 177
            }
        ]
    @lungingPoint: 350
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