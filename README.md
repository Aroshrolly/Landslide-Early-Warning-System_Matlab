# 🌍 Landslide Early Warning System (LEWS)

### MATLAB–Simulink Based Rainfall-Driven Slope Instability Simulation with AI Sensor Fusion

<p align="center">
  <b>Simulation-Based Proof of Concept | 2026</b><br>
  Munnar–Idukki Region, Western Ghats, Kerala, India
</p>

---

## 1. Project Overview

The **Landslide Early Warning System (LEWS)** is a MATLAB–Simulink-based simulation project designed to demonstrate rainfall-induced slope instability and a multi-parameter early-warning approach.

The system models the progression of slope instability by analysing six parameters:

* Rainfall intensity
* Soil moisture
* Pore-water pressure
* Factor of Safety (FS)
* Surface tilt
* Subsurface shear strain

These parameters are combined through a project-defined sensor-fusion and risk-assessment workflow to generate four warning levels:

🟢 Green – Normal condition
🟡 Yellow – Low-level warning
🟠 Orange – Elevated warning
🔴 Red – Critical warning

The system also incorporates a regression-based **Time-to-Failure (TTF)** estimation component to display the estimated remaining time to failure.

> **Note:** This is an academic simulation-based proof of concept, not a field-validated operational landslide warning device.

---

## 2. Problem Statement

Rainfall-induced landslides are a major geological hazard, particularly in hilly regions such as the Western Ghats of Kerala.

Continuous rainfall can cause water infiltration, increased soil moisture, changes in pore-water pressure and reduced slope stability. Monitoring rainfall alone may not adequately represent the evolving condition of a slope.

Therefore, this project demonstrates an integrated simulation framework that combines hydrological, geotechnical and deformation-related indicators to represent slope instability and generate staged warning outputs.

---

## 3. Project Objectives

1. Simulate rainfall-induced soil wetting and slope instability.
2. Analyse the relationship between rainfall, soil moisture and pore-water pressure.
3. Monitor slope stability using the Factor of Safety.
4. Represent slope deformation through tilt and subsurface shear strain.
5. Implement multi-parameter sensor fusion for risk assessment.
6. Generate four-stage warning levels based on the modelled risk condition.
7. Estimate the remaining Time-to-Failure using a regression-based approach.
8. Demonstrate the complete workflow using MATLAB and Simulink.

---

## 4. System Architecture

The system follows a sequential processing architecture.

```text
       RAINFALL INPUT
             |
             v
       SOIL MOISTURE
             |
             v
     PORE-WATER PRESSURE
             |
             v
       FACTOR OF SAFETY
             |
             v
        SURFACE TILT
             |
             v
      SHEAR STRAIN
             |
             v
    INPUT NORMALIZATION
             |
             v
     SENSOR FUSION
             |
             v
      RISK ASSESSMENT
             |
       +-----+------+
       |            |
       v            v
 WARNING LEVEL   TTF ESTIMATION
       |            |
       v            v
 GREEN/YELLOW/   REMAINING TIME
 ORANGE/RED      TO FAILURE
```

The architecture represents the conceptual processing flow. The six parameters are processed together in the implemented fusion stage.

---

## 5. Technologies Used

| Technology         | Application                                              |
| ------------------ | -------------------------------------------------------- |
| MATLAB             | Mathematical modelling, calculations and data processing |
| Simulink           | System modelling and simulation                          |
| Regression         | Remaining Time-to-Failure estimation                     |
| Sensor Fusion      | Combining multiple slope-condition indicators            |
| Data Visualization | Monitoring simulation parameters and warning outputs     |

---

## 6. Methodology

The project is implemented through the following stages.

### Stage 1: Rainfall Simulation

Rainfall intensity is provided as an input to represent changing weather conditions.

### Stage 2: Soil Moisture Modelling

The soil moisture response is represented as rainfall infiltration progresses.

### Stage 3: Pore-Water Pressure Analysis

Pore-water pressure is monitored to represent subsurface hydrological changes.

### Stage 4: Slope Stability Analysis

The Factor of Safety is used as an indicator of the simulated slope's stability condition.

A declining Factor of Safety represents decreasing modelled slope stability.

### Stage 5: Deformation Monitoring

Two deformation-related indicators are included:

* Surface tilt (degrees)
* Subsurface shear strain (µε)

These parameters help represent the progressive movement of the simulated slope.

### Stage 6: AI-Based Sensor Fusion

The six parameters are incorporated into a project-defined fusion and risk-assessment workflow.

The combined indicator is used by the warning logic to represent the evolving risk condition.

### Stage 7: Time-to-Failure Estimation

A regression-based component estimates the remaining time to failure based on the evolving simulation indicators.

The output is displayed in hours.

---

## 7. Simulation Time Scaling

