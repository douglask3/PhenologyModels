#!/usr/bin/env python2

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import datetime, time

__author__ = 'Rhys Whitley, Douglas Kelley, Martin De Kauwe'
__email__ = 'rhys.whitley@mq.edu.au'
__created__ = datetime.datetime(2015,1,14)
__modified__ = time.strftime("%c")
__version__ = '1.0'
__status__ = 'prototype'

class spring(object):

    def __init__(self, time):
        self.mass = 1
        self.force_envir = 1
        self.dt = 0.01
        self.k_hooke = 1
        self.k_drag = 2
        self.time = time

    def hookes_law(self, x):
        # Hooke's Law for a spring
        return -self.k_hooke*x

    def dynamic(self):
    # set zeros (could have empty list)
        displ = [0 for i in range(self.time)]
        accel = [0 for i in range(self.time)]
        veloc = [0 for i in range(self.time)]

        # instantaneous vectors
        for t in range(self.time-1):
            force_drag = -self.k_drag*veloc[t]
            force_resist = self.hookes_law( displ[t] )
            force_total = self.force_envir + force_resist + force_drag
            accel[t+1] = force_total/self.mass
            veloc[t+1] = veloc[t] + accel[t+1]*self.dt
            displ[t+1] = displ[t] + veloc[t+1]*self.dt

        # return wave as tuple
        motion = (accel, veloc, displ)
        return motion

    def plot_spring_dynamics(self):
        motion = self.dynamic()
        pcolors = cm.rainbow( np.linspace(0,0.5,len(motion)))
        siglabs = [ r'$a(t)$', r'$v(t)$', r'$x(t)$']

        fig = plt.figure( figsize=(8,4) )
        for i in range( len(motion) ):
            plt.plot( motion[i], color=pcolors[i],
                            label=siglabs[i], linestyle='-', lw=2 )
        plt.legend( loc=1 )
        #ax.set_xlabel( r'$time (t)$', fontsize=14 )
        #fig.set_ylabel( r'vector$', fontsize=14 )
        plt.savefig("pendulum_sig.pdf")


tseries = 2000
x = spring( tseries )
motion = x.dynamic()
x.plot_spring_dynamics()
