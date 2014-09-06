class cac.Player extends cac.Sprite
    constructor: (canvas, startingSide, gofast) ->
        super canvas, startingSide
        @gofast = gofast
        @currentDirection = 'left'
        @currentLocation = @canvas.width/2
        @sprite = cac.playerSprite
        @ctx.drawImage @sprite, 525, 0, 75, 126, canvas.width/2 - 51, canvas.height - (126 + cac.baseVerticalOffset), 75, 126
        @isShooting = false
        @isReloading = false
        @isGettingBitten = false
        @killCount = 0
        @bonusStats =
            killsOnOneShell: 0
            killLog: []
        @shootingSpeed = if @gofast is false then 450 else 215
        @reloadSpeed = if @gofast is false then 275 else 120
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
                    y: 126 + cac.baseVerticalOffset
            },
            {
                minWaitTime: @shootingSpeed/5
                actions: ['fire']
                start:
                    x: 411
                    y: 0
                width: 114
                height: 126
                offset:
                    x: 93
                    y: 126 + cac.baseVerticalOffset
            },
            {
                minWaitTime: @shootingSpeed/5
                start:
                    x: 42
                    y: 0
                width: 87
                height: 126
                offset:
                    x: 69
                    y: 126 + cac.baseVerticalOffset
            },
            {
                minWaitTime: @shootingSpeed/5
                start:
                    x: 129
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 51
                    y: 126 + cac.baseVerticalOffset
            },
            {
                minWaitTime: @shootingSpeed/5
                start:
                    x: 204
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 51
                    y: 126 + cac.baseVerticalOffset
            },
            {
                last: true
                minWaitTime: @shootingSpeed/5
                start:
                    x: 129
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 51
                    y: 126 + cac.baseVerticalOffset
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
                    y: 126 + cac.baseVerticalOffset
            },
            {
                minWaitTime: @reloadSpeed/3
                start:
                    x: 327
                    y: 0
                width: 45
                height: 126
                offset:
                    x: 24
                    y: 126 + cac.baseVerticalOffset
            },
            {
                minWaitTime: @reloadSpeed/3
                actions: ['loadShell']
                start:
                    x: 372
                    y: 0
                width: 39
                height: 126
                offset:
                    x: 18
                    y: 126 + cac.baseVerticalOffset
            },
            {
                last: true
                minWaitTime: @reloadSpeed/3
                start:
                    x: 129
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 51
                    y: 126 + cac.baseVerticalOffset
            }
        ]
        @bittenFrames = [
            {
                last: true
                minWaitTime: 0
                start:
                    x: 600
                    y: 0
                width: 84
                height: 126
                offset:
                    x: 39
                    y: 126 + cac.baseVerticalOffset
            }    
        ]
        @currentFrame = 5
        @currentFrameList = @shootingFrames
        @position = @currentFrameList[@currentFrame]
        @magazine =
            shells: 6
            capacity: 6
    fire: () ->
        @magazine.shells--
        cac.ammoContainer.find('img:not(.used)').first().addClass('used').get(0).src = cac.images.noShell
        cac.Zombie.seeWhoGetsShot(@currentDirection)
    loadShell: () ->
        @magazine.shells++
        cac.ammoContainer.find('img.used').last().removeClass('used').get(0).src = cac.images.shell
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
        @currentFrame = 0
        @currentFrameList = @shootingFrames
        @speed = 0
        @animationLooping = false
        @animationEndCallback = () => @isShooting = false
    reload: () ->
        @isReloading = true
        @currentFrame = 0
        @currentFrameList = @reloadingFrames
        @speed = 0
        @animationLooping = false
        @animationEndCallback = () => @isReloading = false
    @bittenCallback: () ->
        cac.currentGame.end 'You have been bitten.'
    getBitten: () ->
        @isGettingBitten = true
        @currentFrame = 0
        @currentFrameList = @bittenFrames
        @speed = 0
        @animationLooping = false
        @animationEndCallback = cac.Player.bittenCallback