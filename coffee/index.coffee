       
game.zombies =
    left: []
    right: []
        
player = new game.Player game.playerCanvas, 'left'

reactToInput = (x, y) ->
    if player.isShooting or player.isReloading
        return
    contactCoords = game.Utilities.getCanvasCoords(game.playerCanvas, x, y)
    if contactCoords.x < game.playerCanvas.width/2 - 70 or contactCoords.x > game.playerCanvas.width/2 + 70
        if player.magazine.shells <= 0
            game.displayMessage 'Reload', 3000
            return
        if contactCoords.x < game.playerCanvas.width/2 - 70
            player.shoot 'left'
        else
            player.shoot 'right'
    else if player.magazine.shells is player.magazine.capacity
        game.displayMessage 'Already full', 3000
        return
    else
        player.reload()

document.getElementById('start').onclick = () ->
    $('#message').empty()
    $('#start').addClass('hidden')
    $('#canvas-container').on('mousedown', (e) ->
        reactToInput e.clientX, e.clientY
    )
    $('#canvas-container').on('touchstart', (e) ->
        evt = e.originalEvent
        reactToInput evt.touches[0].clientX, evt.touches[0].clientY
    )
    game.start()