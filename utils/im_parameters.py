import numpy as np

# Resolutions
resolutions = [np.array([200, 200, 1])]

# Encoding frequencies
tag_spacings = np.array([0.0039, 0.0078, 0.0156])                         # tag spacings [m]
cfrequencies = [np.array([2*np.pi/l,2*np.pi/l,0]) for l in tag_spacings]  # encoding frequency [rad/m]

# Noise levels
noise_levels = np.array([6e-02])
