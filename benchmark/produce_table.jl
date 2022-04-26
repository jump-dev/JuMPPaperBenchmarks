import DelimitedFiles
df = DelimitedFiles.readdlm("benchmarks.csv")
models = Dict{String,Dict{String,Int}}()
for i in 1:size(df, 1)
    type, model, time = df[i, :]
    inner = get!(models, model, Dict{String,Int}())
    inner[type] = time
end
println(" & Direct & No bridges & Bridges")
for key in sort(collect(keys(models)))
    inner = models[key]
    print(rpad(key, 15))
    for type in ["direct", "no-bridges", "bridges"]
        print(" & ", lpad(inner[type], 2))
    end
    println(" \\\\")
end
