class game.Sprite

    constructor: (canvas, side) ->
        @canvas = canvas
        @ctx = @canvas.getContext('2d')
        @animationTimer = new game.Timer()
        @currentFrame = 0
        @nextAnimation = null
        
    updateLocation: (time) ->
        calculatedDistance = @speed * ((time - game.lastFrame)/1000)
        actualDistance = if @lungingPoint? and @currentLocation + calculatedDistance > @lungingPoint then @lungingPoint - @currentLocation else calculatedDistance
        @currentLocation += actualDistance
    
    redraw: (time) ->
        return if @currentFrameList? is false
        minimumFrameTime = if @speed? then Math.abs(game.frameSpeedIndex - @speed + game.frameSpeedIndex) else 100
        if time - game.lastFrame >= minimumFrameTime or game.lastFrame is null
            this.updateLocation time if game.lastFrame? and @speed?
            position = @currentFrameList[@currentFrame]
            position.offset = {x: 0, y: position.height + game.baseVerticalOffset} unless position.offset?
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
            if @currentFrame < @currentFrameList.length - 1
                @currentFrame++
            else
                if @animationLooping is true then @currentFrame = 0 else @animationEndCallback()
                
    
    cycleThroughInfiniteFrames: (frameList, callback, motion) ->
        time = new Date().getTime()
        if !@animationTimer.isRunning()
            @animationTimer.start()
            game.lastFrame = null
        game.Utilities.getFrame () =>
            minimumFrameTime = if motion? then Math.abs(game.frameSpeedIndex - motion.speed + game.frameSpeedIndex) else 100
            if time - game.lastFrame >= minimumFrameTime or game.lastFrame is null
                this.updateLocation time, motion if game.lastFrame? and motion?
                position = frameList[@currentFrame]
                position.offset = {x: 0, y: position.height + game.baseVerticalOffset} unless position.offset?
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
                game.lastFrame = time
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
            game.lastFrame = time
        if @currentFrame < frameList.length and game.isGoing
            game.Utilities.getFrame () =>
                if frameList[@currentFrame].minWaitTime <= time - game.lastFrame
                    position = frameList[@currentFrame]
                    position.offset = {x: 0, y: position.height + game.baseVerticalOffset} unless position.offset?
                    @ctx.clearRect 0, 0, @canvas.width, @canvas.height
                    this.updateLocation time, motion if game.lastFrame? and motion?
                    @ctx.drawImage(
                        @sprite, position.start.x, position.start.y, position.width, position.height,
                        @currentLocation - position.offset.x, @canvas.height - position.offset.y, position.width, position.height
                    )
                    if position.frontFrame?
                        game.topCanvas[@side].clearRect 0, 0, game.playerCanvas.width/2, game.playerCanvas.height
                        game.topCanvas[@side].drawImage(
                            @sprite, position.frontFrame.start.x, position.frontFrame.start.y, position.frontFrame.width, position.frontFrame.height,
                            @currentLocation - position.frontFrame.offset.x, @canvas.height - position.frontFrame.offset.y, position.frontFrame.width, position.frontFrame.height
                        )
                    this[action]() for action in position.actions if position.actions?
                    game.lastFrame = time
                    @currentFrame++
                if @nextAnimation is null
                    this.cycleThroughFiniteFrames(frameList, callback, motion)
                else
                    @currentFrame = 0
                    @nextAnimation()
                    @nextAnimation = null
        else
            @currentFrame = 0
            @animationTimer.stop()
            callback() if callback?