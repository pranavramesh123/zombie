
playerCanvas = document.getElementById 'player-canvas'
leftZombieCanvas = document.getElementById 'zombie-canvas-left'
rightZombieCanvas = document.getElementById 'zombie-canvas-right'

rightZombieCanvasContext = rightZombieCanvas.getContext '2d'
rightZombieCanvasContext.translate rightZombieCanvas.width, 0
rightZombieCanvasContext.scale -1, 1
       
game.zombies =
    left: [new game.Zombie leftZombieCanvas, 'firstzombie', 38]
    right: [new game.Zombie rightZombieCanvas, 'firstzombie', 38]
        
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