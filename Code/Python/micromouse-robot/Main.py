import API
import sys
import numpy as np
from queue import Queue

# Define x and y maze dimensions in units
mazeDimx = 16
mazeDimy = 16
center_x, center_y = mazeDimx // 2, mazeDimy // 2

# Init array to map wall layout
cells = np.zeros((mazeDimx, mazeDimy))

# Init array to keep track of visited cells
visited = np.zeros((mazeDimx, mazeDimy))


# Define manhattan distance
def manhattan_distance(x, y, x_center, y_center):
    return abs(x - x_center) + abs(y - y_center)


# Init manhattan distance array assuming no walls (distance to target cell(s))
'''
flood = [[4, 3, 2, 2, 3, 4],
         [3, 2, 1, 1, 2, 3],
         [2, 1, 0, 0, 1, 2],
         [2, 1, 0, 0, 1, 2],
         [3, 2, 1, 1, 2, 3],
         [4, 3, 2, 2, 3, 4]]

flood = [[6, 5, 4, 3, 3, 4, 5, 6],
         [5, 4, 3, 2, 2, 3, 4, 5],
         [4, 3, 2, 1, 1, 2, 3, 4],
         [3, 2, 1, 0, 0, 1, 2, 3],
         [3, 2, 1, 0, 0, 1, 2, 3],
         [4, 3, 2, 1, 1, 2, 3, 4],
         [5, 4, 3, 2, 2, 3, 4, 5],
         [6, 5, 4, 3, 3, 4, 5, 6]]
'''
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



# Write to simulator console
def log(string):
    sys.stderr.write("{}\n".format(string))


# Detect and map wall layout at current cell considering mouse orientation
def updateWalls(x, y, orient, L, R, F):
    # Maze wall layouts can be set to one of 16 different possibilities, reference image wall_layouts
    # Orientations can be set to one of 4 different possibilities, reference image orient

    if L and R and F:
        if orient == 0:
            cells[x][y] = 13
            API.setWall(x, y, "n")
            API.setWall(x, y, "e")
            API.setWall(x, y, "w")
        elif orient == 1:
            cells[x][y] = 12
            API.setWall(x, y, "n")
            API.setWall(x, y, "e")
            API.setWall(x, y, "s")
        elif orient == 2:
            cells[x][y] = 11
            API.setWall(x, y, "s")
            API.setWall(x, y, "e")
            API.setWall(x, y, "w")
        elif orient == 3:
            cells[x][y] = 14
            API.setWall(x, y, "n")
            API.setWall(x, y, "s")
            API.setWall(x, y, "w")

    elif L and R and not F:
        if orient == 0 or orient == 2:
            cells[x][y] = 9
            API.setWall(x, y, "e")
            API.setWall(x, y, "w")
        elif orient == 1 or orient == 3:
            cells[x][y] = 10
            API.setWall(x, y, "n")
            API.setWall(x, y, "s")

    elif L and F and not R:
        if orient == 0:
            cells[x][y] = 8
            API.setWall(x, y, "n")
            API.setWall(x, y, "w")
        elif orient == 1:
            cells[x][y] = 7
            API.setWall(x, y, "n")
            API.setWall(x, y, "e")
        elif orient == 2:
            cells[x][y] = 6
            API.setWall(x, y, "s")
            API.setWall(x, y, "e")
        elif orient == 3:
            cells[x][y] = 5
            API.setWall(x, y, "s")
            API.setWall(x, y, "w")

    elif R and F and not L:
        if orient == 0:
            cells[x][y] = 7
            API.setWall(x, y, "n")
            API.setWall(x, y, "e")
        elif orient == 1:
            cells[x][y] = 6
            API.setWall(x, y, "s")
            API.setWall(x, y, "e")
        elif orient == 2:
            cells[x][y] = 5
            API.setWall(x, y, "s")
            API.setWall(x, y, "w")
        elif orient == 3:
            cells[x][y] = 8
            API.setWall(x, y, "w")
            API.setWall(x, y, "n")

    elif F:
        if orient == 0:
            cells[x][y] = 2
            API.setWall(x, y, "n")
        elif orient == 1:
            cells[x][y] = 3
            API.setWall(x, y, "e")
        elif orient == 2:
            cells[x][y] = 4
            API.setWall(x, y, "s")
        elif orient == 3:
            cells[x][y] = 1
            API.setWall(x, y, "w")

    elif L:
        if orient == 0:
            cells[x][y] = 1
            API.setWall(x, y, "w")
        elif orient == 1:
            cells[x][y] = 2
            API.setWall(x, y, "n")
        elif orient == 2:
            cells[x][y] = 3
            API.setWall(x, y, "e")
        elif orient == 3:
            cells[x][y] = 4
            API.setWall(x, y, "s")

    elif R:
        if orient == 0:
            cells[x][y] = 3
            API.setWall(x, y, "e")
        elif orient == 1:
            cells[x][y] = 4
            API.setWall(x, y, "s")
        elif orient == 2:
            cells[x][y] = 1
            API.setWall(x, y, "w")
        elif orient == 3:
            cells[x][y] = 2
            API.setWall(x, y, "n")


