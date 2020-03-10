import numpy as np

# Resolutions
resolutions = [np.array([100, 100, 1])]

# Encoding frequencies
tag_spacings = np.array([0.0029, 0.0058, 0.0080, 0.0116])                 # tag spacings [m]
cfrequencies = [np.array([2*np.pi/l,2*np.pi/l,0]) for l in tag_spacings]  # encoding frequency [rad/m]

# Noise levels
noise_levels = np.array([10e-02])
