# following the schematics from `agents_base_tutorial.jl`

using Agents

# make a 2-demes "grid"
space = GridSpace((2, 2))

@agent struct Cultural(GridAgent{2})
    traits::Vector
    deme::Int
end

function culture_step!(agent, model)
    

end