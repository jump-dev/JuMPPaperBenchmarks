# Copyright (c) 2022: Miles Lubin and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using JuMP
import Ipopt

function solve_clnlbeam(model, N)
    set_optimizer_attribute(model, "max_iter", 3)
    h = 1 / N
    alpha = 350
    @variables(model, begin
        -1 <= t[1:(N+1)] <= 1
        -0.05 <= x[1:(N+1)] <= 0.05
        u[1:(N+1)]
    end)
    @NLobjective(
        model,
        Min,
        sum(
            0.5 * h * (u[i+1]^2 + u[i]^2) +
            0.5 * alpha * h * (cos(t[i+1]) + cos(t[i])) for i in 1:N
        ),
    )
    @NLconstraint(
        model,
        [i = 1:N],
        x[i+1] - x[i] - 0.5 * h * (sin(t[i+1]) + sin(t[i])) == 0,
    )
    @constraint(
        model,
        [i = 1:N],
        t[i+1] - t[i] - 0.5 * h * u[i+1] - 0.5 * h * u[i] == 0,
    )
    optimize!(model)
end

function get_model(arg)
    if arg == "direct"
        return direct_model(Ipopt.Optimizer())
    elseif arg == "no-bridges"
        return Model(Ipopt.Optimizer; add_bridges = false)
    else
        return Model(Ipopt.Optimizer)
    end
end

function main(io::IO, Ns = [5_000, 50_000, 500_000])
    for type in ["direct", "no-bridges", "bridges"]
        for n in Ns
            start = time()
            solve_clnlbeam(get_model(type), n)
            run_time = round(Int, time() - start)
            println(io, "$type clnlbeam-$n $run_time")
        end
    end
end

if isempty(ARGS)
    main(stdout, [5])
else
    open(joinpath(@__DIR__, "benchmarks.csv"), "a") do io
        main(io)
    end
end
