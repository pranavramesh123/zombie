class game.Timer
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
