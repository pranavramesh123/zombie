playerCanvas = document.getElementById('player-canvas')
zombieCanvas = document.getElementById('zombie-canvas')
            
game.zombies = [new game.Zombie zombieCanvas, 'firstzombie', 38]
        
player = new game.Player playerCanvas

reactToInput = (x, y) ->
    if player.isShooting or player.isReloading
        return
    contactCoords = game.Utilities.getCanvasCoords(playerCanvas, x, y)
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