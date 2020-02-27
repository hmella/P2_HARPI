import numpy as np

from utils.args_parser import *
from utils.im_parameters import cfrequencies, noise_levels, resolutions
from utils.noisy import sine_noisy_images

##################
# INPUT PARAMETERS
##################

# Patients array
patients = np.ones([args.nb_data,],dtype=np.bool)
patients[0:int(patients.size/2)] = False 


##################
# DATA GENERATION
##################

# Add noise to CSPAMM images
sine_noisy_images(resolutions, cfrequencies, noise_levels, ini=args.initial_data)