# Determine if the NESW cells are blocked by walls
def isAccessible(x, y, x1, y1):
    # returns True if mouse can move to x1,y1 from x,y

    if x == x1:
        if y > y1:
            if (cells[x][y] == 4 or cells[x][y] == 5 or cells[x][y] == 6 or cells[x][y] == 10 or cells[x][y] == 11 or
                    cells[x][y] == 12 or cells[x][y] == 14):
                return False
            else:
                return True
        else:
            if (cells[x][y] == 2 or cells[x][y] == 7 or cells[x][y] == 8 or cells[x][y] == 10 or cells[x][y] == 12 or
                    cells[x][y] == 13 or cells[x][y] == 14):
                return False
            else:
                return True

    elif y == y1:
        if x > x1:
            if (cells[x][y] == 1 or cells[x][y] == 5 or cells[x][y] == 8 or cells[x][y] == 9 or cells[x][y] == 11 or
                    cells[x][y] == 13 or cells[x][y] == 14):
                return False
            else:
                return True
        else:
            if (cells[x][y] == 3 or cells[x][y] == 6 or cells[x][y] == 7 or cells[x][y] == 9 or cells[x][y] == 11 or
                    cells[x][y] == 12 or cells[x][y] == 13):
                return False
            else:
                return True


# For keeping track of current position coords
def getSurrounds(x, y):
    # Returns coords for the 4 adj squares in order NESW, or -1 if coords exceed maze boundary

    x0 = x
    y0 = y + 1
    x1 = x + 1
    y1 = y
    x2 = x
    y2 = y - 1
    x3 = x - 1
    y3 = y

    # If furthest x or y coord is greater than maze dimension, set to -1
    if x1 >= mazeDimx:
        x1 = -1
    if y0 >= mazeDimy:
        y0 = -1

    return x0, y0, x1, y1, x2, y2, x3, y3


def floodFill(x, y):
    # Init queue and drop in current cell
    q = Queue(maxsize=pow(mazeDimx, 2))
    q.put([x, y])

    while not q.empty():
        [xfront, yfront] = q.get()
        x0, y0, x1, y1, x2, y2, x3, y3 = getSurrounds(xfront, yfront)
        frontFloodVal = flood[xfront][yfront]
        # log('Current flood val at ' + str(xfront) + ', ' + str(yfront) + ' is ' + str(frontFloodVal))

        adjFloodVals = [100, 100, 100, 100]
        if x0 >= 0 and y0 >= 0:
            if isAccessible(xfront, yfront, x0, y0):
                adjFloodVals[0] = flood[x0][y0]
                # log('Flood val north is ' + str(flood[x0][y0]) + ' and accessible.')
        if x1 >= 0 and y1 >= 0:
            if isAccessible(xfront, yfront, x1, y1):
                adjFloodVals[1] = flood[x1][y1]
                # log('Flood val east [' + str(x1) + ', ' + str(y1) + '] is ' + str(flood[x1][y1]) + ' and accessible.')
        if x2 >= 0 and y2 >= 0:
            if isAccessible(xfront, yfront, x2, y2):
                adjFloodVals[2] = flood[x2][y2]
                # log('Flood val south is ' + str(flood[x2][y2]) + ' and accessible.')
        if x3 >= 0 and y3 >= 0:
            if isAccessible(xfront, yfront, x3, y3):
                adjFloodVals[3] = flood[x3][y3]
                # log('Flood val west is ' + str(flood[x3][y3]) + ' and accessible.')

        minVal = min(adjFloodVals)
        # log(minVal)

        if frontFloodVal <= minVal:
            flood[xfront][yfront] = minVal + 1
            # log('Added one')
            # log('Updated flood val at (' + str(x) + ', ' + str(y) + ') is ' + str(flood[xfront][yfront]))

            if x0 >= 0 and y0 >= 0:
                if isAccessible(xfront, yfront, x0, y0):
                    q.put([x0, y0])
                    # log('Added north cell')
            if x1 >= 0 and y1 >= 0:
                if isAccessible(xfront, yfront, x1, y1):
                    q.put([x1, y1])
                    # log('Added east cell')
            if x2 >= 0 and y2 >= 0:
                if isAccessible(xfront, yfront, x2, y2):
                    q.put([x2, y2])
                    # log('Added south cell')
            if x3 >= 0 and y3 >= 0:
                if isAccessible(xfront, yfront, x3, y3):
                    q.put([x3, y3])
                    # log('Added west cell')
        else:
            pass
        # log('Current queue size is: ' + str(q.qsize()) + '\n')


