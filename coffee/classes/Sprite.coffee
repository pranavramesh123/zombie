class game.Sprite

    constructor: (canvas) ->
        @canvas = canvas
        @ctx = @canvas.getContext('2d')
        @animationTimer = new game.Timer()
        @lastFrame = null
        @currentFrame = 0
        @nextAnimation = null
        
    updateLocation: (time, speed) ->
        @currentLocation += speed * ((time - @lastFrame)/1000)
        
    cycleThroughInfiniteFrames: (frameList, motion) ->
        time = new Date().getTime()
        if !@animationTimer.isRunning()
            @animationTimer.start()
            @lastFrame = null
        game.Utilities.getFrame () =>
            if time - @lastFrame >= 100 or @lastFrame is null
                this.updateLocation time, motion.speed if @lastFrame? and motion?
                position = frameList[@currentFrame]
                position.offset = {x: 0, y: position.height} unless position.offset?
                @ctx.clearRect 0, 0, @canvas.width, @canvas.height
                @ctx.drawImage(
                    @sprite, position.start.x, position.start.y, position.width, position.height,
                    @currentLocation - position.offset.x, @canvas.height - position.offset.y, position.width, position.height
                )
                if @currentFrame < frameList.length - 1
                    @currentFrame++
                else
                    @currentFrame = 0
                @lastFrame = time
            if @currentLocation < @canvas.width and @nextAnimation is null
                this.cycleThroughInfiniteFrames(frameList, motion)
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
        if @currentFrame < frameList.length
            game.Utilities.getFrame () =>
                if frameList[@currentFrame].minWaitTime <= time - @lastFrame
                    this.updateLocation time, motion.speed if @lastFrame? and motion?
                    position = frameList[@currentFrame]
                    position.offset = {x: 0, y: position.height} unless position.offset?
                    @ctx.clearRect 0, 0, @canvas.width, @canvas.height
                    if @currentDirection is 'right'
                        adjustedOffset = position.offset.x + 22
                    else
                        adjustedOffset = position.offset.x
                    @ctx.drawImage(
                        @sprite, position.start.x, position.start.y, position.width, position.height,
                        @currentLocation - adjustedOffset, @canvas.height - position.offset.y, position.width, position.height
                    )
                    this[action]() for action in position.actions if position.actions?
                    @lastFrame = time
                    @currentFrame++
                this.cycleThroughFiniteFrames(frameList, callback, motion)
        else
            @currentFrame = 0
            @animationTimer.stop()
            callback() if callback?