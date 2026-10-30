# robotics-journey

Documenting a full-time run at robotics engineering: mechatronics final year, sim-first, no hardware budget to speak of.

**Main track:** robotics · **Parallel 20% tracks:** cybersecurity, chip design, cloud/DevOps
**Long-term goal:** own a company like Palantir — robots + secure data + cloud.
**Thesis:** *Low-Cost Connected Mobile Robot with Secure Telemetry for Indoor Inspection* (build one robot, tell two stories: inspection + security).

## Status

| | |
|---|---|
| Plan | ✅ locked — [robotics-learning-plan.md](robotics-learning-plan.md) |
| Environment | ✅ Ubuntu 22.04 + ROS 2 Humble + Gazebo 11 + Docker |
| Offline toolkit | ✅ ~10GB cache, hash-verified |
| Repo on Ubuntu | ⏳ not cloned yet |
| Next | ⏳ Week 1: `kinematics_2d.py` + Wokwi ESP32 sim |

## Start here on a new machine

```bash
git clone https://github.com/idrisoloyede156-gif/robotics-journey.git
cd robotics-journey
```

Read the plan for direction, read the journal's top entry for where the last session stopped, then pick up the open **Next** item.

## Docs

| File | What it is |
|---|---|
| [robotics-learning-plan.md](robotics-learning-plan.md) | The roadmap: phases, thesis, hardware budget, 12-week checklist, skills matrix. Changes only when strategy changes. |
| [docs/JOURNAL.md](docs/JOURNAL.md) | The documentation: dated, append-only log of what was actually done, blocked, and next. Updated every session. |
| [docs_THESIS_RESEARCH.md](docs_THESIS_RESEARCH.md) | Thesis literature/engineering research, 11 sources. |
| [scripts/SETUP-DAY.sh](scripts/SETUP-DAY.sh) | Offline Ubuntu setup + the one-shot online install block (ROS 2, Gazebo, Docker, KiCad, Python wheels). |

Rule of thumb: **plan = where I'm going, journal = where I've been.** Project-level READMEs and demo videos are the proof.

## Repo maintenance

- `robotics-learning-plan.md` is strategy. It changes only when the approach changes.
- `docs/JOURNAL.md` is the record. Append-only, newest first, one entry per session/week with **Done / Demo / Blocked / Next / Hours**.
- The status table above is the one-screen truth and is updated in the same commit as any journal entry.
- No invented progress: if it isn't confirmed done, it goes under *Next*, not *Done*.
- Public copy: keep usernames, drive letters and machine IDs out of the plan and journal.

## Tooling

- `tavily_helper.py` — `robotics_search()` / `robotics_extract()` via `tavily-python` (needs `TAVILY_API_KEY`).
- Setup: `pip install -r requirements.txt`, copy `.env.example` to `.env` with a key from https://app.tavily.com
- Test: `python -m pytest test_tavily_helper.py -v`
