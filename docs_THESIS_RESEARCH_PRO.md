# Thesis Research (Pro): Low-Cost Connected Mobile Robot with Secure Telemetry

_Generated via Tavily Research `--model pro` | request `b4f6978e-cddd-4962-94a9-c44421684364` | status completed_

# Low‑cost 2WD ESP32 indoor inspection robot with ROS 2 digital twin and SROS2 evaluation

## Executive summary
A practical, low‑cost indoor inspection robot can be built from an ESP32 dev board, an L298N (or modern low‑loss alternative) motor driver, two small geared DC motors with wheels, an HC‑SR04 ultrasonic for coarse obstacle sensing, and an IMU such as the MPU‑6050; battery telemetry can be read with an INA219 I²C monitor and streamed to a laptop dashboard (Foxglove or Grafana) while a ROS 2 / Gazebo digital twin runs slam_toolbox + Nav2 for mapping and navigation. A realistic attacker on the same LAN can inject fake /cmd_vel messages and drive the robot, and enabling DDS/SROS2 policy enforcement reliably blocks unauthenticated publishers but imposes measurable latency overhead on Wi‑Fi links; the documented guidance below gives a reproducible build plan and an experimental evaluation to quantify the security/performance tradeoffs. [22], [23]

## Chapter A — Hardware, wiring, power and telemetry

### Bill of materials (concrete, low‑cost)
- ESP32 DevKit (ESP32‑DevKitC family) — development board for Wi‑Fi/Bluetooth connectivity and microcontroller functions. [1]  
- Motor driver: L298N dual H‑bridge (inexpensive, widely available) as baseline; consider TB6612FNG or DRV8833 for lower voltage drop and higher efficiency as alternatives. [2], [10], [11]  
- Two small DC geared motors with matching wheels (micro metal or TT/Pololu style). [6]  
- HC‑SR04 ultrasonic sensor for short‑range obstacle detection (2–400 cm, ~±3 mm accuracy). [3]  
- IMU: MPU‑6050 breakout for cost‑sensitive builds; evaluate BNO055/ICM‑20948 if better on‑board fusion and reliability are required (MPU‑6050 has known drift/failure concerns). [4], [5]  
- Battery: 2S LiPo ~2000 mAh (example vendor model) with common ground to ESP32; use buck regulator if the ESP32 needs regulated 5 V/3.3 V. [7]  
- Battery monitoring: INA219 I²C power monitor to publish voltage/current to the ESP32. [8]  
- Mechanical mounting: small chassis, spacers, vibration‑isolation where motor vibration causes sensor noise. [21]

Tradeoffs: L298N supports wider motor voltages and higher current but is inefficient and heats under >1 A; TB6612/DRV8833 are smaller, more efficient, and better for battery life at typical small‑robot currents. [2], [10], [11]

### Wiring, mounting and common pitfalls
- Keep a single common ground between battery, ESP32 and motor driver; failure to do so causes unreliable signals and sensor readings. Also respect L298N jumper rules (5 V regulator/jumper) and avoid powering logic incorrectly. [9], [2]  
- Avoid echo interference when using multiple HC‑SR04 sensors; space triggers or wait ≥60 ms between triggers. Mount ultrasonics to minimize reflections. [3]  
- Fit heatsinks to L298N if per‑channel currents approach 1 A continuous. Provide mechanical isolation to reduce IMU vibration. [2], [21]

### Power and battery telemetry
- Monitor battery voltage/current with INA219 over I²C and publish sensor_msgs/BatteryState (or a custom telemetry topic) from the ESP32 node to ROS 2. The INA219 has tooling/examples for ESP32. [8]  
- Keep wiring to the INA219 and ESP32 short and referenced to common ground for accurate readings. [8]

## Chapter A — Electronics, firmware, and ROS 2 integration

### ESP32 ⇄ ROS 2 connection options and recommendation
- Use micro‑ROS on the ESP32 to integrate directly into a ROS 2 graph (micro‑ROS clients use XRCE‑DDS and an agent bridge). Evidence shows micro‑ROS supports ESP32 targets and an agent can run over serial or UDP. [12], [13], [14]  
- Alternatives: lightweight network bridges that forward topics over UDP/TCP (network_bridge) or an MQTT bridge to a ROS gateway; these are simpler but do not provide native ROS 2 QoS/DDS semantics or built‑in authentication. [15]

Recommendation: micro‑ROS over Wi‑Fi (UDP transport) for a minimal working stack that publishes odometry/IMU/battery and subscribes to /cmd_vel; use the micro‑ROS agent on the laptop to surface topics into ROS 2. [12], [13], [14]

