# Project 2 README

## Introduction
This project simulates a 3D dynamic system involving a set of interconnected nodes (resembling a net or a piece of cloth) that interact with a movable spherical obstacle. The simulation leverages physical principles like gravitational force, spring forces, and damping.

## Features
- **3D Visualization**: Uses Processing's P3D renderer for 3D graphics.
- **Camera Controls**: Navigate through the simulation scene using a flexible camera control.
- **Interactive Obstacle**: Move the obstacle with your mouse and watch it interact with the ropes in real-time.

## Camera Control Guide
The camera system for this project was designed by Liam Tyler for CSCI 5611. Below are the controls:

### Movement:
- **W**: Move forward relative to camera orientation.
- **S**: Move backward relative to camera orientation.
- **A**: Move left relative to camera orientation.
- **D**: Move right relative to camera orientation.
- **Q**: Move up.
- **E**: Move down.

### Rotation:
- **Arrow Left**: Rotate camera left.
- **Arrow Right**: Rotate camera right.
- **Arrow Up**: Rotate camera upwards.
- **Arrow Down**: Rotate camera downwards.

### Speed Boost:
- **Shift**: Hold to increase camera movement speed.

### Reset Camera:
- **R**: Reset camera to its initial position and orientation.

## Physics Behind the Simulation

The core physics simulation is based on:
1. **Gravity**: Each node in the ropes experiences gravitational force.
2. **Spring Forces**: The forces between interconnected nodes simulate springs. The spring forces are calculated based on Hooke's Law.
3. **Damping**: A damping force is applied to reduce oscillations and stabilize the system.
4. **Collision**: The nodes interact with the floor and the spherical obstacle through collision detection and response.

### Key Functions:
- **applyGravityToNodes()**: Applies gravitational force to all nodes.
- **computeForcesBetweenNeighbors()**: Computes spring and damping forces between adjacent nodes.
- **computeForceBetweenNodes()**: Calculates forces between a pair of nodes.
- **updateNodesUsingEulerIntegration()**: Updates node positions and velocities using the Euler integration method.
- **handleFloorAndObstacleCollisions()**: Detects and handles collisions between nodes, the floor, and the obstacle.

## Setup & Run
1. Ensure you have Processing installed.
2. Open the provided .pde files in the Processing IDE.
3. Click the "Run" button to start the simulation.
4. Use the camera controls to navigate the scene.
5. Move your mouse to reposition the obstacle in the simulation.

## Credits
Created by Liam Tyler for CSCI 5611. The simulation incorporates a blend of graphics, user interaction, and physics for an interactive experience.
