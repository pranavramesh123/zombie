getFrame = (callback) ->
    if typeof webkitRequestAnimationFrame is 'function'
        return webkitRequestAnimationFrame(callback)
    if typeof mozRequestAnimationFrame is 'function'
        return mozRequestAnimationFrame(callback)
    if typeof msRequestAnimationFrame is 'function'
        return msRequestAnimationFrame(callback)
    if typeof requestAnimationFrame is 'function'
        return requestAnimationFrame(callback)

playerCanvas = document.getElementById('player-canvas')
zombieCanvas = document.getElementById('zombie-canvas')

getCanvasCoords = (mouseX, mouseY) ->
	box = playerCanvas.getBoundingClientRect();
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

class Zombie
    constructor: (canvas, spritesheet, speed) ->
        sprite = new Image()
        sprite.src = '../img/' + spritesheet + '.png'
        @canvas = canvas
        @ctx = canvas.getContext('2d')
        @animationTimer = new Timer()
        @lastFrame = null
        @speed = speed
        @currentLocation = 0
        @currentFrame = 0
        sprite.onload = () =>
            @sprite = sprite
            this.walk()
        @beenShot = false
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
                start:
                    x: 294
                    y: 0
                width: 90
                height: 144
            }
        ]
    
    walk: () ->
        time = new Date().getTime()
        if !@animationTimer.isRunning()
            @animationTimer.start()
            @lastFrame = null
        getFrame () =>
            if time - @lastFrame >= 100 or @lastFrame is null
                position = @walkingFrames[@currentFrame]
                if @lastFrame isnt null
                    @currentLocation += @speed * ((time - @lastFrame)/1000)
                @ctx.clearRect 0, 0, @canvas.width, @canvas.height
                @ctx.drawImage(
                    @sprite, position.start.x, position.start.y, position.width, position.height,
                    @currentLocation, @canvas.height - position.height, position.width, position.height
                )
                if @currentFrame < @walkingFrames.length - 1
                    @currentFrame++
                else
                    @currentFrame = 0
                @lastFrame = time
            if @currentLocation < @canvas.width and @beenShot is false
                this.walk()
    getShot: () ->
        @beenShot = true
        console.log 'bull\'s eye'
        position = @dyingFrames[0]
        @ctx.clearRect 0, 0, @canvas.width, @canvas.height
        @ctx.drawImage(
            @sprite, position.start.x, position.start.y, position.width, position.height,
            @currentLocation - 20, @canvas.height - position.height, position.width, position.height
        )

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
                actions: ['fire']
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
                actions: ['loadShell']
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
            shells: 6
            capacity: 6
    fire: () ->
        @magazine.shells--
        $('#ammo img:not(.used)').first().addClass('used').get(0).src = '/img/noshellicon.png'
        if @currentDirection is 'right' and zombie.currentLocation > playerCanvas.width/2
            zombie.getShot()
        else if @currentDirection is 'left' and zombie.currentLocation < playerCanvas.width/2
            zombie.getShot()
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
                    this[action]() for action in position.actions if position.actions?
                    @lastFrame = time
                    @currentFrame++
                this.cycleThroughFrames(frameList, callback)
        else
            @currentFrame = 0
            callback()
            
zombie = new Zombie zombieCanvas, 'firstzombie', 38
        
player = new Player playerCanvas

reactToInput = (x, y) ->
    if player.isShooting or player.isReloading
        return
    contactCoords = getCanvasCoords(x, y)
    if contactCoords.x < playerCanvas.width/2 - 70 or contactCoords.x > playerCanvas.width/2 + 70
        if player.magazine.shells <= 0
            console.log 'empty'
            return
        if contactCoords.x < playerCanvas.width/2 - 70
            player.shoot 'left'
        else
            player.shoot 'right'
    else if player.magazine.shells is player.magazine.capacity
        console.log 'already full'
        return
    else
        player.reload()
        
$(playerCanvas).on('mousedown', (e) ->
    reactToInput e.clientX, e.clientY
)
$(playerCanvas).on('touchstart', (e) ->
    evt = e.originalEvent
    reactToInput evt.touches[0].clientX, evt.touches[0].clientY
)