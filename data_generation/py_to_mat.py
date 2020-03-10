import os

import numpy as np
from PyMRStrain.IO import load_pyobject
from scipy.io import savemat

# Input folders
folders = ['inputs/noise_free_images/',
           'inputs/noisy_images/',
           'inputs/masks/',
           'inputs/reference_images/']

for folder in folders:
    for filename in os.listdir(folder):
        fname, ext = os.path.splitext(filename)
        if ext != '.mat':

            # Load image
            I = load_pyobject(folder+filename)

            # Export matlab object
            if folder is not 'inputs/masks/':         
                savemat(folder+fname+'.mat',{'I':I})
            else:
                savemat(folder+fname+'.mat',{'M':I})          

