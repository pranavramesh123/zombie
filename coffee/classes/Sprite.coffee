class game.Sprite

    constructor: (canvas, side) ->
        @canvas = canvas
        @ctx = @canvas.getContext('2d')
        if side is 'right'
            @ctx.translate @canvas.width, 0
            @ctx.scale -1, 1
        @animationTimer = new game.Timer()
        @lastFrame = null
        @currentFrame = 0
        @nextAnimation = null
        
    updateLocation: (time, motion) ->
        calculatedDistance = motion.speed * ((time - @lastFrame)/1000)
        actualDistance = if motion.stop? and @currentLocation + calculatedDistance > motion.stop then motion.stop - @currentLocation else calculatedDistance
        @currentLocation += actualDistance
        
    cycleThroughInfiniteFrames: (frameList, callback, motion) ->
        time = new Date().getTime()
        if !@animationTimer.isRunning()
            @animationTimer.start()
            @lastFrame = null
        game.Utilities.getFrame () =>
            minimumFrameTime = if motion? then Math.abs(game.frameSpeedIndex - motion.speed + game.frameSpeedIndex) else 100
            if time - @lastFrame >= minimumFrameTime or @lastFrame is null
                this.updateLocation time, motion if @lastFrame? and motion?
                position = frameList[@currentFrame]
                position.offset = {x: 0, y: position.height + 75} unless position.offset?
                @ctx.clearRect 0, 0, @canvas.width, @canvas.height
                @ctx.drawImage(
                    @sprite, position.start.x, position.start.y, position.width, position.height,
                    @currentLocation - position.offset.x, @canvas.height - position.offset.y, position.width, position.height
                )
                if position.frontFrame?
                    game.topCanvas[@side].clearRect 0, 0, game.topCanvas.width, game.topCanvas.height
                    game.topCanvas[@side].drawImage(
                        @sprite, position.frontFrame.start.x, position.frontFrame.start.y, position.frontFrame.width, position.frontFrame.height,
                        @currentLocation - position.frontFrame.offset.x, @canvas.height - position.frontFrame.offset.y, position.frontFrame.width, position.frontFrame.height
                    )
                if @currentFrame < frameList.length - 1
                    @currentFrame++
                else
                    @currentFrame = 0
                @lastFrame = time
                callback()
            if @currentLocation < @canvas.width and @nextAnimation is null and game.isGoing
                this.cycleThroughInfiniteFrames(frameList, callback, motion)
            else
                @currentFrame = 0
                if @nextAnimation isnt null
                    @nextAnimation()
                    @nextAnimation = null
    cycleThroughFiniteFrames: (frameList, callback, motion) ->
        time = new Date().getTime()
        if !@animationTimer.isRunning()
            @animationTimer.start()
            @lastFrame = time
        if @currentFrame < frameList.length and game.isGoing
            game.Utilities.getFrame () =>
                if frameList[@currentFrame].minWaitTime <= time - @lastFrame
                    position = frameList[@currentFrame]
                    position.offset = {x: 0, y: position.height + 75} unless position.offset?
                    @ctx.clearRect 0, 0, @canvas.width, @canvas.height
                    this.updateLocation time, motion if @lastFrame? and motion?
                    @ctx.drawImage(
                        @sprite, position.start.x, position.start.y, position.width, position.height,
                        @currentLocation - position.offset.x, @canvas.height - position.offset.y, position.width, position.height
                    )
                    if position.frontFrame?
                        game.topCanvas[@side].clearRect 0, 0, game.topCanvas.width, game.topCanvas.height
                        game.topCanvas[@side].drawImage(
                            @sprite, position.frontFrame.start.x, position.frontFrame.start.y, position.frontFrame.width, position.frontFrame.height,
                            @currentLocation - position.frontFrame.offset.x, @canvas.height - position.frontFrame.offset.y, position.frontFrame.width, position.frontFrame.height
                        )
                    this[action]() for action in position.actions if position.actions?
                    @lastFrame = time
                    @currentFrame++
                this.cycleThroughFiniteFrames(frameList, callback, motion)
        else
            @currentFrame = 0
            @animationTimer.stop()
            callback() if callback?