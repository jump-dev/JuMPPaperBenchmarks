# Copyright (c) 2022: Miles Lubin and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

import pyomo.environ as pyo
from pyomo.opt import SolverFactory
from pyomo.core import cos, sin
import os
import time

def solve_clnlbeam(N):
    model = pyo.ConcreteModel()
    model.N = N
    model.h = 1.0/model.N
    model.VarIdx = pyo.RangeSet(model.N+1)
    model.t = pyo.Var(model.VarIdx, bounds=(-1.0,1.0), initialize=lambda m,i: 0.05*cos(i*m.h))
    model.x = pyo.Var(model.VarIdx, bounds=(-0.05,0.05), initialize=lambda m,i: 0.05*cos(i*m.h))
    model.u = pyo.Var(model.VarIdx, initialize=0.01)
    alpha = 350
    model.c = pyo.Objective(
        expr=sum(0.5*model.h*(model.u[i+1]**2+model.u[i]**2) + 0.5*alpha*model.h*(cos(model.t[i+1])+cos(model.t[i])) for i in model.VarIdx if i != model.N+1)
    )
    def cons1_rule(m, i):
        if i == m.N+1:
            return pyo.Constraint.Skip
        return m.x[i+1] - m.x[i] - (0.5*m.h)*(sin(m.t[i+1])+sin(m.t[i])) == 0
    model.cons1 = pyo.Constraint(model.VarIdx, rule=cons1_rule)
    def cons2_rule(m,i):
        if i == m.N+1:
            return pyo.Constraint.Skip
        return m.t[i+1] - m.t[i] - (0.5*m.h)*m.u[i+1] - (0.5*m.h)*m.u[i] == 0
    model.cons2 = pyo.Constraint(model.VarIdx, rule=cons2_rule)
    opt = SolverFactory('ipopt')
    opt.options["max_iter"] = 3
    opt.solve(model, tee=True)
    return model

def main(Ns = [5_000, 50_000, 500_000]):
    dir = os.path.realpath(os.path.dirname(__file__))
    for n in Ns:
        start = time.time()
        model = solve_clnlbeam(n)
        run_time = round(time.time() - start)
        with open(dir + "/benchmarks.csv", "a") as io:
            io.write("pyomo clnlbeam-%i -1 %i\n" % (n, run_time))
    return

main()
