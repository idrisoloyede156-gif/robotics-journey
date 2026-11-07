# Thesis Experiment Design — Attack Demo + Secure-Mode Overhead Measurement

> Companion to [docs_THESIS_VALIDATION.md](../docs_THESIS_VALIDATION.md) and Chapter 4 (Option B) of the plan.
> One rig, two stories: the car must still drive for inspection (Ch.3) while this doc turns the security
> chapter into a measured experiment, not a demo.

## Goal and hypothesis

**Goal:** reproduce an unauthorized `/cmd_vel` injection against the robot, block it by enabling
SROS2/DDS-Security authentication on the ROS 2 side, and quantify what the protection costs.

**Hypotheses (write these down and defend them with the metric table):**

- **H1 (attack works):** a host on the same Wi-Fi can publish fake `geometry_msgs/Twist` to `/cmd_vel`
  and steer the robot while security is disabled.
- **H2 (mitigation works):** with SROS2/DDS-Security authentication + permissions enabled on the
  ROS 2 agent side, unauthenticated publishers cannot affect the robot.
- **H3 (cost is measurable):** enabling security introduces measurable latency/jitter/packet-loss and
  ESP32-side CPU/memory deltas that we can report with confidence intervals.

**Scoping honesty (defensible version of claims):**
- SROS2/DDS-Security enforcement happens **on the ROS 2 / micro-ROS agent side (laptop)**.
- The micro-ROS client on the ESP32 has partial XRCE-DDS security support — document what is and is
  not authentifiable on-device, and treat that boundary as a thesis contribution, not an accident.
- Never write "SROS2 enabled on the ESP32 robot" in general terms in the thesis text.

## Rig and phases (sim-first, hardware second)

| Phase | Rig | Purpose | Plan milestone |
|---|---|---|---|
| A | Laptop only: ROS 2 Humble in WSL2/Docker, sim diff-drive (Gazebo), attacker from a second container/laptop | Prove H1/H2 and measurement pipeline with zero hardware spend | Mo1–Mo2 (sim SLAM/Nav2) |
| B | Phase A rig + ESP32 DevKit V1 via micro-ROS agent (UDP 8888), HC-SR04, MPU6050, INA219 on bench | Measure real-constrained-device deltas; wheels on blocks, no chassis yet | Mo2–Mo3 |
| C | Full 2WD car (L298N + TT motors, power bank) on indoor floor | Full-system runs for Ch.4 measurements and defense-demo recording | Mo3–Mo4 |

Attacker node options (any one, chosen by what is available):
1. Second laptop on same Wi-Fi running ROS 2 in Docker.
2. Same laptop, attacker in a separate Docker network namespace (weaker realism — LAN path absent; still valid for control-injection proof, gate the LAN claim on option 1).
3. Raspberry Pi/phone hotspot client if a second ROS-capable machine is unavailable late (fallback only).

Network notes from earlier research: use a single phone-hotspot/test SSID, record signal/AP mode;
ROS 2 discovery delays can reach tens of seconds — wait out discovery and record it as a metric, do
not silently skip it.

## Metric table (measure before/after security enable)

| Metric | Definition | Tool / where | Notes |
|---|---|---|---|
| Command RT latency | echo round-trip on `/cmd_vel` (or a paired echo topic) | rclcpp/rclpy micro-benchmark node with `std::chrono` timestamps | primary per-command metric |
| One-way latency | header timestamp vs receipt at subscriber (compact control frames) | synchronized clocks required; otherwise report RT only | document sync method honestly |
| Delivery/packet loss % | sent vs received command count, pcap-verified | node counters + `tcpdump` capture | loss correlates with Wi-Fi quality; record SSID/AP mode each run |
| Jitter | latency stddev across all commands; pcap stats as cross-check | node statistics + Wireshark/CICFlowMeter | 3+ runs per condition |
| Traffic overhead | attacker-injected or security-handshake bytes vs genuine bytes | pcap byte counts | compare vs Raven-II 0.24% reference |
| ESP32 CPU/mem | loop frequency + free heap + `uxTaskGetSystemState` | Arduino/micro-ROS counters → serial/agent topic | MCU-side delta; optional but strengthens H3 |
| Discovery time | node-up to topic-matchable | test script timer | expected tens of s on Wi-Fi |
| Battery telemetry rate | INA219 `sensor_msgs/BatteryState` Hz before/after | subscriber-side Hz counter | ties Ch.3 telemetry story in |

