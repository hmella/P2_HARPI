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

        # Load image
        I = load_pyobject(folder+filename)

        # Rescale images
        if folder is not 'inputs/masks/': 
            r = dict()
            for (key, value) in I.items():
                r[key] = value['RescaleSlope']*value['Image'] + value['RescaleIntercept']
            I = r['real'] + 1j*r['complex']
    
            # Export matlab object
            savemat(folder+filename[0:-4]+'.mat',{'I':I})

        else:

            # Export matlab object
            savemat(folder+filename[0:-4]+'.mat',{'M':I})          

