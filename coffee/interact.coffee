#   Copyright (C) 2014 Greg Weston
#   
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

codeCharacters = []
codeTimeout = null

reactToInput = ($canvas, x, y) ->
    
    return if cac.currentGame.player.isShooting or cac.currentGame.player.isReloading or cac.currentGame.isPaused
    
    if cac.currentGame.player.magazine.shells <= 0
        return tryToReload()
    
    inputCoords = cac.Utilities.getCanvasCoords($canvas.get(0), x, y)
    return tryToReload() if ($canvas.hasClass('left') and inputCoords.x > 400 - (cac.reloadRange/2)) or ($canvas.hasClass('right') and inputCoords.x < cac.reloadRange/2)
    
    if $canvas.hasClass 'left' then cac.currentGame.player.shoot 'left' else cac.currentGame.player.shoot 'right'

tryToReload = ->
    return if cac.currentGame.player.isShooting or cac.currentGame.player.isReloading or cac.currentGame.isPaused
    cac.currentGame.player.reload() if cac.currentGame.player.magazine.shells < cac.currentGame.player.magazine.capacity
    
$('#start').click () ->
    return if cac.readyToStart is false or cac.gameInProgress is true
    
    $('#intro, #recap, #created-by').addClass 'hidden'
    cac.currentGame = new cac.Game cac.gofast
    cac.currentGame.start()

$(document).on 'keydown', (e) ->
    return if cac.gameInProgress is false
    switch e.originalEvent.keyCode
        when cac.controlKeys.shootLeft then reactToInput $('#top-canvas-left')
        when cac.controlKeys.shootRight then reactToInput $('#top-canvas-right')
        when cac.controlKeys.reload then tryToReload()
        when cac.controlKeys.pause then cac.currentGame.togglePause()
            
$('canvas.top').on 'touchstart', (e) ->
    return if cac.gameInProgress is false
    evt = e.originalEvent
    reactToInput $(this), evt.touches[0].clientX, evt.touches[0].clientY
    
$('#hud').on 'touchstart', ->
    if cac.gameInProgress is false then return else cac.currentGame.togglePause()
    
$(document).on 'keydown', (e) ->
    return $('#start').click() if e.originalEvent.keyCode is 13
    
    if cac.readyToStart is true and cac.gameInProgress is false
        codeCharacters.push e.originalEvent.keyCode
        clearTimeout(codeTimeout) if codeTimeout isnt null
        codeTimeout = setTimeout ->
            codeCharacters = []
        , 2000
        for keycode, index in [71, 79, 70, 65, 83, 84] # Keycodes for G-O-F-A-S-T
            if codeCharacters[index] isnt keycode
                return
        cac.gofast = true
        $('#start').html 'GO FAST!'
    
$('#restart').click -> $('#start').click()

window.onblur = ->
    if cac.currentGame? and cac.currentGame.isPaused is false
        cac.currentGame.togglePause()