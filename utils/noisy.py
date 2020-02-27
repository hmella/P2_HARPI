import numpy as np
from PyMRStrain import *

# Add noise to CSPAMM
def sine_noisy_images(resolutions, frequencies, noise_levels, ini=0, fin=0):

    # Create folder
    if not os.path.isdir('inputs/noisy_images'):
        os.mkdir('inputs/noisy_images')

    # Resolutions loop
    for (rn, r) in enumerate(resolutions):

        # Frequencies loop
        for (fn, f) in enumerate(frequencies):
         
            # Data loop
            for d in range(ini,fin):

                # Load kspaces
                kspace = load_pyobject('inputs/kspaces/I_{:03d}_{:02d}_{:02d}.pkl'.format(d,fn,rn))

                # Rescale kspaces
                kspace.rescale()

                # Noise loop
                for (nn, n) in enumerate(noise_levels):

                    # Add noise to kspaces
                    kspace.k = add_cpx_noise(kspace.k, sigma=n)

                    # Get images and scale
                    I = scale_image(kspace.to_img(),mag=False,real=True,compl=True)

                    # Export noisy kspaces
                    save_pyobject(I,'inputs/noisy_images/I_{:03d}_{:02d}_{:02d}_{:02d}.pkl'.format(d,fn,rn,nn))