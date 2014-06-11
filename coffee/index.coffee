getFrame = (callback) ->
    requestID = mozRequestAnimationFrame(callback)
    return requestID

canvas = document.getElementById('canvas')

getCanvasCoords = (mouseX, mouseY) ->
	box = canvas.getBoundingClientRect();
	canvasCoords =
		'x': mouseX - box.left
		'y': mouseY - box.top

class Timer
    constructor: ->
        @startTime = 0
        @running = false
        @elapsed = undefined
        
    start: ->
        @startTime = (+new Date())
        @running = true
        
    stop: ->
        @running = false;
        @elapsed = (+new Date()) - @startTime;
            
    getElapsedTime: ->
        if @running
            return (+new Date()) - @startTime
        return @elapsed
    
    isRunning: ->
        return @running
    
    reset: ->
        @elapsed = 0

class Player
    constructor: (canvas) ->
        sprite = new Image()
        sprite.src = '../img/firstsheet.png'
        @canvas = canvas
        @ctx = canvas.getContext('2d')
        @animationTimer = new Timer()
        @lastFrame = null
        @currentDirection = 'left'
        sprite.onload = () =>
            @sprite = sprite
            @ctx.drawImage sprite, 129, 0, 75, 126, canvas.width/2 - 40, canvas.height - 126, 75, 126
        @isShooting = false
        @isReloading = false
        @shootingFrames = [
            {
                minWaitTime: 0
                start:
                    x: 42
                    y: 0
                width: 87
                height: 126
                offset:
                    x: 58
                    y: 126
            },
            {
                minWaitTime: 100
                actions: 'fire', 'minusMagazine'
                start:
                    x: 411
                    y: 0
                width: 114
                height: 126
                offset:
                    x: 82
                    y: 126
            },
            {
                minWaitTime: 100
                start:
                    x: 42
                    y: 0
                width: 87
                height: 126
                offset:
                    x: 58
                    y: 126
            },
            {
                minWaitTime: 200
                start:
                    x: 129
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 40
                    y: 126
            },
            {
                minWaitTime: 75
                start:
                    x: 204
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 40
                    y: 126
            },
            {
                minWaitTime: 125
                start:
                    x: 129
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 40
                    y: 126
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
                    x: 16
                    y: 126
            },
            {
                minWaitTime: 125
                start:
                    x: 327
                    y: 0
                width: 45
                height: 126
                offset:
                    x: 13
                    y: 126
            },
            {
                minWaitTime: 125
                start:
                    x: 372
                    y: 0
                width: 39
                height: 126
                offset:
                    x: 7
                    y: 126
            },
            {
                minWaitTime: 125
                start:
                    x: 129
                    y: 0
                width: 75
                height: 126
                offset:
                    x: 40
                    y: 126
            }
        ]
        @currentFrame = 0
        @magazine =
            holding: 8
            capacity: 8
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
        this.cycleThroughFrames @shootingFrames, () => @isShooting = false
    reload: () ->
        @isReloading = true
        this.cycleThroughFrames @reloadingFrames, () => @isReloading = false
    cycleThroughFrames: (frameList, callback) ->
        time = new Date().getTime()
        if !@animationTimer.isRunning()
            @animationTimer.start()
            @lastFrame = time
        if @currentFrame < frameList.length
            getFrame () =>
                if frameList[@currentFrame].minWaitTime <= time - @lastFrame
                    position = frameList[@currentFrame]
                    @ctx.clearRect 0, 0, @canvas.width, @canvas.height
                    if @currentDirection is 'right'
                        adjustedOffsetX = position.offset.x + 22
                    else
                        adjustedOffsetX = position.offset.x
                    @ctx.drawImage(
                        @sprite, position.start.x, position.start.y, position.width, position.height,
                        @canvas.width/2 - adjustedOffsetX, @canvas.height - position.offset.y, position.width, position.height
                    )
                    @lastFrame = time
                    @currentFrame++
                this.cycleThroughFrames(frameList, callback)
        else
            @currentFrame = 0
            callback()
        
player = new Player canvas

reactToInput = (x, y) ->
    if player.isShooting or player.isReloading
        return
    contactCoords = getCanvasCoords(x, y)
    if contactCoords.x < canvas.width/2 - 70
        player.shoot 'left'
    else if contactCoords.x > canvas.width/2 + 70
        player.shoot 'right'
    else
        player.reload()
        
$(canvas).on('mousedown', (e) ->
    reactToInput e.clientX, e.clientY
)
$(canvas).on('touchstart', (e) ->
    evt = e.originalEvent
    reactToInput evt.touches[0].clientX, evt.touches[0].clientY
)