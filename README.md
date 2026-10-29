## 🎬 Simulation Preview

[▶️ Click here to watch the 3D Fluid Fountain Simulation Video](https://github.com/akshat4360/3D-Particle-Fountain-Simulation-Julia-/blob/main/fluid_simulation.mp4)



# 🌊 3D Fluid Particle Fountain Simulation in Julia

A real-time 3D fluid dynamics and particle fountain simulation built from scratch using **Julia** and **GLMakie**. This project models individual fluid parcels governed by gravity, Euler integration, and boundary collision physics, rendered interactively with dynamic scientific colormaps.

---

## ✨ Features
* **Real-Time Physics Engine:** Implements velocity updates, downward gravitational acceleration, and energy-damped floor collisions.
* **Particle Lifecycle & Recycling:** Automatically recycles particles as they age or drift away, creating a continuous, steady-state fluid stream.
* **Interactive GLMakie Rendering:** Renders 1,000+ glowing particles in a 3D bounding box with real-time reactive observables (`Observable`) for smooth 60 FPS performance.
* **Dynamic Color Mapping:** Utilizes the `:inferno` scientific colormap, binding particle color directly to their altitude ($Z$-coordinate) for a glowing liquid effect.

---

## 🛠️ Prerequisites & Installation

Make sure you have [Julia](https://julialang.org/) installed on your system. 

1. Open your Julia REPL or VS Code terminal.
2. Install the required visualization package (`GLMakie`):
   ```julia
   using Pkg
   Pkg.add("GLMakie")
   Pkg.add("LinearAlgebra")
🚀 Running the Simulation
Clone or download this repository.
Open the folder in VS Code or your preferred Julia environment.
Run the script using:
include("ParticleHydrodynamics.jl")
🔬 Physics & Mathematics
The simulation tracks particles in Lagrangian mechanics using discrete time steps (\Delta t):

Velocity Update: $\mathbf{v}_{\text{new}} = \mathbf{v}_{\text{old}} + \mathbf{g} \Delta t$
Position Update: $\mathbf{x}_{\text{new}} = \mathbf{x}_{\text{old}} + \mathbf{v} \Delta t$
Floor Collision: Inverts vertical velocity upon hitting z \le 0 and applies a restitution damping coefficient to simulate energy loss on impact.
