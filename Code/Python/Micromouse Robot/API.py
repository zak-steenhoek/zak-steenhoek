import sys

'''
orients :
    0- North
    1- East
    2- South
    3- West
'''


def orientation(orient, turning):
    if turning == 'L':
        orient -= 1
        if orient == -1:
            orient = 3
    elif turning == 'R':
        orient += 1
        if orient == 4:
            orient = 0
    elif turning == 'B':
        if orient == 0:
            orient = 2
        elif orient == 1:
            orient = 3
        elif orient == 2:
            orient = 0
        elif orient == 3:
            orient = 1

    return orient


def updateCoordinates(x, y, orient):
    if orient == 0:
        y += 1
    if orient == 1:
        x += 1
    if orient == 2:
        y -= 1
    if orient == 3:
        x -= 1

    return x, y


class MouseCrashedError(Exception):
    pass


def command(args, return_type=None):
    line = " ".join([str(x) for x in args]) + "\n"
    sys.stdout.write(line)
    sys.stdout.flush()
    if return_type:
        response = sys.stdin.readline().strip()
        if return_type == bool:
            return response == "true"
        return return_type(response)


def mazeWidth():
    return command(args=["mazeWidth"], return_type=int)


def mazeHeight():
    return command(args=["mazeHeight"], return_type=int)


def checkWall(wallCommand, half_steps_away=None):
    args = [wallCommand]
    if half_steps_away is not None:
        args.append(half_steps_away)
    return command(args, return_type=bool)


def wallFront(half_steps_away=None):
    return checkWall("wallFront", half_steps_away)


def wallLeft(half_steps_away=None):
    return checkWall("wallLeft", half_steps_away)


def wallRight(half_steps_away=None):
    return checkWall("wallRight", half_steps_away)


def moveForward(distance=None):
    args = ["moveForward"]
    # Don't append distance argument unless explicitly specified, for
    # backwards compatibility with older versions of the simulator
    if distance is not None:
        args.append(distance)
    response = command(args=args, return_type=str)
    if response == "crash":
        raise MouseCrashedError()


def turnRight():
    command(args=["turnRight"], return_type=str)


def turnLeft():
    command(args=["turnLeft"], return_type=str)


def setWall(x, y, direction):
    command(args=["setWall", x, y, direction])


def clearWall(x, y, direction):
    command(args=["clearWall", x, y, direction])


def setColor(x, y, color):
    command(args=["setColor", x, y, color])


def clearColor(x, y):
    command(args=["clearColor", x, y])


def clearAllColor():
    command(args=["clearAllColor"])


def setText(x, y, text):
    command(args=["setText", x, y, text])


def clearText(x, y):
    command(args=["clearText", x, y])


def clearAllText():
    command(args=["clearAllText"])


def wasReset():
    return command(args=["wasReset"], return_type=bool)


def ackReset():
    command(args=["ackReset"], return_type=str)


def log(string):
    sys.stderr.write("{}\n".format(string))
