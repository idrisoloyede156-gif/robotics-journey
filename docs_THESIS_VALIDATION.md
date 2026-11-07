# Thesis Validation Report: Low-Cost Connected Mobile Robot with Secure Telemetry

_Generated via Tavily Research `--model pro` | request `3713e583-53a4-4d27-900a-8ce1fabd9a75` | status completed_
_Five validation questions: (1) problem legitimacy, (2) existing research, (3) research gap, (4) experimental feasibility, (5) academic defensibility._

# Validation report — "Low‑Cost Connected Mobile Robot with Secure Telemetry for Indoor Inspection"

## Executive summary
The proposed project — demonstrate a topic‑injection (/cmd_vel) hijack on a low‑cost ESP32 robot, enable SROS2/DDS‑Security (and micro‑ROS/XRCE‑DDS where applicable), and measure network/system effects before and after — is a well‑posed and defensible undergraduate Mechatronics thesis topic. Existing incident reports, threat models, datasets and research show unauthorized publishing and topic injection are real and exploitable risks; SROS2/DDS‑Security enforcement is an available mitigation; however, measured comparisons on constrained microcontroller platforms (ESP32) are under‑represented in the available evidence. The following sections synthesize the relevant evidence, identify gaps, recommend feasible reproducible experiments given the stated hardware/software, and assess academic defensibility.

## 1) Problem legitimacy
Unauthorized publishing and topic‑injection against robot control topics is documented and considered a core robotics threat. A published vulnerability demonstrates an attacker can craft a malformed geometry_msgs::Twist message and publish it to /cmd_vel, enabling control‑message manipulation in practice [3]. Analyses and advisories report that ROS/ROS2 allow nodes to publish to topics without authorization, so intruders who learn topic names/types can forge messages that reach subscribers [4]. CVE tracking contains a code‑injection vulnerability in ROS tooling (rostopic) demonstrating exploitable software weaknesses in ROS infrastructure [5]. A low‑cost AMR case study reports that unauthorised ROS commands from a connected endpoint caused disruptive availability failures on a production low‑cost robot, showing practical impact on inexpensive platforms [6]. Peer‑reviewed work and threat models emphasize actuator control and unauthorized publication as core concerns for ROS/ROS2 systems and teleoperated robots [7], [9]. Multiple surveys classify robotic vulnerabilities across communication, sensor, software and system classes, confirming this is a pervasive problem category in robotics security research [8]. 

Sources: [3], [4], [5], [6], [7], [9], [8].

## 2) Existing research (ROS/ROS2 security, SROS2/DDS‑Security, micro‑ROS/XRCE‑DDS, tools)
Datasets and lab prototypes document attack types and measurement methods: the NAVBOT25 dataset captures normal and attack scenarios on ROS systems and used tcpdump to capture traffic and CICFlowMeter to extract flow features, providing a reproducible baseline for network‑level analysis [1]. The ROS2 threat model and official design guidance list actuator control, unauthorized topic access, and DDS permissions as mitigation approaches, providing a standards‑level framing for using DDS‑Security to restrict publishing/subscribing [9]. Research shows SROS2/DDS‑Security enforcement can prevent malicious ROS2 nodes from accessing secured topics in multi‑tenant deployments, indicating the mitigation’s functional suitability [10]. Community resources and security working groups collect advisories and tool pointers for ROS security reporting and investigation, which are useful repositories of demos and known mitigations [12].

Evidence for explicit micro‑ROS/XRCE‑DDS security measurements and concrete published performance overheads (latency, packet loss, CPU/memory) on constrained microcontrollers in the cited material is not present; the literature above documents methodology and functional capability but not measured microcontroller overheads.

Sources: [1], [9], [10], [12].

