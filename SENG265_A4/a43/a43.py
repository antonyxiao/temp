#!/usr/bin/env python3
from typing import IO
import random

class Circle:
    '''Circle class'''
    def __init__(self, cir: tuple, col: tuple):
        self.cx: int = cir[0] # x-coordinate of the center
        self.cy: int = cir[1] # y-coordinate of the center
        self.rad: int = cir[2] # radius
        self.red: int = col[0] # Red in RGB
        self.green: int = col[1] # Green in RGB
        self.blue: int = col[2] # Blue in RGB
        self.op: float = col[3] # shape opacity

class Ellipse:
    '''Ellipse class'''
    def __init__(self, elp: tuple, col: tuple):
        self.cx: int = elp[0] # x-coordinate of the center
        self.cy: int = elp[1] # y-coordinate of the center
        self.rx: int = elp[2] # horizontal radius
        self.ry: int = elp[3] # vertical radius
        self.red: int = col[0] # Red in RGB
        self.green: int = col[1] # Blue in RGB
        self.blue: int = col[2] # Green in RGB
        self.op: float = col[3] # shape opacity

class Rectangle:
    '''Rectangle class'''
    def __init__(self, rect: tuple, col: tuple):
        self.rx = rect[0] # x-coordinate
        self.ry = rect[1] # y-coordinate
        self.width = rect[2] # width of rectangle
        self.height = rect[3] # height of rectangle
        self.red: int = col[0] # Red in RGB
        self.green: int = col[1] # Green in RGB
        self.blue: int = col[2] # Blue in RGB
        self.op: float = col[3] # shape opacity

class ProEpiloge:
    '''ProEpiloge class'''
    def __init__(self, f: IO[str]):
        self.file = f

    def openSVGcanvas(self, t: int, canvas: tuple):
         '''openSVGcanvas method'''
         ts: str = "   " * t
         self.writeHTMLcomment(t, "Define SVG drawing box") # commenting
         self.file.write(f'{ts}<svg width="{canvas[0]}" height="{canvas[1]}">\n') # svg opening tag

    def closeSVGcanvas(self, t: int):
        '''closeSVGcanvas method'''
        ts: str = "   " * t
        self.file.write(f'{ts}</svg>\n') # svg closing tag
        self.file.write(f'</body>\n') # body closing tag
        self.file.write(f'</html>\n') # html closing tag

    def writeHTMLcomment(self, t: int, com: str):
        '''writeHTMLcomment method'''
        ts: str = "   " * t
        self.file.write(f'{ts}<!--{com}-->\n') # write a html comment

    def writeHTMLline(self, t: int, line: str):
         '''writeLineHTML method'''
         ts = "   " * t
         self.file.write(f"{ts}{line}\n") # write a html line with specific indenting

    def writeHTMLHeader(self, winTitle: str):
        '''writeHeadHTML method'''
        self.writeHTMLline(0, "<html>") # html opening tag
        self.writeHTMLline(0, "<head>") # head opening tag
        self.writeHTMLline(1, f"<title>{winTitle}</title>") # title line
        self.writeHTMLline(0, "</head>") # head closing tag
        self.writeHTMLline(0, "<body>") # body opening tag

class GenRandom:
    '''GenRandom class'''
    def __init__(self, x: int, y: int):
        random.seed() # inital random num generator with system time
        self.sha = random.randint(0, 3) # shape
        self.x = random.randint(0, x) # x-coordinate
        self.y = random.randint(0, y) # y-coordinate
        self.rad = random.randint(0, 100) # circle radius
        self.rx = random.randint(10, 30) # ellipse width
        self.ry = random.randint(10, 30) # ellipse height
        self.w = random.randint(10, 100) # rectangle width
        self.h = random.randint(10, 100) # rectangle height
        self.r = random.randint(0, 255) # Red in RGB
        self.g = random.randint(0, 255) # Green in RGB
        self.b = random.randint(0, 255) # Blue in RGB
        self.op = round(random.random(), 1) # shape opacity

