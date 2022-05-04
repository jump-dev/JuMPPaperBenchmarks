# JuMPPaperBenchmarks

This repository contains code snippents and benchmarks for a paper on JuMP 1.0.

## One-time setup

First, install Gurobi and obtain a license.

Then, install Julia 1.6.

Once installed, initialize the Julia environments as follows:
```
$ julia --project=. -e "import Pkg; Pkg.instantiate()"
$ julia --project=. benchmark/create_sysimage.jl
$ julia --project=. latency/create_sysimage.jl
```

To run the Pyomo experiments, install Pyomo and solvers as follows:
```
$ conda create --name pyomo --python=3.8 -y
$ conda activate pyomo
$ conda install -c conda-forge pyomo
$ conda config --add channels https://conda.anaconda.org/gurobi
$ conda install gurobi
```

## Run latency experiments

```
$ time julia --project=. latency/model.jl
$ time julia --project=. --sysimage latency/sysimage latency/model.jl
```

## Run benchmark experiments

```
$ julia --project=. --sysimage benchmark/sysimage benchmark/facility.jl --run
$ julia --project=. --sysimage benchmark/sysimage benchmark/lqcp.jl --run
$ python benchmark/facility.py
$ python benchmark/lqcp.py
```

