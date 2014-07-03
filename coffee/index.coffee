reactToInput = ($canvas, x, y) ->
    return if game.currentGame.player.isShooting or game.currentGame.player.isReloading or game.currentGame.isPaused
    if game.currentGame.player.magazine.shells <= 0
        return tryToReload()
    inputCoords = game.Utilities.getCanvasCoords($canvas.get(0), x, y)
    reloadRange = 60
    return tryToReload() if ($canvas.hasClass('left') and inputCoords.x > 400 - (reloadRange/2)) or ($canvas.hasClass('right') and inputCoords.x < reloadRange/2)
    if $canvas.hasClass 'left' then game.currentGame.player.shoot 'left' else game.currentGame.player.shoot 'right'

tryToReload = () ->
    return if game.currentGame.player.isShooting or game.currentGame.player.isReloading or game.currentGame.isPaused
    game.currentGame.player.reload() if game.currentGame.player.magazine.shells < game.currentGame.player.magazine.capacity
        
background = document.getElementById('background')
bgctx = background.getContext '2d'
backgroundScene = new Image()
backgroundScene.src = '/img/background.png'
backgroundScene.onload = () ->
    bgctx.drawImage(backgroundScene, 0, 0)
    
$('#start').click () ->
    $('#intro, #recap').addClass 'hidden'
    game.currentGame = new game.Game()
    game.currentGame.start()

$(document).on 'keydown', (e) ->
    return if game.gameInProgress is false
    switch e.originalEvent.keyCode
        when game.controlKeys.shootLeft then reactToInput $('#top-canvas-left')
        when game.controlKeys.shootRight then reactToInput $('#top-canvas-right')
        when game.controlKeys.reload then tryToReload()
        when game.controlKeys.pause then game.currentGame.togglePause()
$('canvas.top').on('touchstart', (e) ->
    return if game.gameInProgress is false
    evt = e.originalEvent
    reactToInput $(this), evt.touches[0].clientX, evt.touches[0].clientY
)

$(document).on 'keydown', (e) ->
    $('#start').click() if e.originalEvent.keyCode is 13 and game.gameInProgress is false
    
$('#restart').click () -> $('#start').click()