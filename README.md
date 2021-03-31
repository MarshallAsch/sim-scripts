## Simulation runner scripts


This repository is meant to contain the scripts needed to run and plot my simulations.

This inital version includes 3 scripts, one to run all the simulations, one to run a batch of simulations
so that there is more than one run per set of parameters, and the third script actually runs the simulation.


This repository is meant to be cloned into the root of the ns3 folder and the scripts are intended to be run from
within the folder.

This is currently only set to run the SAF simulations to reproduce that paper.

This requires that the [GNU parallel](https://www.gnu.org/software/parallel/) is installed.
It will run all the simulations in parallel but no more than the number of threads that there are
on the system.
