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
                width: 60
                height: 144
            },
            {
                start:
                    x: 60
                    y: 0
                width: 55
                height: 144
            },
            {
                start:
                    x: 114
                    y: 0
                width: 60
                height: 144
            },
            {
                start:
                    x: 174
                    y: 0
                width: 66
                height: 144
            },
            {
                start:
                    x: 240
                    y: 0
                width: 54
                height: 144
            }
        ]
        @dyingFrames = [
            {
                minWaitTime: 0
                start:
                    x: 294
                    y: 0
                width: 90
                height: 144
            },
            {
                minWaitTime: 75
                start:
                    x: 384
                    y: 0
                width: 84
                height: 144
            },
            {
                minWaitTime: 75
                start:
                    x: 471
                    y: 0
                width: 135
                height: 144
            },
            {
                minWaitTime: 75
                start:
                    x: 606
                    y: 0
                width: 162
                height: 144
            }
        ]
        @bitingFrames = [
            {
                minWaitTime: 0
                start:
                    x: 768
                    y: 0
                width: 87
                height: 144
                frontFrame:
                    start:
                        x: 990
                        y: 117
                    width: 45
                    height: 27
                    offset:
                        x: -15
                        y: 153
            },
            {
                minWaitTime: 75
                start:
                    x: 855
                    y: 0
                width: 66
                height: 144
                frontFrame:
                    start:
                        x: 990
                        y: 117
                    width: 45
                    height: 27
                    offset:
                        x: -15
                        y: 153
            },
            {
                minWaitTime: 75
                start:
                    x: 921
                    y: 0
                width: 63
                height: 144
                frontFrame:
                    start:
                        x: 990
                        y: 117
                    width: 45
                    height: 27
                    offset:
                        x: -15
                        y: 153
            }
        ]
    @lungingPoint: 340
    @seeWhoGetsShot: (shotDirection) ->
        return false unless game.zombies[shotDirection].length > 0
        farthestLocation = 0
        for zombie, index in game.zombies[shotDirection]
            thisZombieLocation = zombie.currentLocation + zombie.walkingFrames[zombie.currentFrame].width
            if thisZombieLocation > farthestLocation
                farthestLocation = thisZombieLocation
                doomedZombieIndex = index
        console.log 'Index ' + doomedZombieIndex + ' is getting shot...'
        game.zombies[shotDirection][doomedZombieIndex].getShot(doomedZombieIndex) if doomedZombieIndex?
        
    checkIfBeenShot: (shotDirection) ->
        if shotDirection is 'right' and @currentLocation > @canvas.width/2
            this.getShot()
        else if shotDirection is 'left' and @currentLocation < @canvas.width/2
            this.getShot()
        
    getShot: (doomedZombieIndex) ->
        game.updateScore 5
        @currentLocation -= 20
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
                {speed: -350}
            )
    bite: () ->
        @nextAnimation = () =>
            this.cycleThroughFiniteFrames(
                @bitingFrames,
                (() =>
                    game.stop()
                    game.displayMessage 'You have been bitten.'
                )
            )