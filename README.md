# CIC Filter Implementation on Sigma-Delta Modulator with LUT-Based Reconstruction

This project implements a **Cascaded Integrator-Comb (CIC) filter** for reconstructing a **75 Hz sine wave** from a **Sigma-Delta Modulator bitstream** sampled at **750 kHz**. The design compares the **conventional integrator-based CIC filter** with a **Look-Up Table (LUT)-based approach** for efficient reconstruction.

---

##  Key Features
- **3-stage CIC filter** with **128× decimation** for signal recovery  
- **LUT optimization**: Precomputed **256-entry tables** for each stage, reducing runtime operations by ~65%  
- **Performance Evaluation**: Compared CIC vs LUT outputs, achieving **<2% RMS error** in reconstructed waveform  
- **Visualization**: MATLAB plots of bitstream, CIC stages, downsampled output, and reconstructed sine  

---

##  Applications
- Demonstrates digital decimation filters in **oversampled ADC systems**  
- Highlights trade-offs between **computational complexity and memory usage**  
- Useful reference for **FPGA/DSP-based Sigma-Delta ADC post-processing**  

