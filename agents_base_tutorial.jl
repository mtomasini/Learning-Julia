# modelling Schelling's model of segregation

using Agents

# make 20x20 grid in which agents live
space = GridSpace((20, 20)) 

# make agents
@agent struct Schelling(GridAgent{2})
    mood::Bool = false # declares that all agents start with mood = false (they are sad :( )
    group::Int
end

# define evolution rule (steps)
function schelling_step!(agent, model)
    minhappy = model.min_to_be_happy
    count_neighbors_same_group = 0
    for neighbor in nearby_agents(agent, model)
        if agent.group == neighbor.group
            count_neighbors_same_group += 1
        end
    end

    if count_neighbors_same_group >= minhappy #could use ≥
        agent.mood = true
    else
        agent.mood = false
        move_agent_single!(agent, model)
    end
    return
end

# container for model-level properties
properties = Dict(:min_to_be_happy => 3)

model = StandardABM(
    Schelling, # type of agents
    space;
    agent_step! = schelling_step!, properties
)

for n in 1:300
    add_agent_single!(model; group = n < 300 / 2 ? 1 : 2)
end


# run model and add statistics
using Statistics: mean
xpos(agent) = agent.pos[1]
adata = [(:mood, sum), (xpos, mean)]
adf, mdf = run!(model, 5; adata)
adf