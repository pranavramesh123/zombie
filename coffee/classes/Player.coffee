class game.Player extends game.Sprite
    constructor: (canvas, startingSide) ->
        super canvas, startingSide
        sprite = new Image()
        sprite.src = '../img/firstsheet.png'
        @currentDirection = 'left'
        @currentLocation = @canvas.width/2
        sprite.onload = () =>
            @sprite = sprite
            @ctx.drawImage sprite, 129, 0, 75, 126, canvas.width/2 - 51, canvas.height - 201, 75, 126
        @isShooting = false
        @isReloading = false
        @nextAnimation = null
        @shootingFrames = [
            {
                minWaitTime: 0
                start:
                    x: 42
                    y: 0
                width: 87
                height: 126
                offset:
                    x: 69
                    y: 201
            },
            {
                minWaitTime: 100
                actions: ['fire']
                start:
                    x: 411
                    y: 0
                width: 114
                height: 126
                offset:
                    x: 93
                    y: 201
            },
            {
                minWaitTime: 100
                start:
                    x: 42
                    y: 0
                width: 87
                height: 126
                offset:
                    x: 69
                    y: 201
            },
            {
                minWaitTime: 200
                start:
                    x: 129
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 51
                    y: 201
            },
            {
                minWaitTime: 75
                start:
                    x: 204
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 51
                    y: 201
            },
            {
                minWaitTime: 125
                start:
                    x: 129
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 51
                    y: 201
            }
        ]
        @reloadingFrames = [
            {
                minWaitTime: 0
                start:
                    x: 279
                    y: 0
                width: 48
                height: 126
                offset:
                    x: 27
                    y: 201
            },
            {
                minWaitTime: 125
                start:
                    x: 327
                    y: 0
                width: 45
                height: 126
                offset:
                    x: 24
                    y: 201
            },
            {
                minWaitTime: 125
                actions: ['loadShell']
                start:
                    x: 372
                    y: 0
                width: 39
                height: 126
                offset:
                    x: 18
                    y: 201
            },
            {
                minWaitTime: 125
                start:
                    x: 129
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 51
                    y: 201
            }
        ]
        @currentFrame = 0
        @magazine =
            shells: 6
            capacity: 6
    fire: () ->
        @magazine.shells--
        $('#ammo img:not(.used)').first().addClass('used').get(0).src = '/img/noshellicon.png'
        game.Zombie.seeWhoGetsShot(@currentDirection)
    loadShell: () ->
        @magazine.shells++
        $('#ammo img.used').last().removeClass('used').get(0).src = '/img/shellicon.png'
    shoot: (direction) ->
        if direction is 'right' and @currentDirection is 'left'
            @ctx.save()
            @ctx.translate @canvas.width, 0
            @ctx.scale -1, 1
            @currentDirection = 'right'
        else if direction is 'left' and @currentDirection is 'right'
            @ctx.restore()
            @currentDirection = 'left'
        @isShooting = true
        this.cycleThroughFiniteFrames @shootingFrames, () => @isShooting = false
    reload: () ->
        @isReloading = true
        this.cycleThroughFiniteFrames @reloadingFrames, () => @isReloading = false