game.zombies =
    left: []
    right: []
        
game.player = new game.Player game.playerCanvas, 'left'

reactToInput = ($canvas, x, y) ->
    return if game.player.isShooting or game.player.isReloading
    if game.player.magazine.shells <= 0
        game.displayMessage 'Reload', 1000
        return
    if $canvas.hasClass 'left' then game.player.shoot 'left' else game.player.shoot 'right'

tryToReload = () ->
    return if game.player.isShooting or game.player.isReloading
    if game.player.magazine.shells is game.player.magazine.capacity then game.displayMessage 'Already full', 1000 else game.player.reload()
        
background = document.getElementById('background')
bgctx = background.getContext '2d'

#brick = new Image()
#brick.src = '/img/brick.png'
#brick.onload = () ->
#    ptn = bgctx.createPattern brick, 'repeat'
#    bgctx.fillStyle = ptn
#    bgctx.fillRect 0, 364, background.width, 36

document.getElementById('start').onclick = () ->
    actionInProgress = false 
    topCanvas = $('canvas.top')
    $('#intro').addClass 'hidden'
    topCanvas.on('mousedown', (e) ->
        return if actionInProgress is true
        actionInProgress = true
        reactToInput $(this), e.clientX, e.clientY
    )
    topCanvas.on('touchstart', (e) ->
        return if actionInProgress is true
        actionInProgress = true
        evt = e.originalEvent
        reactToInput $(this), evt.touches[0].clientX, evt.touches[0].clientY
    )
    topCanvas.on 'mouseup touchend', (e) -> actionInProgress = false
    game.reloadButton.on('mousedown', (e) ->
        return if actionInProgress is true
        actionInProgress = true
        tryToReload()
    )
    game.reloadButton.on('touchstart', (e) ->
        return if actionInProgress is true
        actionInProgress = true
        tryToReload()
    )
    game.reloadButton.on 'mouseup touchend', (e) -> actionInProgress = false
    game.start()