To accelerate the simulation, the project uses the following fixed time relationship:

**1 simulation second = 0.6 physical hours**

This scaling allows the model to represent an extended simulated progression within a shorter simulation duration.

It is a project-defined simulation setting and does not represent a measured physical relationship.

---

## 8. Simulation Results

The simulation demonstrates how multiple slope-condition indicators evolve during rainfall-induced instability.

### Selected Reference Results

| Parameter           | Initial State (0 h) | Later State (18 h) |
| ------------------- | ------------------: | -----------------: |
| Estimated TTF       |              42.0 h |             24.0 h |
| Rainfall intensity  |              0 mm/h |             5 mm/h |
| Cumulative rainfall |       Not specified |              85 mm |
| Soil moisture       |               18.0% |              38.2% |
| Pore-water pressure |             -15 kPa |      Not specified |
| Factor of Safety    |                1.85 |      Not specified |
| Surface tilt        |               0.02° |      Not specified |
| Shear strain        |               12 µε |      Not specified |
| Warning state       |               Green |      Not specified |

### Observations

* Rainfall intensity increases during the simulated progression.
* Cumulative rainfall reaches 85 mm at the 18-hour reference point.
* Soil moisture increases from 18.0% to 38.2%.
* Estimated remaining Time-to-Failure decreases from 42 hours to 24 hours.
* The model combines multiple indicators to represent the evolving slope condition.

**Important:** These are selected simulation reference values, not field measurements. Additional results should be taken directly from the original MATLAB/Simulink outputs.

---

## 9. Project Structure

The recommended GitHub repository structure is:

```text
Landslide-Early-Warning-System/
│
├── MATLAB/
│   ├── Matrix_project_LEWS.m
│   └── matlab_landslide.slx
│
├── Documentation/
│   └── Landslide_Early_Warning_System_Project_Documentation.pdf
│
├── Results/
│   ├── rainfall_plot.png
│   ├── soil_moisture_plot.png
│   ├── pore_pressure_plot.png
│   ├── factor_of_safety_plot.png
│   ├── tilt_plot.png
│   ├── shear_strain_plot.png
│   └── warning_state_plot.png
│
├── Images/
│   ├── system_architecture.png
│   └── dashboard_screenshot.png
│
├── Dataset/
│   └── simulation_data.csv
│
└── README.md
```

*The structure is a recommendation. Include only files that are available in your actual project.*

---

## 10. How to Run the Project

### Software Requirements

* MATLAB
* Simulink
* A compatible MATLAB release

### Execution Steps

1. Download or clone this repository.
2. Open MATLAB.
3. Navigate to the project directory.
4. Locate the MATLAB script and Simulink model.
5. Open `Matrix_project_LEWS.m`.
6. Execute the MATLAB script.
7. Open `matlab_landslide.slx` in Simulink if required by the implementation.
8. Run the simulation.
9. Observe the generated parameters, warning states and TTF output.

**Note:** The execution sequence may need adjustment depending on the actual dependencies and file paths in the MATLAB implementation.

---

## 11. Limitations

* The project is currently a simulation-based proof of concept.
* The model has not been validated using real-time field sensor measurements.
* Risk thresholds require site-specific calibration.
* The physical response models require further geotechnical validation.
* Regression performance must be evaluated using independent test data.
* Results from a simulated sequence do not establish generalisation to other geographical locations or landslide events.
* The system is not intended for operational public-safety decisions.

---

## 12. Future Improvements

Potential improvements include:

1. Integration of real-time rainfall and soil-moisture sensors.
2. Implementation of IoT-based monitoring and data transmission.
3. Integration of tilt and subsurface deformation sensors.
4. Collection of real landslide monitoring datasets.
5. Evaluation of multiple machine-learning and regression models.
6. Validation using unseen rainfall events.
7. Calibration of warning thresholds using field data.
8. Development of a real-time monitoring dashboard.
9. Implementation of automated alert communication.

---

## 13. Conclusion

The Landslide Early Warning System demonstrates a MATLAB–Simulink-based approach to modelling rainfall-induced slope instability through the integration of hydrological, geotechnical and deformation-related indicators.

By combining six parameters through a sensor-fusion workflow, the project demonstrates staged warning generation and regression-based Time-to-Failure estimation.

The project provides a foundation for further development towards sensor-integrated, data-driven landslide monitoring systems.

---

## 14. Disclaimer

This project is developed for academic, educational and simulation purposes.

The generated warning states and Time-to-Failure estimates are model outputs and have not been established as reliable real-world predictions.

The system must not be used as a substitute for official landslide warnings, professional geotechnical assessment or emergency-management procedures.

---

**Project Domain:** Electronics and Communication Engineering | Signal Processing | MATLAB/Simulink | AI-Based Monitoring
