# Copyright (c) 2022: Miles Lubin and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using JuMP, GLPK
model = Model(GLPK.Optimizer)
@variable(model, 0 <= x[1:2] <= 2.5, Int)
@objective(model, Max, 1.0 * x[2])
function my_callback_function(cb_data)
    if glp_ios_reason(cb_data.tree) == GLP_IBINGO
        glp_ios_terminate(cb_data.tree)
    end
end
MOI.set(model, GLPK.CallbackFunction(), my_callback_function)
optimize!(model)
