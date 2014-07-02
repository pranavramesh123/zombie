game.zombieSprites.push(
    src: [
        "/img/spritesheets/zombies/beater-white.png",
        "/img/spritesheets/zombies/beater-black.png"
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
                x: 685
                y: 0
            width: 80
            height: 144
            offset:
                x: 50
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 766
                y: 0
            width: 92
            height: 144
            offset:
                x: 100
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 859
                y: 0
            width: 134
            height: 144
            offset:
                x: 150
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 994
                y: 0
            width: 164
            height: 144
            offset:
                x: 200
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 1159
                y: 0
            width: 164
            height: 144
            offset:
                x: 200
                y: 144 + game.baseVerticalOffset
        }
    ]
    bitingFrames: [
        {
            minWaitTime: 0
            start:
                x: 1324
                y: 0
            width: 74
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
                x: 1399
                y: 0
            width: 74
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
                x: 1474
                y: 0
            width: 80
            height: 144
            frontFrame:
                start:
                    x: 1557
                    y: 102
                width: 39
                height: 39
                offset:
                    x: -15
                    y: 103 + game.baseVerticalOffset
        }
    ]
)