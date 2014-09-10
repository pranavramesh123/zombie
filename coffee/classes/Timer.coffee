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

class cac.Timer
    constructor: ->
        @startTime = 0
        @running = false
        @elapsed = undefined
        
    start: ->
        @startTime = (+new Date())
        @running = true
        
    stop: ->
        @running = false;
        @elapsed = (+new Date()) - @startTime;
            
    getElapsedTime: ->
        if @running
            return (+new Date()) - @startTime
        return @elapsed
    
    isRunning: ->
        return @running
    
    reset: ->
        @elapsed = 0
