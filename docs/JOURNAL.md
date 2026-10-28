# Journal

Append-only record of what actually happened. Newest entry first.
One entry per work session or week: **Done / Demo / Blocked / Next / Hours**.
The roadmap this tracks lives in [`PLAN.md`](PLAN.md).

---

## 2026-10-28 — Ubuntu installed, plan published

**Done**
- Ubuntu 22.04 installed on the dedicated 512GB SSD (Windows untouched on its own drive).
- Offline setup script ran on the new install: VS Code, Arduino CLI, ESP32 core staged, Foxglove installed.
- `SETUP-DAY.sh` patched: pip bootstrap moved into the internet block, Gazebo + Docker + KiCad 8 + colcon/rosdep added so one online session covers the first 18 months.
- Published this repo's docs: roadmap, journal, setup script.

**Demo** — none yet (infrastructure phase).

**Blocked**
- Offline pip bootstrap can't work without internet → NumPy/OpenCV/pyserial deferred to the online session (wheels already cached, so no download needed).
- The single big install session has not run yet.

**Next**
- Run the online install block on Ubuntu: ROS 2 Humble + Gazebo + Nav2 + Docker + KiCad + cached wheels.
- Verify: `talker`/`listener`, `gazebo --version`, `docker run hello-world`.
- Then Week 1 build: Python 2-link arm kinematics.

**Hours** — not tracked yet.

---

## 2026-10-26 → 10-27 — Setup day: installer fight

**Done**
- 512GB NVMe confirmed blank-of-value (old Windows install, approved for wipe).
- Ubuntu 22.04 written to a 29GB USB stick with Rufus.
- Secure Boot obstacle resolved; GRUB and the Ubuntu installer reached.
- Ubuntu installed alongside the existing Windows drive (chosen at boot via F12).

**Blocked**
- First boot failed with UEFI `Verification failed (0x10A) Security Violation`. Cause: Rufus ISO mode used an unsigned UEFI:NTFS helper because the ISO has a >4GB casper file, and Secure Boot rejects unsigned loaders. Fix: disable Secure Boot in BIOS (and remember to click *Apply* before exiting — Dell silently discards it otherwise).

**Next** — offline cache setup, then the online install session.

**Hours** — not tracked.

---

## 2026-10-13 — Offline toolkit cached (~10GB)

**Done**
- External drive prepared with `robotics-offline/`: Windows installers (Git, Python 3.11.9, VS Code, Docker, Arduino IDE + CLI, KiCad, FreeCAD, VirtualBox, OBS), Ubuntu 22.04.5 ISO (SHA256 verified), and a Linux stack (VS Code .deb, Arduino AppImage + CLI, Foxglove, ESP32 core 3.3.12 with all tool archives size-verified, Linux Python wheels, offline pip bootstrap, `SETUP-DAY.sh`).
- Battery guard set: sleep at 20%, hibernate at 7%.

**Blocked**
- ROS 2 can't be pre-cached meaningfully from Windows — needs one tethered apt session. Documented as a known gap.

**Next** — wait for the SSD, then install.

**Hours** — not tracked.

---

## 2026-09-24 — Kickoff

**Done**
- Career direction set: robotics as the main track, cybersecurity / chip design / cloud-DevOps as parallel 20% tracks.
- Roadmap written: foundations → ROS 2 → autonomy → sweet spots → company track.
- Thesis locked: A+B combo, *Low-Cost Connected Mobile Robot with Secure Telemetry for Indoor Inspection* (Option C archived as fallback).
- Repo created.

**Blocked**
- No WSL2 yet (storage), no microcontrollers, no 3D printer → sim-first + browser tools.

**Next** — Python kinematics, Git workflow, Wokwi ESP32 simulation, Onshape.

**Hours** — not tracked.
