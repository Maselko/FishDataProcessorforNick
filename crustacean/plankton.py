#Filename : plankton.py
#written by Sebastian Tamon Hascilowicz
#on


import csv
import numpy as np
from scipy import interpolate


def reader(filename):
    """reader reads the .csv file and returns the data as list"""
    with open(filename, 'r') as fl:
        reader = csv.reader(fl, dialect = 'excel')
        data = list(reader)
        tblock = data[0]
        del data[0]
        l1 = len(data)
        l2 = len(data[1])
        for i in range(l1):
            for j in range(l2):
                d = data[i][j]
                data[i][j] = float(d)
        for k in range(len(tblock)):
            lows = tblock[k]
            nospace = lows.lower()
            tblock[k] = nospace.replace(" ", "")
    return tblock, data

def xyext(tblock, data):
    """this function identifies the data andconverts the data to
    the list of [time, x, y] in each trial list"""
    for i in range(len(tblock)):
        if tblock[i] in ['time']:
            tloc = i
        elif tblock[i] in ['x']:
            xloc = i
        elif tblock[i] in ['y']:
            yloc = i
        elif tblock[i] in ['id']:
            iloc = i
        elif tblock[i] in ['xvelocity']:
            xvloc = i
        elif tblock[i] in ['yvelocity']:
            yvloc = i
    i = 0
    iv = data[0][iloc]
    coord = []
    crd = []
    for i in range(len(data)):
        if iv == data[i][iloc]:
            cod = [data[i][tloc],data[i][xloc],data[i][yloc],data[i][xvloc],data[i][yvloc],data[i][iloc]]
            crd.append(cod)
        else:
            coord.append(crd)
            crd = []
            iv = data[i][iloc]
            cod = [data[i][tloc],data[i][xloc],data[i][yloc],data[i][xvloc],data[i][yvloc],data[i][iloc]]
            crd.append(cod)
    return coord


def exporter(sortdata):
    output = [['Time', 'x', 'y', 'x Velocity', 'y Velocity', 'ID', 'Turn ang.', 'Speaker ang.', 'spl']]
    i = 0
    for i in range(len(sortdata)):
        for j in range(len(sortdata[i])):
            output.append(sortdata[i][j])
    np.savetxt("out.csv", output, delimiter=",", fmt='%s')
    return output


def angl(p1, p2):
    """This function takes two tuples and returns the tangent angle to the y"""
    if p2[1] - p1[1] > 0:
        ang = np.arctan((p2[0] - p1[0]) / (p2[1] - p1[1]))
    elif p2[1] - p1[1] < 0:
        if p2[0] - p1[0] >= 0:
            ang = np.pi + np.arctan((p2[0] - p1[0]) / (p2[1] - p1[1]))
        else:
            ang = - np.pi + np.arctan((p2[0] - p1[0]) / (p2[1] - p1[1]))
    else:
        if p2[0] - p1[0] > 0:
            ang = np.pi/2
        elif p2[0] - p1[0] < 0:
            ang = -np.pi/2
        else:
            ang = 2 * np.pi
    return ang


def angler(data):
    """this function returns the angles as list"""
    for i in range(len(data)):
        j = 0
        k = 0
        ### a123 calculation
        for j in range(len(data[i]) - 2):
            # p assignment
            if data[i][j][2] * data[i][j + 1][2] >= 0 and data[i][j + 1][2] * data[i][j + 2][2] >= 0:
                p1 = (data[i][j][1], data[i][j][2])
                p2 = (data[i][j + 1][1],data[i][j + 1][2])
                p3 = (data[i][j + 2][1],data[i][j + 2][2])
            elif data[i][j][2] * data[i][j + 1][2] < 0 and data[i][j + 1][2] * data[i][j + 2][2] >= 0:
                p2 = (data[i][j + 1][1],data[i][j + 1][2])
                p3 = (data[i][j + 2][1],data[i][j + 2][2])
                if p2[1] >= 0:
                    p1 = (data[i][j][1], data[i][j][2] - 60)
                else:
                    p1 = (data[i][j][1], data[i][j][2] + 60)
            elif data[i][j][2] * data[i][j + 1][2] >= 0 and data[i][j + 1][2] * data[i][j + 2][2] < 0:
                p1 = (data[i][j][1], data[i][j][2])
                p2 = (data[i][j + 1][1],data[i][j + 1][2])
                if p2[1] >= 0:
                    p3 = (data[i][j + 2][1],data[i][j + 2][2] - 60)
                else:
                    p3 = (data[i][j + 2][1],data[i][j + 2][2] + 60)
            #a123 calculation
            a12 = angl(p1, p2)
            a23 = angl(p2, p3)
            if a12 != 2 * np.pi and a23 != 2 * np.pi:
                angle = a23 - a12
                data[i][j+1].append(angle)
                a0 = a23
            elif a12 == 2 * np.pi and a23 != 2 * np.pi and j >= 1:
                angle = a23 - a0
                data[i][j+1].append(angle)
                a0 = a23
            else:
                data[i][j+1].append(0)
        data[i][0].append('na')
        data[i][-1].append('na')
        ### a12s calculation

        for k in range(len(data[i]) - 1):
            if data[i][k][2] * data[i][k + 1][2] >= 0:
                p1 = (data[i][k][1], data[i][k][2])
                p2 = (data[i][k + 1][1],data[i][k + 1][2])
                if p2[1] > 0:
                    ps = (0, -20)
                else:
                    ps = (0, -20)
                a12 = angl(p1, p2)
                a2s = angl(p2, ps)
                if a12 != 2 * np.pi:
                    angle = a2s - a12
                    data[i][k + 1].append(angle)
                    sa0 = angle
                else:
                    data[i][j+1].append(sa0)
            else:
                p2 = (data[i][k + 1][1],data[i][k + 1][2])
                if p2[1] > 0:
                    p1 = (data[i][k][1], data[i][k][2] - 60)
                    ps = (0, -20)
                else:
                    p1 = (data[i][k][1], data[i][k][2] + 60)
                    ps = (0, -20)
                a12 = angl(p1, p2)
                a2s = angl(p2, ps)
                angle = a2s - a12
                data[i][k + 1].append(angle)
                sa0 = angle
        data[i][0].append('na')
    return data


def gillnetmaker(filename):
    useless, gillnet = reader(filename)
    x = []
    y = []
    z = []
    i = 0
    j = 0
    for i in range(len(useless)):#check this bit with Nick
        if useless[i] in ['x']:
            xloc = i
        elif useless[i] in ['y']:
            yloc = i
        elif useless[i] in ['z']:
            zloc = i
    for j in range(len(gillnet)):
        x.append(gillnet[j][xloc])
        y.append(gillnet[j][yloc])
        z.append(gillnet[j][zloc])
    return y, x, z


def interpol(coord, gillnet):
    x, y, z = gillnetmaker(gillnet)
    net = interpolate.interp2d(x, y, z, kind='cubic')
    for i in range(len(coord)):
        for j in range(len(coord[i])):
            cx = coord[i][j][1]
            cy = coord[i][j][2]
            caughtfish = int(net(cx, cy))
            coord[i][j].append(caughtfish)
    return coord


#PROGRAM FISH
tblock, data = reader('in.csv')
coord = xyext(tblock, data)
angles = angler(coord)
fishboat = interpol(angles, 'gillnet.csv')
out = exporter(fishboat)
#END PROGRAM FISH
