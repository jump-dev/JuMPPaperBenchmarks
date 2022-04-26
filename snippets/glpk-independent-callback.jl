# Copyright (c) 2022: Miles Lubin and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using JuMP, GLPK
model = Model()
@variable(model, 0 <= x[1:2] <= 2.5, Int)
@objective(model, Max, x[2])
function my_callback_function(cb_data)
    if callback_node_status(cb_data, model) != MOI.CALLBACK_NODE_STATUS_INTEGER
        return
    end
    x_val = callback_value.(cb_data, x)
    if x_val[2] - x_val[1] > 1 + 1e-6
        con = @build_constraint(x[2] - x[1] <= 1)
        MOI.submit(model, MOI.LazyConstraint(cb_data), con)
    elseif x_val[2] + x_val[1] > 3 + 1e-6
        con = @build_constraint(x[2] + x[1] <= 3)
        MOI.submit(model, MOI.LazyConstraint(cb_data), con)
    end
end
MOI.set(model, MOI.LazyConstraintCallback(), my_callback_function)
# Would also work with CPLEX.Optimizer, Gurobi.Optimizer, etc.
set_optimizer(model, GLPK.Optimizer)
optimize!(model)
