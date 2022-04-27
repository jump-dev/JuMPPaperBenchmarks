# Copyright (c) 2022: Miles Lubin and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

import DelimitedFiles
df = DelimitedFiles.readdlm("benchmarks.csv")
models = Dict{String,Dict{String,Int}}()
for i in 1:size(df, 1)
    type, model, variables, time = df[i, :]
    inner = get!(models, model, Dict{String,Int}())
    inner[type] = time
    inner["variables"] = variables
end
for key in sort(collect(keys(models)))
    inner = models[key]
    print(rpad(key, 15))
    for type in ["variables", "direct", "default"]
        print(" & ", lpad(inner[type], 2))
    end
    println(" \\\\")
end
