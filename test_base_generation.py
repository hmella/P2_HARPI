import numpy as np

from utils.args_parser import *
from utils.generation import generate_phantoms, generate_sine
from utils.im_parameters import cfrequencies, resolutions

##################
# INPUT PARAMETERS
##################

# Patients array
patients = np.ones([args.nb_data,],dtype=np.bool)
patients[0:int(patients.size/2)] = False 


##################
# DATA GENERATION
##################

# Generate phantoms
if args.generate_parameters:
    generate_phantoms(args.nb_samples,ini=args.initial_data,fin=args.final_data)

# Generate SINE
generate_sine(resolutions, cfrequencies, patients, ini=args.initial_data,
                fin=args.final_data, noise_free=args.noise_free)
