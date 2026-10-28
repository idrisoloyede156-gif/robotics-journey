# robotics-journey

Documenting a full-time run at robotics engineering: mechatronics final year, sim-first, no hardware budget to speak of.

**Main track:** robotics · **Parallel 20% tracks:** cybersecurity, chip design, cloud/DevOps
**Long-term goal:** own a company like Palantir — robots + secure data + cloud.
**Thesis:** *Low-Cost Connected Mobile Robot with Secure Telemetry for Indoor Inspection* (build one robot, tell two stories: inspection + security).

## Status

| | |
|---|---|
| Plan | ✅ locked — [docs/PLAN.md](docs/PLAN.md) |
| Environment | ✅ Ubuntu 22.04 on a dedicated SSD |
| Offline toolkit | ✅ ~10GB cache, hash-verified |
| Next | ⏳ ROS 2 Humble + Gazebo + Nav2 + Docker + KiCad install |
| Week 1 build | ⏳ Python 2-link arm kinematics |

## Docs

| File | What it is |
|---|---|
| [docs/PLAN.md](docs/PLAN.md) | The roadmap: phases, thesis, hardware budget, 12-week checklist, skills matrix. Changes only when strategy changes. |
| [docs/JOURNAL.md](docs/JOURNAL.md) | The documentation: dated, append-only log of what was actually done, blocked, and next. Updated every session. |
| [docs_THESIS_RESEARCH.md](docs_THESIS_RESEARCH.md) | Thesis literature/engineering research, 11 sources. |
| [scripts/SETUP-DAY.sh](scripts/SETUP-DAY.sh) | Offline Ubuntu setup + the one-shot online install block (ROS 2, Gazebo, Docker, KiCad, Python wheels). |

Rule of thumb: **plan = where I'm going, journal = where I've been.** Project-level READMEs and demo videos are the proof.

## Tooling

- `tavily_helper.py` — `robotics_search()` / `robotics_extract()` via `tavily-python` (needs `TAVILY_API_KEY`).
- Setup: `pip install -r requirements.txt`, copy `.env.example` to `.env` with a key from https://app.tavily.com
- Test: `python -m pytest test_tavily_helper.py -v`
