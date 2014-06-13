game.zombies =
    left: []
    right: []
        
player = new game.Player game.playerCanvas, 'left'

reactToInput = ($canvas, x, y) ->
    return if player.isShooting or player.isReloading
    if player.magazine.shells <= 0
        game.displayMessage 'Reload', 1000
        return
    if $canvas.hasClass 'left' then player.shoot 'left' else player.shoot 'right'

tryToReload = () ->
    return if player.isShooting or player.isReloading
    if player.magazine.shells is player.magazine.capacity then game.displayMessage 'Already full', 1000 else player.reload()  

document.getElementById('start').onclick = () ->
    $('#message').empty()
    $('#start').addClass 'hidden'
    $('canvas.top').on 'mousedown', (e) -> reactToInput $(this), e.clientX, e.clientY
    $('canvas.top').on('touchstart', (e) ->
        evt = e.originalEvent
        reactToInput $(this), evt.touches[0].clientX, evt.touches[0].clientY
    )
    game.ammoContainer.on 'mousedown', (e) -> tryToReload()
    game.ammoContainer.on('touchstart', (e) ->
        evt = e.originalEvent
        tryToReload()
    )
    game.start()