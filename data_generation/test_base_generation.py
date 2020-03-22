import numpy as np

from utils.args_parser import *
from utils.generation import (generate_phantoms, generate_reference,
                              generate_sine)
from utils.im_parameters import cfrequencies, resolutions

##################
# INPUT PARAMETERS
##################

# Patients array
patients = np.zeros([args.nb_data,],dtype=np.bool)


##################
# DATA GENERATION
##################

# Generate phantoms
if args.generate_parameters:
    generate_phantoms(args.nb_samples,ini=args.initial_data,fin=args.final_data)

# Generate REFERENCE
if args.generate_reference:
    generate_reference(resolutions, cfrequencies, patients, ini=args.initial_data,
                    fin=args.final_data, noise_free=args.noise_free)

# Generate SINE
if args.generate_sine:
    generate_sine(resolutions, cfrequencies, patients, ini=args.initial_data,
                    fin=args.final_data, noise_free=args.noise_free)
