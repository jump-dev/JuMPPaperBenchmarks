# JuMPPaperBenchmarks

This repository contains code snippents and benchmarks for a paper on JuMP 1.0.

## One-time setup

First install Julia 1.6.

Once installed, initialize the environments as follows:
```
$ julia --project=. -e "import Pkg; Pkg.instantiate"
$ julia --project=. benchmark/create_sysimage.jl
$ julia --project=. latency/create_sysimage.jl
```

## Run experiments

```
$ time julia --project=. latency/model.jl
$ time julia --project=. --sysimage latency/sysimage latency/model.jl
```

## Run experiments

```
$ julia --project=. --sysimage benchmark/sysimage benchmark/clnlbeam.jl --run
$ julia --project=. --sysimage benchmark/sysimage benchmark/facility.jl --run
$ julia --project=. --sysimage benchmark/sysimage benchmark/lqcp.jl --run
```

