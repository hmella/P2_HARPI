import numpy as np

from utils.args_parser import *
from utils.im_parameters import cfrequencies, noise_levels, resolutions
from utils.generation import sine_noisy_images

##################
# INPUT PARAMETERS
##################


##################
# DATA GENERATION
##################

# Add noise to CSPAMM images
sine_noisy_images(resolutions, cfrequencies, noise_levels,
                  ini=args.initial_data, fin=args.final_data)
