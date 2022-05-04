#!/bin/bash

# Copyright (c) 2022: Miles Lubin and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

# Update if needed
# export GUROBI_HOME="/Library/gurobi951/macos_universal2/"

export LD_LIBRARY_PATH=$GUROBI_HOME/lib/
clang++ -O2 facility.cpp -o cpp_facility -I$GUROBI_HOME/include/ -L$GUROBI_HOME/lib -stdlib=libc++ -std=c++11 -lgurobi_c++ -lgurobi95
clang++ -O2 lqcp.cpp -o cpp_lqcp -I$GUROBI_HOME/include/ -L$GUROBI_HOME/lib -stdlib=libc++ -std=c++11 -lgurobi_c++ -lgurobi95

time ./cpp_facility 25 25
time ./cpp_facility 50 50
time ./cpp_facility 75 75
time ./cpp_facility 100 100

time ./cpp_lqcp 500
time ./cpp_lqcp 1000
time ./cpp_lqcp 1500
time ./cpp_lqcp 2000
