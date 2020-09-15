# P2_HARPI
This repository contains all the codes to generate the synthetic dataset used in the paper "An Harmonic Phase Interpolation (HARPI) Method for the Estimation of Motion from Tagged MR Images".

### Dependencies
The code relies on the open source library [pymrstrain](www.github.com/hmella/pymrstrain), a python library for the generation of STEAM-like MR images.

### Testing
To generate the data simply do:
```bash
python3 test_base_generation.py --generate-parameters --sine --reference --nb-samples 100000 --initial-data 0 --final-data 10
```
or
```bash
python3 test_base_generation.py -gp -s -r -Ns 100000 -i 0 -f 10
```
For a better understanding of the bash commnads the author refers to the file ```utils/args_parser.py```