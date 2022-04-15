import random

class GenRandom:
    '''GenRandom class'''
    def __init__(self, x: int, y: int):
        random.seed() # initial random num generator with system time
        self.sha: int = random.randint(0, 3) # shape
        self.x: int = random.randint(0, x) # x-coordinate
        self.y: int = random.randint(0, y) # y-coordinate
        self.rad: int = random.randint(0, 100) # circle radius
        self.rx: int = random.randint(10, 30) # ellipse width
        self.ry: int = random.randint(10, 30) # ellipse height
        self.w: int = random.randint(10, 100) # rectangle width
        self.h: int = random.randint(10, 100) # rectangle height
        self.r: int = random.randint(0, 255) # Red in RGB
        self.g: int = random.randint(0, 255) # Green in RGB
        self.b: int = random.randint(0, 255) # Blue in RBG
        self.op: float = round(random.random(), 1) # shape opacity


class ArtConfig:
    '''ArtConfig class'''
    def __init__(self, x: int, y: int, n: int):
        self.__shapes: list[list] = [] # list of generated shapes
        self.__shapes.append(['CNT', 'SHA', 'X', 'Y', 'RAD', 'RX', 'RY', 'W', 'H', 'R', 'G', 'B', 'OP']) # table header
        for i in range(n):
            r: GenRandom = GenRandom(x, y) # get a random shape
            # add a list of shape properties to the list
            self.__shapes.append([i, r.sha, r.x, r.y, r.rad, r.rx, r.ry, r.w, r.h, r.r, r.g, r.b, r.op])

    def print_table(self):
        '''print_table method'''
        # list of random shape list with string type shape properties
        shapes_str: list[list] = [list(map(str, shape)) for shape in self.__shapes]
        # print shapes_str in a table format
        print('\n'.join([''.join(['{: >5}'.format(x) for x in r]) for r in shapes_str]))

def main():
    '''main method'''
    # art configuration instance of 10 shapes in a 500 by 500 canvas
    config: ArtConfig = ArtConfig(500, 500, 10)
    config.print_table() # print table of shapes

main()
                
