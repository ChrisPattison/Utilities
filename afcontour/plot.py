#!/bin/python
import matplotlib.pyplot as plt

data = open("out.csv","r")
lines = data.readlines()
lines = [l.strip() for l in lines]
lines.append("")

n1 = 0
n2 = lines.index("")
camberx = [float(l.split(',')[0]) for l in lines[n1:n2]]
cambery = [float(l.split(',')[1]) for l in lines[n1:n2]]

n1 = n2 + 1
n2 = n1 + lines[n1:].index("")
pressurex = [float(l.split(',')[0]) for l in lines[n1:n2]]
pressurey = [float(l.split(',')[1]) for l in lines[n1:n2]]

n1 = n2 + 1
n2 = n1 + lines[n1:].index("")
suctionx = [float(l.split(',')[0]) for l in lines[n1:n2]]
suctiony = [float(l.split(',')[1]) for l in lines[n1:n2]]

fig = plt.figure()
ax = fig.add_subplot(1,1,1)
ax.plot(camberx,cambery,label='Camber')
ax.plot(pressurex,pressurey,label='Pressure')
ax.plot(suctionx,suctiony,label='Suction')

r = (max(camberx)-min(camberx))/2
ax.set_ylim(-r,r)
ax.set_aspect('equal')
ax.set_xlabel('x')
ax.set_ylabel('y')
plt.savefig('plot.png')
