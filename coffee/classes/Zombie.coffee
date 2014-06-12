class game.Zombie extends game.Sprite
    constructor: (canvas, spritesheet, speed) ->
        super canvas
        sprite = new Image()
        sprite.src = '../img/' + spritesheet + '.png'
        @speed = speed
        @currentLocation = 0
        sprite.onload = () =>
            @sprite = sprite
            this.cycleThroughInfiniteFrames(@walkingFrames, {speed: @speed})
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
                offset:
                    x: 0
                    y: 144
                start:
                    x: 294
                    y: 0
                width: 90
                height: 144
            },
            {
                minWaitTime: 75
                offset:
                    x: 0
                    y: 144
                start:
                    x: 384
                    y: 0
                width: 84
                height: 144
            },
            {
                minWaitTime: 75
                offset:
                    x: 0
                    y: 144
                start:
                    x: 471
                    y: 0
                width: 135
                height: 144
            },
            {
                minWaitTime: 75
                offset:
                    x: 0
                    y: 144
                start:
                    x: 606
                    y: 0
                width: 162
                height: 144
            }
        ]
            
    checkIfBeenShot: (shotDirection) ->
        if shotDirection is 'right' and @currentLocation > @canvas.width/2
            this.getShot()
        else if shotDirection is 'left' and @currentLocation < @canvas.width/2
            this.getShot()
        
    getShot: () ->
        @currentLocation -= 20
        @nextAnimation = () =>
            console.log 'bull\'s eye'
            this.cycleThroughFiniteFrames @dyingFrames, (() => console.log 'dead'), {speed: -310}