### Drivers and topic publication
- Motor control: PWM EN pins and IN1/IN2 direction lines from ESP32 to driver (observe ENA PWM frequencies examples for ESP32 on L298N tutorials). Publish odometry (nav_msgs/Odometry) from encoder or dead‑reckoned wheel integration; if encoders are not available, publish odom as odometry‑only with expected drift. [9], [6]  
- IMU: publish sensor_msgs/Imu from MPU‑6050 readings; consider sensor fusion on the laptop if MPU‑6050 drift is a concern. [4], [5]  
- Ultrasonic: publish ranges as sensor_msgs/Range for obstacle layers. [3]  
- Battery: publish sensor_msgs/BatteryState or std_msgs/Float32 for voltage from INA219. [8]

### ROS 2 distro and Gazebo model compatibility
- Build URDF/xacro for the differential drive robot and convert to SDF for Gazebo following standard tutorials; Gazebo diff‑drive plugin expects wheel names, wheel radius, separation and cmd topic name. Use use_sim_time when running slam_toolbox / Nav2 in simulation. [16], [17]

Gazebo battery and sensor plugins are available to mirror battery telemetry and ultrasonic/IMU topics for the digital twin. [18]

## Chapter A — Digital twin, mapping and navigation
- Use slam_toolbox in online mode with use_sim_time and publish a simulated /scan topic (or lidar substitute) to Nav2; Nav2 should be launched with parameters tuned for slow, low‑acceleration platforms (reduce max_vel_x, increase controller patience). Evidence suggests CycloneDDS is recommended for Nav2 due to fewer issues with Fast DDS. [17]  
- Keep sim/real parity by matching wheel radius, base width, IMU noise models and sensor update rates between URDF/Gazebo plugins and ESP32 topics. Use the gazebo_ros_battery plugin to expose battery state in sim. [18]

## Telemetry and dashboards
- Foxglove: run the foxglove_bridge on the laptop (WebSocket at port 8765) and publish ROS 2 topics (pose, battery, camera if present) to view in Foxglove. [19]  
- Grafana: log ROS 2 telemetry (pose at modest rate, battery) into InfluxDB via a lightweight node and visualize with Grafana; prior ROS 2 platforms used 4 Hz logging into InfluxDB for dashboards. [20]  
- Network: Wi‑Fi AP mode is simple but may introduce discovery delays and latency spikes; ad‑hoc/mesh reduces infrastructure dependence but complicates security. Wireless discovery on ROS 2 can cause up to tens of seconds delays in practice. Design the network for predictable latency during experiments. [21]

## Chapter B — Threat model, attack reproduction, and defenses

### Attacker model and reproduction
- Attacker capability: ability to run a node on the same LAN (or compromised laptop) that publishes to /cmd_vel is sufficient to hijack an unsecured ROS 2 robot; ROS 2 without SROS2 enforces no publisher authentication by default. Reproduce the attack by running a simple ROS 2 node that publishes Twist on /cmd_vel in sim or against the real robot when micro‑ROS agent exposes the topic. Wireshark and DDS traffic inspection can demonstrate unauthorized publishers. [22]

### SROS2 / DDS security effectiveness and practical steps
- Enabling DDS security / SROS2 (generate keystore, certificates, and policy files) enforces authentication and prevents unauthenticated publishers from affecting robot topics; OSRF documentation provides tooling to generate keystores and policies. However, enabling DDS security over Wi‑Fi increases communication latency compared to unsecured operation, as observed in measurement studies. Also, some DDS packaging (e.g., CycloneDDS Debian package) may lack security plugins and require careful vendor setup. [24], [25], [23]

Evidence gaps: the findings do not provide exact SROS2 command sequences, measured numeric latency/packet‑loss values for the ESP32 ↔ laptop scenario, nor ready‑to‑run attack/benchmark scripts suitable for immediate download. These artifacts must be assembled from the cited tooling and community examples. [23], [24]

