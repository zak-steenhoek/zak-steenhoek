import API
import sys

mazeDim = 16

cells = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

flood = [[14, 13, 12, 11, 10, 9, 8, 7, 7, 8, 9, 10, 11, 12, 13, 14],
         [13, 12, 11, 10, 9, 8, 7, 6, 6, 7, 8, 9, 10, 11, 12, 13],
         [12, 11, 10, 9, 8, 7, 6, 5, 5, 6, 7, 8, 9, 10, 11, 12],
         [11, 10, 9, 8, 7, 6, 5, 4, 4, 5, 6, 7, 8, 9, 10, 11],
         [10, 9, 8, 7, 6, 5, 4, 3, 3, 4, 5, 6, 7, 8, 9, 10],
         [9, 8, 7, 6, 5, 4, 3, 2, 2, 3, 4, 5, 6, 7, 8, 9],
         [8, 7, 6, 5, 4, 3, 2, 1, 1, 2, 3, 4, 5, 6, 7, 8],
         [7, 6, 5, 4, 3, 2, 1, 0, 0, 1, 2, 3, 4, 5, 6, 7],
         [7, 6, 5, 4, 3, 2, 1, 0, 0, 1, 2, 3, 4, 5, 6, 7],
         [8, 7, 6, 5, 4, 3, 2, 1, 1, 2, 3, 4, 5, 6, 7, 8],
         [9, 8, 7, 6, 5, 4, 3, 2, 2, 3, 4, 5, 6, 7, 8, 9],
         [10, 9, 8, 7, 6, 5, 4, 3, 3, 4, 5, 6, 7, 8, 9, 10],
         [11, 10, 9, 8, 7, 6, 5, 4, 4, 5, 6, 7, 8, 9, 10, 11],
         [12, 11, 10, 9, 8, 7, 6, 5, 5, 6, 7, 8, 9, 10, 11, 12],
         [13, 12, 11, 10, 9, 8, 7, 6, 6, 7, 8, 9, 10, 11, 12, 13],
         [14, 13, 12, 11, 10, 9, 8, 7, 7, 8, 9, 10, 11, 12, 13, 14]]

visited = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]


# reference cell walls in notebook
def log(string):
    sys.stderr.write("{}\n".format(string))


def updateWalls(x, y, orient, L, R, F):
    if L and R and F:
        if orient == 0:
            cells[y][x] = 13
            API.setWall(x, y, "n")
            API.setWall(x, y, "e")
            API.setWall(x, y, "w")
        elif orient == 1:
            cells[y][x] = 12
            API.setWall(x, y, "n")
            API.setWall(x, y, "e")
            API.setWall(x, y, "s")
        elif orient == 2:
            cells[y][x] = 11
            API.setWall(x, y, "s")
            API.setWall(x, y, "e")
            API.setWall(x, y, "w")
        elif orient == 3:
            cells[y][x] = 14
            API.setWall(x, y, "n")
            API.setWall(x, y, "s")
            API.setWall(x, y, "w")

    elif L and R and not F:
        if orient == 0 or orient == 2:
            cells[y][x] = 9
            API.setWall(x, y, "e")
            API.setWall(x, y, "w")
        elif orient == 1 or orient == 3:
            cells[y][x] = 10
            API.setWall(x, y, "n")
            API.setWall(x, y, "s")

    elif L and F and not R:
        if orient == 0:
            cells[y][x] = 8
            API.setWall(x, y, "n")
            API.setWall(x, y, "w")
        elif orient == 1:
            cells[y][x] = 7
            API.setWall(x, y, "n")
            API.setWall(x, y, "e")
        elif orient == 2:
            cells[y][x] = 6
            API.setWall(x, y, "s")
            API.setWall(x, y, "e")
        elif orient == 3:
            cells[y][x] = 5
            API.setWall(x, y, "s")
            API.setWall(x, y, "w")

    elif R and F and not L:
        if orient == 0:
            cells[y][x] = 7
            API.setWall(x, y, "n")
            API.setWall(x, y, "e")
        elif orient == 1:
            cells[y][x] = 6
            API.setWall(x, y, "s")
            API.setWall(x, y, "e")
        elif orient == 2:
            cells[y][x] = 5
            API.setWall(x, y, "s")
            API.setWall(x, y, "w")
        elif orient == 3:
            cells[y][x] = 8
            API.setWall(x, y, "w")
            API.setWall(x, y, "n")

    elif F:
        if orient == 0:
            cells[y][x] = 2
            API.setWall(x, y, "n")
        elif orient == 1:
            cells[y][x] = 3
            API.setWall(x, y, "e")
        elif orient == 2:
            cells[y][x] = 4
            API.setWall(x, y, "s")
        elif orient == 3:
            cells[y][x] = 1
            API.setWall(x, y, "w")

    elif L:
        if orient == 0:
            cells[y][x] = 1
            API.setWall(x, y, "w")
        elif orient == 1:
            cells[y][x] = 2
            API.setWall(x, y, "n")
        elif orient == 2:
            cells[y][x] = 3
            API.setWall(x, y, "e")
        elif orient == 3:
            cells[y][x] = 4
            API.setWall(x, y, "s")

    elif R:
        if orient == 0:
            cells[y][x] = 3
            API.setWall(x, y, "e")
        elif orient == 1:
            cells[y][x] = 4
            API.setWall(x, y, "s")
        elif orient == 2:
            cells[y][x] = 1
            API.setWall(x, y, "w")
        elif orient == 3:
            cells[y][x] = 2
            API.setWall(x, y, "n")


