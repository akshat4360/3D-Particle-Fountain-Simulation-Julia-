using GLMakie
using LinearAlgebra

#Parameters
const N_PARTICLES = 9500
const   DT = 0.017
const GRAVITY = Point3f(0, 0, -9.81)

#mutable structure for holdiing particle states
mutable struct FluidSystem
    positions:: Vector{Point3f}
    velocities::Vector{Point3f}
    lifetimes::Vector{Float64}
    max_lifetimes::Vector{Float64}
end

function initialize_fluid()
    positions = [Point3f(rand()*0.2 - 0.1, rand()*0.2 - 0.1, 0.0) for  _ in 1:N_PARTICLES]
    velocities = Vector{Point3f}(undef, N_PARTICLES)
    lifetimes =  Vector{Float64}(undef, N_PARTICLES)
    max_lifetimes  = Vector{Float64}(undef, N_PARTICLES)

    for i in 1:N_PARTICLES
        angle = rand() * 2 * pi
        speed_xy = rand() * 2.5
        speed_z = rand() * 4.0 + 7.0
        velocities[i] = Point3f(cos(angle) * speed_xy, sin(angle) * speed_xy, speed_z)

        lt = rand() * 3.0 + 2.0 
        lifetimes[i] = lt
        max_lifetimes[i] = lt 
    end

    return FluidSystem(positions, velocities, lifetimes, max_lifetimes)
end

function update_fluid!(sys::FluidSystem)
    t = time()
    for i in eachindex(sys.positions)
        #Applying gravity and turbulence
        accel = GRAVITY +  Point3f(0.3 * sin(i + t), 0.3 * cos(i + t), 0.0)

        #Euler integration
        sys.velocities[i] += accel * DT
        sys.positions[i] += sys.velocities[i] * DT

        #Floor and boundary collision
        if sys.positions[i][3] < 0.0
            sys.positions[i] = Point3f(sys.positions[i][1], sys.positions[i][2], 0.0)
            sys.velocities[i] = Point3f(
                sys.velocities[i][1] * 0.7,
                sys.velocities[i][2] * 0.7,
                -sys.velocities[i][3] * 0.4 
            )
        end

        #resst particle flying high or dies
        sys.lifetimes[i] -= DT
        if sys.lifetimes[i] <= 0.0
            sys.positions[i] = Point3f(rand() * 0.2 - 0.1, rand() * 0.2 - 0.1, 0.0)
            angle = rand() * 2 * pi
            speed_xy = rand() * 2.5
            speed_z = rand() * 4.0 + 7.0
            sys.velocities[i] = Point3f(cos(angle) * speed_xy, sin(angle) * speed_xy, speed_z)
            sys.lifetimes[i] = sys.max_lifetimes[i]
        end
    end
end

#Initialize FluidSystem
fluid = initialize_fluid()

#real-time reactive plotting
pos_obs = Observable(fluid.positions)
col_obs = Observable([pos[3] for pos in fluid.positions]) 

#GLMakie Design
set_theme!(theme_black())
fig, ax, pltobj = scatter(
    pos_obs,
    color = col_obs, 
    colormap = :viridis,
    markersize = 8,
    transparency = true,
    axis = (; type = Axis3, 
    limits = (-6, 6, -6, 6, 0, 12),
    title = "3D Fluid Particle Simulation" )
)

display(fig)

@async while true
    update_fluid!(fluid)


    #Update live data
    #pltobj[1] = fluid.positions
    #pltobj.color = [pos[3] for pos in fluid.positions]

    #t = time()
    #ax.azimmuth[] = t * 0.5

    pos_obs[] = fluid.positions
    col_obs[] = [pos[3] for pos in fluid.positions]

    sleep(0.02)
    yield()
end