## Experimental evaluation plan and metrics (reproducible outline)
- Testbed: (A) Gazebo twin with same ROS 2 nodes and micro‑ROS agent endpoints, (B) physical robot with ESP32 micro‑ROS over Wi‑Fi to laptop. Compare baseline (no security) vs SROS2 enforced (DDS/Security) and optionally network segmentation/VPN. [12], [17], [24]  
- Metrics: end‑to‑end command latency (ms), packet loss (%), message throughput, CPU/memory of laptop nodes, navigation success rate/time‑to‑goal/path deviation. Use Wireshark/DDS packet inspection to confirm blocked publishers and observe latency/overhead. [22], [23]  
- Methodology: run repeated runs with deterministic goals in sim and physical runs with logged timestamps (use use_sim_time in sim). Induce network variability by varying Wi‑Fi conditions and record effects on latency and Nav2 success. Note that prior work reports increased secure‑DDS latency and Wi‑Fi scaling effects on latency. [23], [21]

## Recommendations and deliverables
- Default configuration: micro‑ROS on ESP32 (UDP Wi‑Fi), TB6612FNG/DRV8833 driver for better battery life if currents are low, INA219 telemetry, Foxglove bridge for quick visualization, Gazebo twin with slam_toolbox + Nav2 using CycloneDDS where supported, and SROS2/DDS security enabled with generated keystore for deployment. [12], [10], [8], [19], [17], [24]  
- Deliverables to produce (must be assembled): BOM and wiring diagrams; ESP32 micro‑ROS firmware example and micro‑ROS agent launch commands; ROS 2 node examples publishing odom/IMU/battery; URDF/Gazebo model and Nav2 + slam_toolbox launch files; SROS2 keystore/policy generation scripts; attack scripts to publish /cmd_vel; benchmark scripts and runbook for experiments. Evidence shows examples and tutorials exist but a unified artifact set is not provided in the evidence and must be compiled from the cited resources. [12], [13], [26], [16], [24]

## Evidence gaps
- No numeric latency/packet‑loss measurements comparing unsecured vs SROS2 for ESP32 ↔ laptop over Wi‑Fi are present in the findings. [23]  
- No complete SROS2 keystore generation scripts or turnkey attack/benchmark scripts were published in the cited evidence; OSRF tooling exists but repo‑level artifacts are not provided. [24]

## Works Cited
[1] https://espressif.com/en/products/devkits/esp32-devkitc/overview  
[2] https://walmart.com/c/kp/l298n-motor-driver-arduino  
[3] https://sparkfun.com/ultrasonic-distance-sensor-hc-sr04.html  
[4] https://dfrobot.com/product-880.html  
[5] https://docs.slimevr.dev/diy/imu-comparison.html  
[6] https://dfrobot.com/product-1736.html  
[7] https://maxamps.com/products/lipo-2000-2s-7-4v-battery-pack  
[8] https://waveshare.com/wiki/Tutorial_VII:_INA219_Voltage_And_Current_Monitoring_Demo  
[9] https://microcontrollerslab.com/l298n-dc-motor-driver-module-esp32-tutorial  
[10] https://mm.digikey.com/Volume0/opasdata/d220001/medias/docus/925/TB6612FNG_Hookup_Guide_Web.pdf  
[11] https://youtube.com/watch?v=N2Flo0UXTHE  
[12] https://arw-proceedings.acin.tuwien.ac.at/article/id/736  
[13] https://technologiehub.at/project-posts/micro-ros-on-esp32-tutorial  
[14] https://github.com/micro-ROS/micro-ROS.github.io/blob/master/_docs/overview/comparison/index.md  
[15] https://github.com/brow1633/network_bridge  
[16] https://classic.gazebosim.org/tutorials?tut=ros_urdf  
[17] https://roboticsbackend.com/ros2-nav2-generate-a-map-with-slam_toolbox  
[18] https://github.com/ctu-vras/gazebo_ros_battery  
[19] https://makerspet.com/blog/how-to-view-robot-telemetry-using-foxglove  
[20] https://mdpi.com/2224-2708/14/6/110  
[21] https://robocloud-dashboard.vercel.app/learn/blog/robotics-wireless-networking  
[22] https://enisgetmez.com/ros-2-robot-hacking-dds-wireshark-cmd-vel-hijack  
[23] https://thesis.unipd.it/retrieve/85d6508d-b872-4d16-a9df-0252e4fa4fe3/Ramezani.Negar.pdf  
[24] https://osrf.github.io/ros2multirobotbook/security.html  
[25] https://robotics.stackexchange.com/questions/97262/working-with-rmw-cyclonedds-and-sros2  
[26] https://github.com/parv2031/AutonomousMobileRobot

## Sources

