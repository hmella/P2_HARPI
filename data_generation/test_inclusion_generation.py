import numpy as np

from utils.args_parser import *
from utils.generation import (generate_inclusion_reference,
                              generate_inclusion_sine)
from utils.im_parameters import cfrequencies, inc_factors, resolutions

##################
# DATA GENERATION
##################

# Generate REFERENCE
if args.generate_reference:
    generate_inclusion_reference(resolutions, [cfrequencies[1]], inc_factors)

# Generate SINE
if args.generate_sine:
    generate_inclusion_sine(resolutions, [cfrequencies[1]], inc_factors)
