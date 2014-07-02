game.zombies =
    left: []
    right: []
        
game.player = new game.Player game.playerCanvas, 'left'

reactToInput = ($canvas, x, y) ->
    return if game.player.isShooting or game.player.isReloading
    if game.player.magazine.shells <= 0
        return tryToReload()
    inputCoords = game.Utilities.getCanvasCoords($canvas.get(0), x, y)
    reloadRange = 60
    return tryToReload() if ($canvas.hasClass('left') and inputCoords.x > 400 - (reloadRange/2)) or ($canvas.hasClass('right') and inputCoords.x < reloadRange/2)
    if $canvas.hasClass 'left' then game.player.shoot 'left' else game.player.shoot 'right'

tryToReload = () ->
    return if game.player.isShooting or game.player.isReloading
    console.log 'gonna reload'
    game.player.reload() if game.player.magazine.shells < game.player.magazine.capacity
        
background = document.getElementById('background')
bgctx = background.getContext '2d'

#brick = new Image()
#brick.src = '/img/brick.png'
#brick.onload = () ->
#    ptn = bgctx.createPattern brick, 'repeat'
#    bgctx.fillStyle = ptn
#    bgctx.fillRect 0, 364, background.width, 36

$('#start').click () ->
    $('#intro').addClass 'hidden'
    topCanvas = $('canvas.top')
    document.onkeydown = (e) ->
        switch e.keyCode
            when game.controlKeys.shootLeft then reactToInput $('#top-canvas-left')
            when game.controlKeys.shootRight  then reactToInput $('#top-canvas-right')
            when game.controlKeys.reload  then tryToReload()
            when 32 then game.togglePause()
    topCanvas.on('touchstart', (e) ->
        evt = e.originalEvent
        reactToInput $(this), evt.touches[0].clientX, evt.touches[0].clientY
    )
    game.start()

document.onkeydown = (e) ->
    $('#start').click() if e.keyCode is 13