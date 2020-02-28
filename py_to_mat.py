import os

import numpy as np
from PyMRStrain.IO import load_pyobject
from scipy.io import savemat

# Input folders
folders = ['inputs/noise_free_images/',
           'inputs/noisy_images/',
           'inputs/masks/']

for folder in folders:
    for filename in os.listdir(folder):
        fname, ext = os.path.splitext(filename)
        if ext != '.mat':

            # Load image
            I = load_pyobject(folder+filename)

            if folder is not 'inputs/masks/': 
                # Rescale images
                r = dict()
                for (key, value) in I.items():
                    r[key] = value['RescaleSlope']*value['Image'] + value['RescaleIntercept']
                I = r['real'] + 1j*r['complex']
        
                # Export matlab object
                savemat(folder+fname+'.mat',{'I':I})
            else:
                # Export matlab object
                savemat(folder+fname+'.mat',{'M':I})          

