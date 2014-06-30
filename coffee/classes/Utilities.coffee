class game.Utilities

    @getFrame: (callback) ->
        return requestAnimationFrame(callback) || webkitRequestAnimationFrame(callback) || mozRequestAnimationFrame(callback) || msRequestAnimationFrame(callback)
    
    @getCanvasCoords: (canvas, mouseX, mouseY) ->
        box = canvas.getBoundingClientRect();
        canvasCoords =
            'x': mouseX - box.left
            'y': mouseY - box.top