Geometry reminder: the raw numbers table is the thesis. A demo is a workshop show; the table is the
original contribution (first ESP32-class measured numbers per the validation report's gap).

## Test procedures (each = a repeatable script)

- **T0 Version lock:** never lose a run to misconfiguration — a script prints all versions (ROS 2
  distro, RMW/DDS impl, SROS2/keymint tooling, micro-ROS/XRCE-DDS versions, ESP32 Arduino core,
  firmware sketch hash) into an auto-generated `environment.txt` shipped with every run's output.
- **T1 Attack repro (H1):** attacker `ros2 topic pub /cmd_vel ...` while operator commands differ;
  record robot state timeline video + node logs; success = observed deviation matches injected intent.
- **T2 Baseline (insecure):** 3+ × 150 s runs on a fixed low-clutter course, identical Wi-Fi
  conditions → metrics into `experiments/results/t2_insecure_runN.csv`.
- **T3 Secure enable (H2):** generate keys/enclaves with the `ros2 security` tooling, set
  `ROS_SECURITY_MODE` and access policy on the agent side, verify the attacker's publisher is rejected
  (log line + zero robot movement on video) → repeat T2's protocol as T4 under the same conditions.
- **T4 Secure measure (H3):** same T2 protocol; the delta table T2 vs T4 is the thesis centerpiece.
- **T5 Traffic proof:**
  `tcpdump -i wifi -w experiments/results/t{N}/capture.pcap` on the agent laptop, post-process with
  CICFlowMeter.

**Naming:** every artifact lands in `results/<TID>_<label>_<date>/` with an auto-printed
`environment.txt`. No hand-typed numbers anywhere; scripts write all CSVs/pcaps.

## Threat model snapshot (appendix seed)

- Assets: robot motion authority (`/cmd_vel`), sensor telemetry truthfulness, battery telemetry.
- Entry points: Wi-Fi access, unauthenticated DDS/XRCE-DDS endpoints.
- Attacker model: anyone on same SSID, no credentials, public tooling only (`ros2cli`).
- Out of scope: physical access, firmware tampering, wireless-layer attacks (jamming/evil-twin) —
  listed, then excluded with a sentence.

## Safety and ethics

- Indoor lab/floor only, power bank strapped, wheel-blocks during bench runs, emergency manual
  power switch on main battery feed.
- Own equipment + own SSID as the attack network; never attack a third party's network.

## Deliverables → where they land in the repo

| Artifact | Path |
|---|---|
| Scripts (T0–T5) | `experiments/scripts/` |
| Raw results (CSV/pcap + auto `environment.txt`) | `experiments/results/<TID>_<label>_<date>/` |
| Analysis notebook / plots | `experiments/analysis/` |
| Thesis chapter figures | `experiments/figures/` |

## Environment (per-run, script-generated `environment.txt`)

- ROS 2 distro, RMW/DDS implementation + versions, SROS2/keymint tooling version
- micro-ROS / XRCE-DDS versions (agent + client), ESP32 Arduino core version, firmware sketch hash
- Wi-Fi SSID/AP mode + signal, laptop load, run duration, clock-sync method if one-way latency is used

## Walk order (6-month map)

| Month | Experiment step |
|---|---|
| Mo1 | Phase A rig up; T1 attack repro in sim (demo video) |
| Mo2 | T2 baseline table in sim; ESP32 on bench (Phase B), version-lock header |
| Mo3 | T3 secure enable on agent side (block verified on video), car assembled |
| Mo4 | T4 secure measures + T5 pcap; delta table drafted |
| Mo5 | Full-system test; backup videos; statistical reporting (mean ± CI) |
| Mo6 | Write-up: gap claim (ESP32-class measurement) + limitations section |
