       
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
            console.log 'empty'
            return
        if contactCoords.x < game.playerCanvas.width/2 - 70
            player.shoot 'left'
        else
            player.shoot 'right'
    else if player.magazine.shells is player.magazine.capacity
        console.log 'already full'
        return
    else
        player.reload()
        
$(game.playerCanvas).on('mousedown', (e) ->
    reactToInput e.clientX, e.clientY
)
$(game.playerCanvas).on('touchstart', (e) ->
    evt = e.originalEvent
    reactToInput evt.touches[0].clientX, evt.touches[0].clientY
)

document.getElementById('start').onclick = () ->
    $('#message').addClass('hidden')
    setInterval () ->
        randomNum = Math.random()
        comeFrom = if randomNum >= .5 then 'left' else 'right'
        speed = randomNum * 100 + 25
        game.zombies[comeFrom].push new game.Zombie comeFrom, 'firstzombie', speed, -75
    , 2000