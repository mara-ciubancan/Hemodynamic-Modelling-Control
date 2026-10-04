# Towards a new modelling and control paradigm in hemodynamic systems

> Code repository for the thesis: *"Towards a new modelling and control paradigm in hemodynamic systems"*.

This repository covers the development workflow for hemodynamic regulation through drug administration:
* **Data Extraction Algorithm**: Developed Python-based scripts for clinical data retrieval from the [VitalDB](https://vitaldb.net/) open-access dataset in order to format it in MATLAB-compatible structures for visualisation.
* **System Modelling**: Performed system identification of the hemodynamic process using a Single-Input-Single-Output (SISO) system, using Norepinephrine (NOR) as input to regulate the Mean Arterial Pressure (MAP) via a first-order transfer function.
* **Controller Design**: Developed different control strategies for regulating the drug infusion process:
  * Classical: PI, PID, Guillemin-Truxal (GT) controllers
  * Advanced: Internal Model Control (IMC) and Fractional-Order (FO) controllers
* **Simulation & Validation**: Tested the developed controllers against an existing patient anaesthesia simulator. Closed-loop validation, disturbance-rejection testing and inter-patient variability evaluation were performed using population-based data.

## Simulation Demo
[![Watch the simulation demo](https://img.youtube.com/vi/G8syMJqV0VY/0.jpg)](https://youtu.be/G8syMJqV0VY)
