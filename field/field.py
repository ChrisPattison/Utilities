#!/bin/python
import matplotlib.pyplot as plt
import numpy as np
import scipy.interpolate as interpolate
import math
import itertools

def bs(x,y):
	return np.array(1.e-7*np.sum((-pI*(y-py), pI*(x-px))/((x-px)**2+(y-py)**2), axis=1))

turns = 600.
current = .855

px = np.concatenate((np.ones(turns)*-0.015,np.ones(turns)*0.015))
py = np.concatenate((np.linspace(-0.025/2,0.025/2,turns),np.linspace(-0.025/2,0.025/2,turns)))
pI = np.concatenate((np.ones(turns)*-current,np.ones(turns)*current))

x,y = np.meshgrid(np.linspace(-0.03,0.03,2000),np.linspace(-0.03,0.03,2000))

bfield = np.array([[bs(x[i,j],y[i,j]) for j in range(x.shape[1])] for i in range(x.shape[0])])

fig = plt.figure(figsize=(32, 24), dpi=100)
ax = fig.add_subplot(1,1,1)

ax.xlim=(np.min(x),np.max(x))
ax.ylim=(np.min(y),np.max(y))

cm = ax.pcolor(x,y, np.linalg.norm(bfield,axis=2),cmap=plt.cm.viridis,vmax=np.linalg.norm(bfield[bfield.shape[0]/2,bfield.shape[1]/2,:]))
sp = ax.streamplot(x,y,bfield[:,:,0],bfield[:,:,1],color='0.5',arrowsize=2.5)

ax.set_xlabel('x [m]')
ax.set_ylabel('y [m]')
ax.set_title('Magnetic Field [T]')
fig.colorbar(cm, ax=ax)
plt.savefig('field.png')
print(bfield[bfield.shape[0]/2,bfield.shape[1]/2,:])
