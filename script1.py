# -- Set a GPS time:
t0 = 1186741861.5

#-- Choose detector as H1, L1, or V1
detector = 'L1'

import matplotlib.pyplot as plt
from gwpy.timeseries import TimeSeries

# -- Turn on interactive plotting
plt.ion()
center = int(t0)  #-- Round GPS time to nearest second
strain = TimeSeries.fetch_open_data(detector, center-16, center+16)
"""
fig2 = strain.asd(fftlength=8).plot()
fig2.show()
plt.xlim(10,2000)
plt.ylim(1e-24, 1e-19)


white_data = strain.whiten()
bp_data = white_data.bandpass(30, 400)
fig3 = bp_data.plot()
fig3.show()
plt.xlim(t0-0.2, t0+0.1)
"""
dt = 0.15  #-- Set width of q-transform plot, in seconds
hq = strain.q_transform(outseg=(t0-dt, t0+dt))
fig4 = hq.plot()
fig4.show()
ax = fig4.gca()
ax.set_ylim(bottom=0,top=600)
ax.set_ylabel("Frekvence [Hz]")
ax.set_xlabel("Čas [s]")
ax.grid(False)
ax.set_yscale('log')
try: fig4.colorbar(label="Normalized energy")
except: pass
