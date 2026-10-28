# Robotics Engineering — Full-Time Learning Plan

> **Main track:** Robotics
> **20% tracks:** Cybersecurity, Chip Design, Cloud/DevOps
> **Goal:** own a Palantir-like tech company
> **Stage:** Mechatronics, final year · 16GB RAM laptop, no GPU · ~$15/mo hardware budget
> **Thesis (locked):** A+B combo — *Low-Cost Connected Mobile Robot with Secure Telemetry for Indoor Inspection*
> **Environment:** dedicated Ubuntu 22.04 SSD (no Windows on it) + offline toolkit cache on external drive

This is the roadmap. It changes when the strategy changes — not every week.
The dated record of what actually happened lives in [`JOURNAL.md`](JOURNAL.md).

---

## 0. Rules

1. No tutorial without a build. Every course = 1 repo + README + demo video.
2. Sim-first. Hardware second. Cloud third.
3. Track weekly: Done / Demo link / Blocked / Next / Hours.
4. Thesis = Portfolio = Startup demo. No throwaway project.

## 1. Setup

- [x] GitHub repo `robotics-journey`
- [x] Ubuntu 22.04 on dedicated SSD + VS Code + Git
- [ ] Python 3.11+, NumPy, Matplotlib, OpenCV
- [ ] ROS 2 Humble + Gazebo Classic + RViz
- [ ] Docker
- [ ] CAD: Onshape (browser, free) or FreeCAD
- [ ] Keep 60GB+ free on SSD. 16GB RAM is enough. No Isaac Sim (needs RTX).

## 2. Phase 1: Foundations (Month 0–4)

**Skills:** Python, C, Linux CLI, Git, Linear Algebra, Calculus, Probability, Circuits 101, CAD

**Study:**
- Python: CS50P, Automate the Boring Stuff
- C/C++: via ESP32 after Python basics
- Math: MIT 18.06 Linear Algebra, Khan Calculus, 3Blue1Brown
- Electronics: ESP32 docs, UART/I2C/SPI basics

**Builds:**
1. Python 2D arm forward kinematics simulator (plot)
2. ESP32 sensor reader (ultrasonic + IMU to serial)
3. CAD chassis design in Onshape

**Exit:** can push to Git, read sensors, do matrix transforms in Python.

## 3. Phase 2: Core Mechatronics + ROS (Month 4–10)

**Skills:** C++ for robotics, ESP32 + FreeRTOS basics, PID, kinematics, ROS 2, Gazebo, URDF

**Study:**
- ROS 2 docs + Articulated Robotics track
- Modern Robotics (Northwestern) for kinematics
- PID + state-space intro

**Builds:**
1. Diff-drive robot in Gazebo + teleop + odometry
2. PID control demo in sim
3. SLAM with slam_toolbox + Nav2 in a sim warehouse

**Exit:** sim robot maps and navigates to a goal on its own.

## 4. Phase 3: Autonomy Stack (Month 10–18)

**Skills:** EKF, particle filter, A*/RRT, Nav2, OpenCV/YOLO, PyTorch basics, MoveIt 2

**Study:**
- Deep Learning Specialization, PyTorch tutorials, Ultralytics YOLO + OpenCV

**Builds:**
1. Autonomous inspection run: map → localize → navigate + avoid
2. Vision detection + go-to-object
3. MoveIt arm pick-place in sim (optional)

## 5. Phase 4: Sweet Spots — 20% Time, Parallel

**Chip/Edge**
- Digital logic, Verilog intro, STM32/FreeRTOS, KiCad PCB
- Project: custom sensor board + FPGA demo later. Now: ESP32 + micro-ROS bridge to ROS 2.

**Cyber**
- Linux hardening, networking, SROS2 DDS security, MQTT/TLS, OTA
- Project: attack-vs-secure demo (see Thesis Option B)

**Cloud/DevOps**
- Docker, GitHub Actions CI, AWS EC2/S3/IoT Core, K3s basics, Foxglove/Grafana
- Project: ROS in Docker + CI test + telemetry dashboard

## 6. Hardware Buying Plan — $15/mo

### Month 1 shopping list (~$12–15)

- [ ] ESP32 DevKit V1 (30-pin, CP2102/CH340) ×1 — ~$6–8
- [ ] Micro-USB **data** cable (not charge-only) ×1 — ~$2–3 (test with phone data transfer)
- [ ] 830-point breadboard ×1 — ~$2–3
- [ ] Male-male + male-female jumper wires, 40pc pack — ~$2–3
- [ ] Ask lab first for free: any of the above, multimeter access
- Buy AliExpress/Jumia/Konga clones. Avoid starter kits.
- Week 1 test: blink + serial print + WiFi scan. If it fails, the cable is the cause 90% of the time.

- Month 2: HC-SR04 ultrasonic + MPU6050 IMU (~$10–15)
- Month 3: 2WD chassis kit (TT motors + wheels + chassis) + L298N driver (~$15–20 over 2 months)
- Month 4: 18650 holder / power bank module + SG90 servo (~$10–15)
- 3D printing: no printer. Design in Onshape, print per-part at a makerspace.
- Sources: dept lab / robotics club free first, then AliExpress/Jumia/Konga clones.

