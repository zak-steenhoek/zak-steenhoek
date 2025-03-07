import API
import sys


def log(string):
    sys.stderr.write("{}\n".format(string))
    sys.stderr.flush()


def main():
    log("Running...")
    x = 0
    y = 0
    while True:
        if not API.wallLeft():
            API.turnLeft()
        while API.wallFront():
            API.turnRight()
        API.moveForward()


if __name__ == "__main__":
    main()