## 3) Research gaps (especially for constrained microcontrollers)
The available evidence shows multiple datasets, threat models, and demonstrations on TurtleBot / Raven‑II / low‑cost AMR platforms, but it lacks experimental studies that quantify attack success and mitigation overhead specifically on constrained microcontroller targets such as ESP32. Vulnerability categorization surveys indicate varied vulnerability classes but do not report microcontroller measurement results, creating a gap between high‑level threat descriptions and low‑resource device performance data [8]. Likewise, the documentation that SROS2/DDS‑Security can block malicious nodes does not include empirical overhead numbers for XRCE‑DDS or micro‑ROS on ESP32‑class hardware in the reviewed sources [10], [9]. In short: functionally described mitigations exist, but measured tradeoffs on ESP32 (latency, jitter, packet loss, CPU/memory, throughput) are missing from the cited evidence.

Sources: [8], [10], [9].

Evidence Gaps
- No measured micro‑ROS/XRCE‑DDS security performance data for ESP32 or similarly constrained MCUs in the provided sources.  
- No prior published experiments directly comparing before/after SROS2/DDS‑Security metrics on an ESP32-based robot in the provided material.

## 4) Experimental feasibility with the stated hardware/software and recommended measurement methods
Reproducible attack demos: published evidence indicates practical reproduction of topic‑injection attacks is feasible because ROS/ROS2 allow unauthorized publishes when topics are known and a CVE / malformed Twist exploit exists for /cmd_vel; thus reproducing a fake /cmd_vel publish in a local testbed is supported by the evidence [3], [4]. The NAVBOT25 dataset methodology shows tcpdump + CICFlowMeter capture and feature extraction are a practical approach for network‑level measurement during attacks and mitigations [1]. The Raven‑II case demonstrates a full MITM attack against a robot and reports the malware prototype added ~0.24% additional traffic relative to genuine traffic, offering a prior numeric reference for traffic overhead of an attack artifact [2].

Recommended concrete measurement stack (supported by cited methods or recommended in standards): capture network traces with tcpdump (used in NAVBOT25) and derive flow statistics with CICFlowMeter for packet counts and loss estimation; instrument publishers and subscribers to include high‑precision timestamps in messages to compute one‑way and round‑trip delay where network sync is controlled (NAVBOT25 shows network capture methods but not timestamping specifics) [1]. Use the ROS2 threat model and DDS permissions configuration to define the SROS2/DDS‑Security policy before/after comparisons [9]. Compare aggregate traffic overhead figures against the Raven‑II reference (0.24% malware traffic example) as a sanity check [2].

Experimental factors to treat as variables and report: micro‑ROS/XRCE‑DDS version, Wi‑Fi link quality and measurement environment, chosen DDS implementation and cipher suites, and whether trace timestamps use synchronized clocks. The provided evidence does not specify micro‑ROS tracing tools or XRCE‑DDS measurement utilities; therefore include these as experiment choices and document them in methods.

Sources: [3], [4], [1], [2], [9].

## 5) Academic defensibility for a final‑year Mechatronics thesis
An undergraduate project that (a) reproduces a topic‑injection attack on an inexpensive robot, (b) implements SROS2/DDS‑Security permissions to block it, and (c) presents measured before/after metrics (round‑trip latency, one‑way latency where feasible, packet loss, jitter, CPU/memory, throughput) addresses an identified, real problem, applies documented mitigations, and fills an identified evidence gap (ESP32‑class measurement). Precedents include published case studies and research prototypes demonstrating attacks on real robots and the functional effectiveness of SROS2/DDS‑Security; combining a reproducible demo with systematic measurements on constrained hardware therefore meets reasonable originality and rigor expectations for a final‑year engineering thesis when experiments are carefully designed and limitations are reported [6], [2], [10]. Success criteria should include reproducible instrumentation, statistical reporting of metrics, and clear documentation of policy/configuration for SROS2/DDS‑Security and all experimental variables.

Sources: [6], [2], [10].