Minimal moving-robot BoM: ~$35–45 over 3 months = ESP32 + chassis + L298N + HC-SR04 + power.

## 7. Thesis — LOCKED: A+B Combo + Archive C

**Title:** *Low-Cost Connected Mobile Robot with Secure Telemetry for Indoor Inspection*
**Structure:** Ch.3 = A (moves + dashboard), Ch.4 = B (attack blocked). One build, two stories. 6 months, ~$40 total.
**Why locked:** there is always something moving to show, even if cloud/security fails — worst case you still demo the sim + obstacle avoidance.

### Option A: Low-Cost Inspection Robot with Cloud Telemetry — [Ch.3]

**What:** 2WD ESP32 car that drives, avoids obstacles, sends distance/battery/position to a laptop dashboard. ROS 2 Gazebo twin does mapping/Nav2. Same code logic on sim + real.

**Physical demo:** robot drives forward, stops/turns at a wall, dashboard updates live graphs, plus a Gazebo video of a bigger autonomous map run.

**Why good:** hits robotics + cloud, looks like a product, easy to explain.
**Complexity (1–5):** 3/5. Sim is standard tutorials; hardware is just ESP32 + ultrasonic + motors. No SLAM on the real robot (SLAM only in sim).
**6-month split:** Mo1–2 ROS sim + ESP32 sensors; Mo3–4 car moves + dashboard; Mo5–6 write-up + polish.
**Risk:** motors/power wiring. Mitigation: USB power bank + L298N module, keep sim as backup demo.

### Option B: Secure ROS 2 Mobile Robot (Cyber angle) — [Ch.4]

**What:** same moving car/sim, plus you *show* a hack then fix it. An attacker laptop publishes fake `/cmd_vel` to hijack the robot; then SROS2 security + auth blocks it.

**Physical demo:** robot moves normally → attacker takes over (robot spins / goes wrong way) → secure mode on → attack blocked, robot resumes. Very visual.

**Why good:** almost no extra hardware, novel for undergrad, direct Palantir/Anduril relevance.
**Complexity:** 2.5/5. Mostly software config + a demo script.
**6-month split:** Mo1–3 robot moves in sim + real; Mo4–5 attack/secure demo + measurements (latency, packet loss); Mo6 write-up.
**Risk:** SROS2 setup docs are painful. Mitigation: keep insecure vs secure videos pre-recorded as backup.

### [ARCHIVE — FALLBACK ONLY] Option C: Vision-Following Robot (Edge/AI)

> Status: archived 2026-09-24. Use only if A+B is blocked. Do **not** start unless the Ch.3 car is already moving.

**Unarchive trigger:** A+B hardware fails for 3+ weeks OR supervisor demands CV, AND phone-as-camera works in sim.

**What:** robot with camera follows a colored ball/person using OpenCV/YOLO. Use laptop webcam or phone as IP camera to avoid buying an ESP32-CAM initially.
**Physical demo:** place object, robot turns and follows it.
**Complexity:** 4/5 — vision tuning + lighting + compute is finicky. Hardest to finish in 6 months on Intel Iris Xe + $15/mo.
**Risk:** slow YOLO training without GPU, camera latency. Only pick if you love CV.

**6-Month Thesis Milestones (A+B)**
- Mo1: ROS sim drives + ESP32 sensors read
- Mo2: sim SLAM/Nav2 run video + car chassis ordered
- Mo3: real car moves + avoids wall + live dashboard
- Mo4: attack demo (hijack) + secure mode blocked, with measurements
- Mo5: full system test + backup videos recorded
- Mo6: write-up + polish + defense rehearsal

**Defense fallback ladder:** 1. live car → 2. live sim → 3. pre-recorded video. Always bring all three.

## 8. 12-Week Sim-First Checklist

- [ ] Wk 1–2: ROS2 Humble + Git. Python kinematics plot.
- [ ] Wk 3–5: ROS nodes/topics/services/launch/URDF. Gazebo diff-drive teleop video.
- [ ] Wk 6–8: PID + slam_toolbox + Nav2 warehouse run. ESP32 blink + sensor read.
- [ ] Wk 9–10: OpenCV + ROS camera detection. Dockerize sim.
- [ ] Wk 11–12: telemetry to Foxglove/cloud + 2-page thesis proposal (A+B combo).

## 9. Palantir Track (Year 2–4)

- Multi-robot fleets, data pipelines, digital twins (Isaac Sim once there's a GPU)
- Pick 1 painful problem: warehouse, farm, inspection, security drones
- Competitions: F1TENTH sim, RoboCup sim, Lunabotics
- Open source: contribute to Nav2/MoveIt. Internships.

## 10. Skills Matrix 0–5 (update monthly)

| Skill | Level |
|---|---|
| Python | 1 |
| C++/C | 0 |
| Linux/Git | 1 |
| ROS 2 | 0 |
| Control | 1 |
| CV/AI | 0 |
| Embedded/ESP32 | 0 |
| Security | 0 |
| Docker/Cloud | 0 |
| CAD | 1 |
