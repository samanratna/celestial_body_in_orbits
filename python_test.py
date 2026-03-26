import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

# ===============================
# Constants
# ===============================
G = 6.667e-20
mass_of_earth = 5.9722e24
mu = G * mass_of_earth

# ===============================
# Orbit Radii
# ===============================
r1 = 6780.0      # initial orbit (km)
r2 = 12000.0     # target orbit (km)

# ===============================
# Initial Circular Orbit State
# ===============================
r0 = np.array([r1, 0, 0])
v_circ_1 = np.sqrt(mu / r1)
v0 = np.array([0, v_circ_1, 0])

# ===============================
# Hohmann Transfer ΔV
# ===============================
dv1 = np.sqrt(mu/r1) * (np.sqrt(2*r2/(r1+r2)) - 1)
dv2 = np.sqrt(mu/r2) * (1 - np.sqrt(2*r1/(r1+r2)))

print(f"Delta-V1: {dv1:.4f} km/s")
print(f"Delta-V2: {dv2:.4f} km/s")

# ===============================
# ODE Function
# ===============================
def two_body_ode(t, z, mu):
    r_vec = z[0:3]
    v_vec = z[3:6]
    r_mag = np.linalg.norm(r_vec)
    
    drdt = v_vec
    dvdt = -mu * r_vec / r_mag**3
    return np.concatenate((drdt, dvdt))

# ===============================
# Plot Setup
# ===============================
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')

# Plot Earth
R_earth = 6371
u, v = np.mgrid[0:2*np.pi:40j, 0:np.pi:40j]
sx = R_earth * np.cos(u) * np.sin(v)
sy = R_earth * np.sin(u) * np.sin(v)
sz = R_earth * np.cos(v)
ax.plot_surface(sx, sy, sz, color='blue', alpha=0.1, edgecolor='none')

# Initial Reference Orbit (dashed)
theta = np.linspace(0, 2*np.pi, 200)
ax.plot(r1*np.cos(theta), r1*np.sin(theta), 0, 'k--', label='Initial Orbit')

# ===============================
# Burn 1 (Transfer Orbit)
# ===============================
v0_transfer = v0 + np.array([0, dv1, 0])
z0_transfer = np.concatenate((r0, v0_transfer))

a_transfer = (r1 + r2) / 2
T_transfer = np.pi * np.sqrt(a_transfer**3 / mu)

t_span1 = (0, T_transfer)
sol1 = solve_ivp(two_body_ode, t_span1, z0_transfer, args=(mu,), 
                 rtol=1e-10, atol=1e-12, t_eval=np.linspace(0, T_transfer, 500))

ax.plot(sol1.y[0], sol1.y[1], sol1.y[2], 'r', linewidth=2, label='Transfer Orbit')

# ===============================
# Burn 2 (Final Orbit)
# ===============================
z_apogee = sol1.y[:, -1]
r_vec2 = z_apogee[0:3]
v_vec2 = z_apogee[3:6]

v_hat = v_vec2 / np.linalg.norm(v_vec2)
v_new = v_vec2 + dv2 * v_hat
z0_final = np.concatenate((r_vec2, v_new))

t_span2 = (0, 20000)
sol2 = solve_ivp(two_body_ode, t_span2, z0_final, args=(mu,), 
                 rtol=1e-10, atol=1e-12, t_eval=np.linspace(0, 20000, 1000))

ax.plot(sol2.y[0], sol2.y[1], sol2.y[2], 'g', linewidth=2, label='Final Orbit')

# Formatting
ax.set_xlabel('X (km)')
ax.set_ylabel('Y (km)')
ax.set_zlabel('Z (km)')
ax.set_title('Hohmann Transfer Orbit')
ax.legend()
plt.axis('equal')
plt.grid(True)
plt.show()

from matplotlib.animation import FuncAnimation

# Combine all states for animation
all_states = np.concatenate((sol1.y.T, sol2.y.T), axis=0)

# Create the point representing the satellite
dot, = ax.plot([], [], [], 'ko', markersize=8)

def update(frame):
    dot.set_data([all_states[frame, 0]], [all_states[frame, 1]])
    dot.set_3d_properties([all_states[frame, 2]])
    return dot,

ani = FuncAnimation(fig, update, frames=len(all_states), interval=20, blit=True)
plt.show()