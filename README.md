# Mechanical System Modeling and Simulation

This repository contains MATLAB implementations for modeling and simulating a nonlinear mechanical system. The simulation is based on solving a system of differential equations describing the dynamics of the system, using both MATLAB scripts and Simulink models.

## Features

- **Numerical Integration**: Fourth-order Runge-Kutta method for solving differential equations.
- **Phase Portraits**: Visualization of the phase portraits for each angle.
- **Integration Error Analysis**: Comparison between numerical results from Runge-Kutta and Simulink simulations.
- **Force Dependency Analysis**: Study of the dependency of the final states on varying force values.
- **Uncertainty Modeling**: Analysis under multiplicative and additive uncertainties.
- **Exogenous Signal Analysis**: Evaluation of second discrete derivatives and force distributions.

## Files

### Main Scripts
- **`script.m`**: The primary MATLAB script containing all implementations for requirements 1 through 11.
- **`Runge_Kutta.m`**: MATLAB function defining the dynamics of the system for the Runge-Kutta integration.

### Simulink Model
- **`model.slx`**: Simulink model implementing the system dynamics using MATLAB Function blocks.

## How to Use

1. Clone this repository: git clone https://github.com/yourusername/mechanical-system-simulation.git
2. Open MATLAB and navigate to the repository folder.
3. Open `script.m` and run it to execute the simulations and generate the required plots.
4. Use Simulink to explore the `model.slx` file for a graphical representation of the system.

## Dependencies

- MATLAB R2024b or later.
- Simulink (compatible with the provided model).

## Project Structure

├── script.m         # Main script implementing the simulation tasks

├── Runge_Kutta.m    # Dynamics function for the Runge-Kutta method

├── model.slx        # Simulink model of the system

├── README.md        # Project documentation

## Results

- **Phase Portraits**: Visual representation of angular velocity vs. angle and their relationships.
- **Error Analysis**: Integration error illustrated as the norm-2 difference between Simulink and numerical solutions.
- **Force Analysis**: Graphs showing the impact of different forces on final states.
- **Uncertainty Analysis**: Demonstration of system evolution under perturbations.
- **Signal Analysis**: Examination of second derivatives and force distribution.

## References

- MATLAB documentation: [Runge-Kutta Methods](https://www.mathworks.com/help/matlab/ref/ode45.html)
- Simulink documentation: [Building Simulink Models](https://www.mathworks.com/help/simulink/gs/model-a-dynamic-system.html)
