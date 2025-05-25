from gwpy.timeseries import TimeSeries
import os
from scipy.io import loadmat
import matplotlib.pyplot as plt
import h5py

t0 = 1186741861.5
dt=0.5
start=t0-dt
new_strain_path="C:\\Users\\rayan\\MATLAB Drive\\PRJ\\Data\\GW2017\\new_strain"
new_strain_raw = loadmat(new_strain_path,appendmat=True)
strain=[]
new_strain_raw = new_strain_raw['new_strain']
new_strain_raw = new_strain_raw[0]

with h5py.File("strain.hdf5", "r") as f:
    strain=f['Strain'][:]

sample_rate = 4096
strain = TimeSeries(strain,unit=None, t0=start, dt=None, sample_rate=sample_rate, times=None, channel=None, name=None)
new_strain=TimeSeries(new_strain_raw,unit=None, t0=start, dt=None, sample_rate=sample_rate, times=None, channel=None, name=None)

print(f"Strain length: {len(strain)}, Duration: {strain.duration}")


hq = strain.q_transform()
fig4 = hq.plot()
fig4.show()
"""
hq = new_strain.q_transform()
fig4 = hq.plot()
fig4.show()"""

print("script sucessfull")