- [L298N Motor Driver Modules for Arduino Projects](https://www.walmart.com/c/kp/l298n-motor-driver-arduino)
- [Micro Metal DC Geared Motor 6V 50RPM 250g·cm - DFRobot](https://www.dfrobot.com/product-1736.html)
- [Ultrasonic Distance Sensor - 5V (HC-SR04) - SparkFun Electronics](https://www.sparkfun.com/ultrasonic-distance-sensor-hc-sr04.html)
- [Fermion: MPU-6050 6 DOF Sensor (Breakout) - DFRobot](https://www.dfrobot.com/product-880.html)
- [LiPo 2000mAh 2S 7.4v Battery Pack - MaxAmps](https://maxamps.com/products/lipo-2000-2s-7-4v-battery-pack)
- [Interface L298N DC Motor Driver Module with ESP32 using Arduino IDE](https://microcontrollerslab.com/l298n-dc-motor-driver-module-esp32-tutorial)
- [Tutorial IX: INA219 Voltage And Current Monitoring Demo - Waveshare Wiki](https://www.waveshare.com/wiki/Tutorial_VII:_INA219_Voltage_And_Current_Monitoring_Demo)
- [DIY Motor Driver Comparison: DRV8833 vs L298N (Power Test + Demo)](https://www.youtube.com/watch?v=N2Flo0UXTHE)
- [ESP DevKits | Espressif Systems](https://www.espressif.com/en/products/devkits/esp32-devkitc/overview)
- [TB6612FNG Hookup Guide](https://mm.digikey.com/Volume0/opasdata/d220001/medias/docus/925/TB6612FNG_Hookup_Guide_Web.pdf)
- [IMU Comparison - SlimeVR Docs](https://docs.slimevr.dev/diy/imu-comparison.html)
- [A Modular and Configurable Architecture for ROS 2 Hardware ...](https://arw-proceedings.acin.tuwien.ac.at/article/id/736)
- [micro-ROS on ESP32 [tutorial] – Technologie Hub Wien](https://technologiehub.at/project-posts/micro-ros-on-esp32-tutorial)
- [GitHub - brow1633/network_bridge: C++ package for bridging ROS2 over UDP, TCP, or a custom implemented network interface · GitHub](https://github.com/brow1633/network_bridge)
- [Gazebo : Tutorial : URDF in Gazebo](https://classic.gazebosim.org/tutorials?tut=ros_urdf)
- [ROS2 Nav2 - Generate a Map with slam_toolbox - The Robotics Back-End](https://roboticsbackend.com/ros2-nav2-generate-a-map-with-slam_toolbox)
- [View ROS 2 Robot Telemetry in Foxglove — Step by Step](https://makerspet.com/blog/how-to-view-robot-telemetry-using-foxglove)
- [Data-Driven, Real-Time Diagnostics of 5G and Wi-Fi Networks Using Mobile Robotics](https://www.mdpi.com/2224-2708/14/6/110)
- [Experimental Characterization of ROS 2 Communication ...](https://thesis.unipd.it/retrieve/85d6508d-b872-4d16-a9df-0252e4fa4fe3/Ramezani.Negar.pdf)
- [ROS 2 Robot Hacking: Sniffing DDS Traffic with Wireshark... | Enis Getmez](https://enisgetmez.com/ros-2-robot-hacking-dds-wireshark-cmd-vel-hijack)
- [micro-ROS.github.io/_docs/overview/comparison/index.md at master · micro-ROS/micro-ROS.github.io · GitHub](https://github.com/micro-ROS/micro-ROS.github.io/blob/master/_docs/overview/comparison/index.md)
- [GitHub - parv2031/AutonomousMobileRobot: Autonomous Mobile Robot (AMR) for LiDAR-based SLAM and ROS2 Navigation using Raspberry Pi, ESP32, micro-ROS, SLAM Toolbox, and Nav2 — featuring autonomous mapping, differential drive control, odometry integration, and real-time indoor navigation. · GitHub](https://github.com/parv2031/AutonomousMobileRobot)
- [Wireless Networking for Robots: Wi-Fi, Latency, Multicast & ...](https://robocloud-dashboard.vercel.app/learn/blog/robotics-wireless-networking)
- [ros - Working with RMW CycloneDDS and SROS2 - Robotics Stack Exchange](https://robotics.stackexchange.com/questions/97262/working-with-rmw-cyclonedds-and-sros2)
- [Security - Programming Multiple Robots with ROS 2](https://osrf.github.io/ros2multirobotbook/security.html)
- [GitHub - ctu-vras/gazebo_ros_battery: Battery plugin (open-circuit model) for any kinds of robot simulations in Gazebo. · GitHub](https://github.com/ctu-vras/gazebo_ros_battery)