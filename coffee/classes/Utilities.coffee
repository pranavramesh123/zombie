class game.Utilities

    @getFrame: (callback) ->
        if typeof webkitRequestAnimationFrame is 'function'
            return webkitRequestAnimationFrame(callback)
        if typeof mozRequestAnimationFrame is 'function'
            return mozRequestAnimationFrame(callback)
        if typeof msRequestAnimationFrame is 'function'
            return msRequestAnimationFrame(callback)
        if typeof requestAnimationFrame is 'function'
            return requestAnimationFrame(callback)
    
    @getCanvasCoords: (canvas, mouseX, mouseY) ->
        box = canvas.getBoundingClientRect();
        canvasCoords =
            'x': mouseX - box.left
            'y': mouseY - box.top