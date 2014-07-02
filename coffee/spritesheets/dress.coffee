game.zombieSprites.push(
    src: [
        "/img/spritesheets/zombies/dress-yellow.png",
        "/img/spritesheets/zombies/dress-blue.png"
    ]
    walkingFrames: [
        {
            start:
                x: 0
                y: 0
            width: 78
            height: 144
        },
        {
            start:
                x: 79
                y: 0
            width: 92
            height: 144
        },
        {
            start:
                x: 172
                y: 0
            width: 83
            height: 144
        },
        {
            start:
                x: 256
                y: 0
            width: 71
            height: 144
        },
        {
            start:
                x: 328
                y: 0
            width: 65
            height: 144
        },
        {
            start:
                x: 394
                y: 0
            width: 77
            height: 144
        },
        {
            start:
                x: 472
                y: 0
            width: 80
            height: 144
        },
        {
            start:
                x: 553
                y: 0
            width: 65
            height: 144
        },
        {
            start:
                x: 619
                y: 0
            width: 65
            height: 144
        }
    ]
    dyingFrames: [
        {
            minWaitTime: 0
            start:
                x: 689
                y: 0
            width: 76
            height: 144
            offset:
                x: 80
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 767
                y: 0
            width: 103
            height: 144
            offset:
                x: 150
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 872
                y: 0
            width: 124
            height: 144
            offset:
                x: 200
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 998
                y: 0
            width: 148
            height: 144
            offset:
                x: 230
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 1148
                y: 0
            width: 142
            height: 144
            offset:
                x: 230
                y: 144 + game.baseVerticalOffset
        }
    ]
    bitingFrames: [
        {
            minWaitTime: 0
            start:
                x: 1325
                y: 0
            width: 79
            height: 144
            frontFrame:
                start:
                    x: 1557
                    y: 102
                width: 39
                height: 39
                offset:
                    x: -5
                    y: 108 + game.baseVerticalOffset
        },
        {
            minWaitTime: 75
            start:
                x: 1409
                y: 0
            width: 79
            height: 144
            frontFrame:
                start:
                    x: 1557
                    y: 102
                width: 39
                height: 39
                offset:
                    x: -10
                    y: 106 + game.baseVerticalOffset
        },
        {
            minWaitTime: 75
            start:
                x: 1490
                y: 0
            width: 82
            height: 144
            frontFrame:
                start:
                    x: 1574
                    y: 102
                width: 40
                height: 39
                offset:
                    x: -15
                    y: 103 + game.baseVerticalOffset
        }
    ]
)