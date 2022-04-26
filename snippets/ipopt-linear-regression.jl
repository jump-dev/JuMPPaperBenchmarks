# Copyright (c) 2022: Miles Lubin and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using JuMP, Ipopt
function linear_regression(A, y)
    m, n = size(A)
    model = Model(Ipopt.Optimizer)
    @variable(model, 0 <= x[1:n] <= 1)
    @variable(model, residuals[1:m])
    @constraint(model, residuals .== A * x .- y)
    @constraint(model, sum(x) == 1)
    @objective(model, Min, sum(residuals[i]^2 for i in 1:m))
    optimize!(model)
    print(solution_summary(model))
    return value.(x)
end
A, y = rand(30, 20), rand(30)
x = linear_regression(A, y)