# Returns the direction to turn as L, R, F, or B
def toMove(x, y, xprev, yprev, orient):
    # Init surrounding cell coords, previous cell direction, and the adj flood values matrix
    # Set adj flood values impossibly high to be updated if accessible

    x0, y0, x1, y1, x2, y2, x3, y3 = getSurrounds(x, y)
    prev = 0
    adjFloodVals = [10000, 10000, 10000, 10000]
    beenThere = [2, 2, 2, 2]

    # Determine if the surrounding NESW cells are accessible and pull corresponding flood val, and determine previous
    # cell direction
    if isAccessible(x, y, x0, y0):
        if x0 == xprev and y0 == yprev:
            prev = 0

        if visited[x0][y0] == 1:
            beenThere[0] = 1
        else:
            beenThere[0] = 0
        adjFloodVals[0] = flood[x0][y0]

    if isAccessible(x, y, x1, y1):
        if x1 == xprev and y1 == yprev:
            prev = 1

        if visited[x1][y1] == 1:
            beenThere[1] = 1
        else:
            beenThere[1] = 0
        adjFloodVals[1] = flood[x1][y1]

    if isAccessible(x, y, x2, y2):
        if x2 == xprev and y2 == yprev:
            prev = 2

        if visited[x2][y2] == 1:
            beenThere[2] = 1
        else:
            beenThere[2] = 0
        adjFloodVals[2] = flood[x2][y2]

    if isAccessible(x, y, x3, y3):
        if x3 == xprev and y3 == yprev:
            prev = 3

        if visited[x3][y3] == 1:
            beenThere[3] = 1
        else:
            beenThere[3] = 0
        adjFloodVals[3] = flood[x3][y3]

    # log(beenThere)

    # Init current & minimum flood value, corresponding cell, as well as the number of valid moves
    currentVal = flood[x][y]
    minCell = 0
    numMovements = 0
    newMovements = 0

    # Determine num of valid moves (if accessible and less than current cell)
    for i in adjFloodVals:
        if (i != 1000) & (i < currentVal):
            numMovements += 1
    # log(numMovements)

    # Determine number of valid moves that have not been discovered
    for i in beenThere:
        if i == 0:
            newMovements += 1
    # log(newMovements)

    # If valid moves, check each adj flood val & identify valid move orient. If multiple valid moves,
    # favors undiscovered cell. If no valid moves, return no direction
    if numMovements != 0:
        for i in range(4):
            if adjFloodVals[i] < currentVal:
                if numMovements == 1:
                    minCell = i
                else:
                    if newMovements == 1:
                        minCell = i
                    else:
                        if i == prev:
                            pass
                        elif beenThere[i] == 1:
                            pass
                        else:
                            minCell = i
    else:
        return 'null'

    if minCell == orient:
        return 'F'
    elif (minCell == orient - 1) or (minCell == orient + 3):
        return 'L'
    elif (minCell == orient + 1) or (minCell == orient - 3):
        return 'R'
    else:
        return 'B'


def shortestPath(x, y, xprev, yprev, orient):
    while flood[x][y] != 0:
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

        API.setColor(x, y, 'G')
        API.moveForward()
        xprev = x
        yprev = y
        x, y = API.updateCoordinates(x, y, orient)

    API.setColor(x, y, 'G')


def showFlood():
    for x in range(mazeDimx):
        for y in range(mazeDimy):
            API.setText(x, y, str(flood[x][y]))


def main():
    x = 0
    y = 0
    xprev = 0
    yprev = 0
    orient = 0
    discovered = 0
    numPasses = 0
    doneMapping = False
    path = []
    pathPrev = []
    showFlood()
    log("Mapping maze using floodfill algorithm...")

    # Run until done pathfinding
    while (discovered < pow(mazeDimx, 2)) & (not doneMapping):
        if flood[x][y] == 0:
            if visited[x][y] == 0:
                visited[x][y] = 1
                discovered += 1
                API.setColor(x, y, "O")
            API.ackReset()
            x = 0
            y = 0
            xprev = 0
            yprev = 0
            orient = 0
            numPasses += 1
            # log(path)
            if path == pathPrev:
                doneMapping = True
            pathPrev = path
            path = []
            log('Found a path to the center, back to the beginning...')
            continue

        else:
            # Get current wall layout & update maze

            L = API.wallLeft()
            R = API.wallRight()
            F = API.wallFront()
            updateWalls(x, y, orient, L, R, F)
            # log('Mapping walls at current pos...' + str(x) + ', ' + str(y))

            if (x == 0) & (y == 0):
                cells[0][0] = 11
                API.setWall(x, y, 's')

            # Get target cell direction and turn mouse accordingly. If no target cell available, update floodfill and
            # recalc target cell
            direction = toMove(x, y, xprev, yprev, orient)
            if direction == 'null':
                # log('No valid moves at ' + str(x) + ', ' + str(y) + '... flooding...')
                floodFill(x, y)
                # log('finished flood number ' + str(numFlood))
                showFlood()
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
                # log(discovered)

            showFlood()
            API.setColor(x, y, "O")
            API.moveForward()
            path.append([x, y])
            xprev = x
            yprev = y
            x, y = API.updateCoordinates(x, y, orient)

    log('Successfully mapped the fastest path to the center.')
    # API.clearAllColor()
    shortestPath(x, y, xprev, yprev, orient)


if __name__ == "__main__":
    main()