def isAccessible(x, y, x1, y1):
    # returns True if mouse can move to x1,y1 from x,y (two adjacent cells)

    if x == x1:
        if y > y1:
            if (cells[y][x] == 4 or cells[y][x] == 5 or cells[y][x] == 6 or cells[y][x] == 10 or cells[y][x] == 11 or
                    cells[y][x] == 12 or cells[y][x] == 14):
                return False
            else:
                return True
        else:
            if (cells[y][x] == 2 or cells[y][x] == 7 or cells[y][x] == 8 or cells[y][x] == 10 or cells[y][x] == 12 or
                    cells[y][x] == 13 or cells[y][x] == 14):
                return False
            else:
                return True

    elif y == y1:
        if x > x1:
            if (cells[y][x] == 1 or cells[y][x] == 5 or cells[y][x] == 8 or cells[y][x] == 9 or cells[y][x] == 11 or
                    cells[y][x] == 13 or cells[y][x] == 14):
                return False
            else:
                return True
        else:
            if (cells[y][x] == 3 or cells[y][x] == 6 or cells[y][x] == 7 or cells[y][x] == 9 or cells[y][x] == 11 or
                    cells[y][x] == 12 or cells[y][x] == 13):
                return False
            else:
                return True


def getSurrounds(x, y):
    # returns x1,y1,x2,y2,x3,y3,x4,y4 for the four adj squares

    x3 = x - 1
    y3 = y
    x0 = x
    y0 = y + 1
    x1 = x + 1
    y1 = y
    x2 = x
    y2 = y - 1
    if x1 >= mazeDim:
        x1 = -1
    if y0 >= mazeDim:
        y0 = -1
    return x0, y0, x1, y1, x2, y2, x3, y3  # order of cells - north,east,south,west


def isConsistent(x, y):
    # returns True if the value of current square is one
    # greater than the minimum value in an accessible neighbour

    x0, y0, x1, y1, x2, y2, x3, y3 = getSurrounds(x, y)
    val = flood[y][x]
    minVals = [-1, -1, -1, -1]
    if x0 >= 0 and y0 >= 0:
        if isAccessible(x, y, x0, y0):
            minVals[0] = flood[y0][x0]
    if x1 >= 0 and y1 >= 0:
        if isAccessible(x, y, x1, y1):
            minVals[1] = flood[y1][x1]
    if x2 >= 0 and y2 >= 0:
        if isAccessible(x, y, x2, y2):
            minVals[2] = flood[y2][x2]
    if x3 >= 0 and y3 >= 0:
        if isAccessible(x, y, x3, y3):
            minVals[3] = flood[y3][x3]

    minCount = 0
    for i in range(4):
        if minVals[i] == -1:
            pass
        elif minVals[i] == val + 1:
            pass
        elif minVals[i] == val - 1:
            minCount += 1
            pass

    # minVal= min(minVals)

    # return(minVal)

    if minCount > 0:
        return True
    else:
        return False


def makeConsistent(x, y):
    x0, y0, x1, y1, x2, y2, x3, y3 = getSurrounds(x, y)

    minVals = [-1, -1, -1, -1]
    if x0 >= 0 and y0 >= 0:
        if isAccessible(x, y, x0, y0):
            minVals[0] = flood[y0][x0]
            # if (flood[y0][x0]<minVal):
            # minVals.append(flood[y0][x0])
            # minVal= flood[y0][x0]
    if x1 >= 0 and y1 >= 0:
        if isAccessible(x, y, x1, y1):
            minVals[1] = flood[y1][x1]
            # if (flood[y1][x1]<minVal):
            # minVals.append(flood[y1][x1])
            # minVal= flood[y1][x1]
    if x2 >= 0 and y2 >= 0:
        if isAccessible(x, y, x2, y2):
            minVals[2] = flood[y2][x2]
            # if (flood[y2][x2]<minVal):
            # minVals.append(flood[y1][x1])
            # minVal= flood[y2][x2]
    if x3 >= 0 and y3 >= 0:
        if isAccessible(x, y, x3, y3):
            minVals[3] = flood[y3][x3]
            # if (flood[y3][x3]<minVal):
            # minVals.append(flood[y1][x1])
            # minVal= flood[y3][x3]

    for i in range(4):
        if minVals[i] == -1:
            minVals[i] = 1000

    minVal = min(minVals)
    flood[y][x] = minVal + 1