'''
Stores the properties of a randomly generated Shape
'''
class Shape:
    '''Shape class'''
    def __init__(self, i, sha, x, y, rad, rx, ry, w, h, r, g, b, op):
        self.i: int = i # shape counter
        self.sha: int = sha # shape
        self.x: int = x # x-coordinate
        self.y: int = y # y-coordinate
        self.rad: int = rad # circle radius
        self.rx: int = rx # ellipse width
        self.ry: int = ry # ellipse height
        self.w: int = w # rectangle width
        self.h: int = h # rectangle height
        self.r: int = r # Red in RGB
        self.g: int = g # Green in RGB
        self.b: int = b # Blue in RGB
        self.op: float = op # shape opacity

class ArtConfig:
    '''ArtConfig class'''
    def __init__(self, x: int, y: int, n: int):
        self.__shapes: list[Shape] = [] # list of generated shapes
        for i in range(n):
            r: GenRandom = GenRandom(x, y) # get a random shape
            s: Shape = Shape(i, r.sha, r.x, r.y, r.rad, r.rx, r.ry, r.w, r.h, r.r, r.g, r.b, r.op) # get Shape object
            self.__shapes.append(s) # add Shape object to list 

    def get_shapes(self):
        '''get_shapes method'''
        return self.__shapes # return the list of randomly generated Shape objects

def drawCircleLine(f: IO[str], t: int, c: Circle):
    '''drawCircle method'''
    ts: str = "   " * t
    # circle element
    line: str = f'<circle cx="{c.cx}" cy="{c.cy}" r="{c.rad}" fill="rgb({c.red}, {c.green}, {c.blue})" fill-opacity="{c.op}"></circle>'
    f.write(f"{ts}{line}\n") # write to file

def drawEllipseLine(f: IO[str], t: int, e: Ellipse):
    '''drawEllipseLine method'''
    ts: str = "   " * t
    # ellipse element
    line: str = f'<ellipse cx="{e.cx}" cy="{e.cy}" rx="{e.rx}" ry="{e.ry}" fill="rgb({e.red}, {e.green}, {e.blue})" fill-opacity="{e.op}"></ellipse>'
    f.write(f"{ts}{line}\n") # write to file

def drawRectangleLine(f: IO[str], t: int, r: Rectangle):
    '''drawRectangleLine method'''
    ts: str = "   " *  t # write to file
    # rectangle element
    line: str = f'<rect x="{r.rx}" y="{r.ry}" width="{r.width}" height="{r.height}" fill="rgb({r.red}, {r.green}, {r.blue})" fill-opar.ty="{r.op}"></rect>'
    f.write(f"{ts}{line}\n") # write to file

def genArt(f: IO[str], t: int, config: ArtConfig):
    '''genArt method'''
    # get list of shapes from art config instance
    shapes = config.get_shapes()

    # traverse through the shapes list 
    for sh in shapes:
        # circle
        if (sh.sha == 0):
            # draw circle with generated properties
            drawCircleLine(f, t, Circle((sh.x, sh.y, sh.rad), (sh.r,sh.g,sh.b,sh.op)))
        # rectangle
        elif (sh.sha == 1):
            # draw rectangle with generated properties
            drawRectangleLine(f, t, Rectangle((sh.x, sh.y, sh.w, sh.h),(sh.r,sh.g,sh.b,sh.op)))
        # ellipse
        elif (sh.sha == 2):
            # draw ellipse with generated properties
            drawEllipseLine(f, t, Ellipse((sh.x, sh.y, sh.rx, sh.ry),(sh.r,sh.g,sh.b,sh.op)))

def writeHTMLfile():
    '''writeHTMLfile method'''
    fnam: str = "myPart1Art.html" # file name
    winTitle = "My Art" # title of html page
    f: IO[str] = open(fnam, "w") # open file for writing

    # canvas size
    SVGx = 500
    SVGy = 300

    # how many shapes to be generated
    shape_count = 15

    # art configuration instance
    config = ArtConfig(SVGx, SVGy, shape_count)

    p = ProEpiloge(f) # Pro/Epiloge object
    p.writeHTMLHeader(winTitle) # HTML Pro/Epiloge
    p.openSVGcanvas(1, (SVGx,SVGy)) # SVG Prologe
    genArt(f, 2, config) # create art
    p.closeSVGcanvas(1) # SVG Epiloge
    f.close() # close file

def main():
    '''main method'''
    writeHTMLfile()

main()
