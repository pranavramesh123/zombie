game.zombieSprites.push(
    src: [
        "/img/spritesheets/zombies/afrobeard-black.png",
        "/img/spritesheets/zombies/afrobeard-grey.png"
    ]
    walkingFrames: [
        {
            start:
                x: 0
                y: 0
            width: 72
            height: 144
        },
        {
            start:
                x: 73
                y: 0
            width: 86
            height: 144
        },
        {
            start:
                x: 160
                y: 0
            width: 77
            height: 144
        },
        {
            start:
                x: 238
                y: 0
            width: 62
            height: 144
        },
        {
            start:
                x: 301
                y: 0
            width: 59
            height: 144
        },
        {
            start:
                x: 361
                y: 0
            width: 71
            height: 144
        },
        {
            start:
                x: 433
                y: 0
            width: 74
            height: 144
        },
        {
            start:
                x: 508
                y: 0
            width: 59
            height: 144
        },
        {
            start:
                x: 568
                y: 0
            width: 65
            height: 144
        }
    ]
    dyingFrames: [
        {
            minWaitTime: 0
            start:
                x: 634
                y: 0
            width: 92
            height: 144
            offset:
                x: 50
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 727
                y: 0
            width: 86
            height: 144
            offset:
                x: 100
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 814
                y: 0
            width: 137
            height: 144
            offset:
                x: 150
                y: 144 + game.baseVerticalOffset
        },
        {
            minWaitTime: 60
            start:
                x: 952
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
                x: 1117
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
                x: 1282
                y: 0
            width: 86
            height: 144
            frontFrame:
                start:
                    x: 1509
                    y: 117
                width: 42
                height: 27
                offset:
                    x: -10
                    y: 78 + game.baseVerticalOffset
        },
        {
            minWaitTime: 75
            start:
                x: 1369
                y: 0
            width: 65
            height: 144
            frontFrame:
                start:
                    x: 1509
                    y: 117
                width: 42
                height: 27
                offset:
                    x: -10
                    y: 78 + game.baseVerticalOffset
        },
        {
            minWaitTime: 75
            start:
                x: 1435
                y: 0
            width: 62
            height: 144
            frontFrame:
                start:
                    x: 1509
                    y: 93
                width: 42
                height: 45
                offset:
                    x: -10
                    y: 102 + game.baseVerticalOffset
        }
    ]
)