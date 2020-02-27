import os

from PyMRStrain import *


# Parameters generation
def generate_phantoms(nb_samples,ini=0,fin=0):

    # Create folders
    if not os.path.isdir('inputs/'):
        os.mkdir('inputs/')
    if not os.path.isdir('inputs/parameters'):
        os.mkdir('inputs/parameters')
    if not os.path.isdir('inputs/spins'):
        os.mkdir('inputs/spins')

    for d in range(ini,fin):

        # Create parameters
        p = Parameters(time_steps=5)

        # Motion params estimation
        s = 0.5*tag_spacings[j]
        S_en  = (p["R_en"]-s)/p["R_en"]
        theta = 0.5*s/p["R_en"] 

        # Modify some values
        p.xi = 0.5
        p.sigma = 1.0
        p.phi_en = theta         # endocardial torsion
        p.phi_ep = 0*np.pi/180   # epicardial torsion
        p.S_ar = 1.0             # end-systolic area scaling
        p.S_en = S_en            # end-systolic endo scaling (sacles the endocardial radius)        

        # Create spins
        s = Spins(Nb_samples=nb_samples,parameters=p)

        # Write parameters and spins
        save_pyobject(p,'inputs/parameters/p_{:03d}.pkl'.format(d))
        save_pyobject(s,'inputs/spins/spins_{:03d}.pkl'.format(d), sep_proc=True)


# CSPAMM images generation
def generate_sine(resolutions, frequencies, patients, ini=0, fin=0, noise_free=False):

    # Create folder
    if not os.path.isdir('inputs/kspaces'):
        os.mkdir('inputs/kspaces')
    if not os.path.isdir('inputs/masks'):
        os.mkdir('inputs/masks')

    # Resolutions loop
    for (rn, r) in enumerate(resolutions):

        # T1 decay
        decay = 0.5
        T1 = -1.0/np.log(decay)

        # Create image
        I = SINEImage(FOV=np.array([0.2, 0.2, 0.008]),
                  center=np.array([0.0,0.0,0.0]),
                  resolution=r,
                  encoding_frequency=np.array([0,0,0]),
                  T1=T1,
                  kspace_factor=15,
                  slice_thickness=0.008,
                  oversampling_factor=1,
                  phase_profiles=r[1])

        # Filter specifications
        I.filter = 'Riesz'
        I.filter_width = 0.7
        I.filter_lift = 0.0

        # Frequencies loop
        for (fn, f) in enumerate(frequencies):

            # Set encoding frequency
            I.encoding_frequency = f
         
            # Data loop
            for d in range(ini,fin):

                # Load spins and parameter objects
                spins = load_pyobject('inputs/spins/spins_{:03d}.pkl'.format(d),sep_proc=True)
                param = load_pyobject('inputs/parameters/p_{:03d}.pkl'.format(d))

                # Create phantom
                phantom = Phantom(spins, param, patient=patients[d], z_motion=False)

                # Artifact
                artifact = None

                # Generate kspaces
                kspace, mask = I.generate(artifact, phantom, param, debug=False)

                # Export noise-free images
                if noise_free:
                    # Create folder
                    if not os.path.isdir('inputs/noise_free_images'):
                        os.mkdir('inputs/noise_free_images')

                    # Get images and scale
                    I = scale_image(kspace.to_img(),mag=False,real=True,compl=True)

                    # Export images
                    save_pyobject(I,'inputs/noise_free_images/I_{:03d}_{:02d}_{:02d}.pkl'.format(d,fn,rn))

                # Compress kspaces
                kspace.scale()

                # Get boolean mask
                mask = mask.to_img() > 0.05

                # Export kspaces and mask
                save_pyobject(kspace,'inputs/kspaces/I_{:03d}_{:02d}_{:02d}.pkl'.format(d,fn,rn))
                save_pyobject(mask,'inputs/masks/I_{:03d}_{:02d}_{:02d}.pkl'.format(d,fn,rn))