class game.Sprite

    constructor: (canvas, side) ->
        @canvas = canvas
        @ctx = @canvas.getContext('2d')
        @animationTimer = new game.Timer()
        @currentFrame = 0
        @nextAnimation = null
        @position = null
        @lastFrame = null
        @animationEndCallback = () ->
        @animationLoopCallback = () ->
        
    updateLocation: (time) ->
        calculatedDistance = @speed * ((time - @lastFrame)/1000)
        actualDistance = if @lungingPoint? and @currentLocation + calculatedDistance > @lungingPoint then @lungingPoint - @currentLocation else calculatedDistance
        @currentLocation += actualDistance
    
    updatePosition: (time) ->
        return if @currentFrameList? is false
        minimumFrameTime = switch
            when @currentFrameList[@currentFrame].minWaitTime? then @currentFrameList[@currentFrame].minWaitTime
            when @speed? then Math.abs(game.frameSpeedIndex - @speed + game.frameSpeedIndex)
            else 100
        if time - @lastFrame >= minimumFrameTime or @lastFrame is null
            this.updateLocation time if @lastFrame? and @speed?
            @position = @currentFrameList[@currentFrame]
            @position.offset = {x: 0, y: @position.height + game.baseVerticalOffset} unless @position.offset?
            this[action]() for action in @position.actions if @position.actions?
            @animationLoopCallback() if @animationLoopCallback?
            @lastFrame = time
            if @currentFrame < @currentFrameList.length - 1
                @currentFrame++
            else
                if @animationLooping is true then @currentFrame = 0 else @animationEndCallback()
    
    redraw: () ->
        return if @position? is false
        @ctx.drawImage(
            @sprite, @position.start.x, @position.start.y, @position.width, @position.height,
            @currentLocation - @position.offset.x, @canvas.height - @position.offset.y, @position.width, @position.height
        )
        if @position.frontFrame?
            game.topCanvas[@side].drawImage(
                @sprite, @position.frontFrame.start.x, @position.frontFrame.start.y, @position.frontFrame.width, @position.frontFrame.height,
                @currentLocation - @position.frontFrame.offset.x, @canvas.height - @position.frontFrame.offset.y, @position.frontFrame.width, @position.frontFrame.height
            )