def floodFill(x, y, xprev, yprev):
    # updates the flood matrix such that every square is consistent (current cell is x,y)

    if not isConsistent(x, y):
        flood[y][x] = flood[yprev][xprev] + 1

    stack = [x, y]
    x0, y0, x1, y1, x2, y2, x3, y3 = getSurrounds(x, y)
    if x0 >= 0 and y0 >= 0:
        if isAccessible(x, y, x0, y0):
            stack.append(x0)
            stack.append(y0)
    if x1 >= 0 and y1 >= 0:
        if isAccessible(x, y, x1, y1):
            stack.append(x1)
            stack.append(y1)
    if x2 >= 0 and y2 >= 0:
        if isAccessible(x, y, x2, y2):
            stack.append(x2)
            stack.append(y2)
    if x3 >= 0 and y3 >= 0:
        if isAccessible(x, y, x3, y3):
            stack.append(x3)
            stack.append(y3)

    while len(stack) != 0:
        yrun = stack.pop()
        xrun = stack.pop()

        if isConsistent(xrun, yrun):
            pass
        else:
            makeConsistent(xrun, yrun)
            stack.append(xrun)
            stack.append(yrun)
            x0, y0, x1, y1, x2, y2, x3, y3 = getSurrounds(xrun, yrun)
            if x0 >= 0 and y0 >= 0:
                if isAccessible(xrun, yrun, x0, y0):
                    stack.append(x0)
                    stack.append(y0)
            if x1 >= 0 and y1 >= 0:
                if isAccessible(xrun, yrun, x1, y1):
                    stack.append(x1)
                    stack.append(y1)
            if x2 >= 0 and y2 >= 0:
                if isAccessible(xrun, yrun, x2, y2):
                    stack.append(x2)
                    stack.append(y2)
            if x3 >= 0 and y3 >= 0:
                if isAccessible(xrun, yrun, x3, y3):
                    stack.append(x3)
                    stack.append(y3)


def toMove(x, y, xprev, yprev, orient):
    # returns the direction to turn into L,F,R or B

    x0, y0, x1, y1, x2, y2, x3, y3 = getSurrounds(x, y)
    prev = 0
    adjFloodVals = [1000, 1000, 1000, 1000]

    if isAccessible(x, y, x0, y0):
        if x0 == xprev and y0 == yprev:
            prev = 0
        adjFloodVals[0] = flood[y0][x0]

    if isAccessible(x, y, x1, y1):
        if x1 == xprev and y1 == yprev:
            prev = 1
        adjFloodVals[1] = flood[y1][x1]

    if isAccessible(x, y, x2, y2):
        if x2 == xprev and y2 == yprev:
            prev = 2
        adjFloodVals[2] = flood[y2][x2]

    if isAccessible(x, y, x3, y3):
        if x3 == xprev and y3 == yprev:
            prev = 3
        adjFloodVals[3] = flood[y3][x3]

    minVal = adjFloodVals[0]
    minCell = 0
    noMovements = 0
    for i in adjFloodVals:
        if i != 1000:
            noMovements += 1

    for i in range(4):
        if adjFloodVals[i] < minVal:
            if noMovements == 1:
                minVal = adjFloodVals[i]
                minCell = i
            else:
                if i == prev:
                    minVal = adjFloodVals[i]
                    minCell = i
                else:
                    minVal = adjFloodVals[i]
                    minCell = i

    if minCell == orient:
        return 'F'
    elif (minCell == orient - 1) or (minCell == orient + 3):
        return 'L'
    elif (minCell == orient + 1) or (minCell == orient - 3):
        return 'R'
    else:
        return 'B'


def showFlood():
    for x in range(mazeDim):
        for y in range(mazeDim):
            API.setText(x, y, str(flood[y][x]))


def main():
    x = 0
    y = 0
    xprev = 0
    yprev = 0
    orient = 0
    discovered = 0
    log("Mapping maze using floodfill algorithm...")
    API.setWall(x, y, 's')

    while discovered < (pow(mazeDim, 2)):
        L = API.wallLeft()
        R = API.wallRight()
        F = API.wallFront()
        updateWalls(x, y, orient, L, R, F)

        if flood[y][x] != 0:
            floodFill(x, y, xprev, yprev)
        else:
            while True:
                pass

        direction = toMove(x, y, xprev, yprev, orient)

        if direction == 'L':
            API.turnLeft()
            orient = API.orientation(orient, 'L')
        elif direction == 'R':
            API.turnRight()
            orient = API.orientation(orient, 'R')
        elif direction == 'B':
            API.turnLeft()
            orient = API.orientation(orient, 'L')
            API.turnLeft()
            orient = API.orientation(orient, 'L')
        else:
            pass

        if visited[x][y] == 0:
            visited[x][y] = 1
            discovered += 1

        showFlood()
        API.setColor(x, y, "G")
        API.moveForward()
        xprev = x
        yprev = y
        x, y = API.updateCoordinates(x, y, orient)

    API.ackReset()


if __name__ == "__main__":
    main()