## Verdict and concrete next steps
Verdict: Legitimate, novel (given the documented evidence gap), feasible with the stated low‑cost hardware and ROS 2 Humble development platform, and academically defensible if accompanied by rigorous measurement methodology and clear reporting of experimental variables. Recommended next steps for a defensible thesis:
- Reproduce a /cmd_vel injection in a controlled environment (use the malformed Twist exploit pattern as a guide) and capture traffic with tcpdump; extract features with CICFlowMeter for baseline network statistics [3], [1].  
- Implement DDS permissions / SROS2 policies per ROS2 threat model guidance and verify functional blocking [9], [10].  
- Measure and report round‑trip and one‑way latency (via message timestamps if clocks are synchronized), packet loss and jitter from pcap and flow analysis, and CPU/memory overhead on the ESP32 and laptop; compare traffic overhead against the Raven‑II malware benchmark (0.24%) as contextual reference [2].  
- Explicitly document micro‑ROS/XRCE‑DDS versions, Wi‑Fi conditions, and DDS/cipher choices, and include an Evidence Gaps section (micro‑ROS/XRCE‑DDS performance data on ESP32) as a primary contribution.

## Works Cited
[1] https://pmc.ncbi.nlm.nih.gov/articles/PMC13080677  
[2] https://usenix.org/system/files/raid2019-chung.pdf  
[3] https://github.com/REYu6/ROS-vul/blob/main/Gazebo%20CVE/gazebo_ros_diff_drive.md  
[4] https://mdpi.com/2079-9292/13/9/1762  
[5] https://nvd.nist.gov/vuln/detail/cve-2024-41921  
[6] https://aliasrobotics.com/case-studies/case-study-cai-low-cost-AMR1.php  
[7] https://link.springer.com/article/10.1007/s40313-026-01249-x  
[8] https://arxiv.org/html/2412.19272v1  
[9] https://design.ros2.org/articles/ros2_threat_model.html  
[10] https://weisongshi.org/papers/xia25-ICRA.pdf  
[11] https://revistas.udc.es/index.php/JA_CEA/article/download/13793/9904  
[12] https://github.com/iotsrg/awesome-ros-security/blob/main/README.md

## Sources

- [NAVBOT25: Dataset for ROS-based autonomous robot navigation](https://pmc.ncbi.nlm.nih.gov/articles/PMC13080677)
- [Smart Malware that Uses Leaked Control Data of Robotic Applications](https://www.usenix.org/system/files/raid2019-chung.pdf)
- [ROS-vul/Gazebo CVE/gazebo_ros_diff_drive.md at main - GitHub](https://github.com/REYu6/ROS-vul/blob/main/Gazebo%20CVE/gazebo_ros_diff_drive.md)
- [Formal Analysis and Detection for ROS2 Communication Security Vulnerability](https://www.mdpi.com/2079-9292/13/9/1762)
- [NVD-CVE-2024-41921 - NIST](https://nvd.nist.gov/vuln/detail/cve-2024-41921)
- [awesome-ros-security/README.md at main · iotsrg/awesome-ros-security · GitHub](https://github.com/iotsrg/awesome-ros-security/blob/main/README.md)
- [Improving Data Injection Attack Detection in Robotics Systems: A Comparative Study of Machine Learning Models | Journal of Control, Automation and Electrical Systems | Springer Nature Link](https://link.springer.com/article/10.1007/s40313-026-01249-x)
- [Implementing a Robot Intrusion Prevention System (RIPS) for ROS 2](https://arxiv.org/html/2412.19272v1)
- [Case Study - CAI-powered API vulnerability discovery at Low Cost AMR1](https://aliasrobotics.com/case-studies/case-study-cai-low-cost-AMR1.php)
- [ROS 2 Robotic Systems Threat Model](https://design.ros2.org/articles/ros2_threat_model.html)
- [Protecting a Teleoperated ROS 2 Quadruped Robot](https://revistas.udc.es/index.php/JA_CEA/article/download/13793/9904)
- [Investigating Security Threats in Multi-Tenant ROS 2 Systems](https://www.weisongshi.org/papers/xia25-ICRA.pdf)