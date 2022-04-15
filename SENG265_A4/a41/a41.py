#!/usr/bin/env python3
'''Assignment 4 Part 1 template'''
print(__doc__)

from typing import IO

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
        

class Rectangle:
    '''Rectangle class'''
    def __init__(self, rect: tuple, col: tuple):
        self.rx: int = rect[0] # x-coordinate
        self.ry: int = rect[1] # y-coordinate
        self.width: int = rect[2] # width of rectangle
        self.height: int = rect[3] # height of rectangle
        self.red: int = col[0] # Red in RGB
        self.green: int = col[1] # Green in RGB
        self.blue: int = col[2] # Blue in RGB
        self.op: float = col[3] # shape opacity

class ProEpiloge:
    '''ProEpiloge class'''
    def __init__(self, f: IO[str]):
        self.file: IO[str] = f

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
         ts: str = "   " * t
         self.file.write(f"{ts}{line}\n") # write a html line with specific indenting

    def writeHTMLHeader(self, winTitle: str):
        '''writeHeadHTML method'''
        self.writeHTMLline(0, "<html>") # html opening tag
        self.writeHTMLline(0, "<head>") # head opening tag
        self.writeHTMLline(1, f"<title>{winTitle}</title>") # title line
        self.writeHTMLline(0, "</head>") # head closing tag
        self.writeHTMLline(0, "<body>") # body opening tag

def drawCircleLine(f: IO[str], t: int, c: Circle):
    '''drawCircle method'''
    ts: str = "   " * t
    # circle element
    line: str = f'<circle cx="{c.cx}" cy="{c.cy}" r="{c.rad}" fill="rgb({c.red}, {c.green}, {c.blue})" fill-opacity="{c.op}"></circle>'
    f.write(f"{ts}{line}\n") # write to file
        
def drawRectangleLine(f: IO[str], t: int, r: Rectangle):
    '''drawRectangleLine method'''
    ts: str = "   " * t
    # rectangle element
    line: str = f'<rect x="{r.rx}" y="{r.ry}" width="{r.width}" height="{r.height}" fill="rgb({r.red}, {r.green}, {r.blue})" fill-opar.ty="{r.op}"></rect>'
    f.write(f"{ts}{line}\n") # write to file

def genArt(f: IO[str], t: int):
   '''genART method'''
   # drawing circles and rectangles
   drawCircleLine(f, t, Circle((50,50,50), (255,0,0,1.0)))
   drawCircleLine(f, t, Circle((150,50,50), (255,0,0,1.0)))
   drawCircleLine(f, t, Circle((250,50,50), (255,0,0,1.0)))
   drawCircleLine(f, t, Circle((350,50,50), (255,0,0,1.0)))
   drawRectangleLine(f, t, Rectangle((400,10,150, 80), (255,0,0,1.0)))
   drawCircleLine(f, t, Circle((50,250,50), (0,0,255,1.0)))
   drawCircleLine(f, t, Circle((150,250,50), (0,0,255,1.0)))
   drawCircleLine(f, t, Circle((250,250,50), (0,0,255,1.0)))
   drawCircleLine(f, t, Circle((350,250,50), (0,0,255,1.0)))
   drawRectangleLine(f, t, Rectangle((400, 210, 150, 80), (0,0,255,1.0)))

def writeHTMLfile():
    '''writeHTMLfile method'''
    fnam: str = "myPart1Art.html" # file name
    winTitle: str = "My Art" # title of html page
    f: IO[str] = open(fnam, "w") # open file for writing
    p: ProEpiloge = ProEpiloge(f) # Pro/Epiloge object
    p.writeHTMLHeader(winTitle) # HTML Pro/Epiloge
    p.openSVGcanvas(1, (500,300)) # SVG Prologe
    genArt(f, 2) # create art
    p.closeSVGcanvas(1) # SVG Epiloge
    f.close() # close file

def main():
    '''main method'''
    writeHTMLfile()

main()
