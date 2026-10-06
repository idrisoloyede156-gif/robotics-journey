# robotics-journey
My robotics journey

## Tavily web research
- `tavily_helper.py` — `robotics_search()` / `robotics_extract()` via `tavily-python` (needs `TAVILY_API_KEY`).
- Setup: `pip install -r requirements.txt`, copy `.env.example` to `.env` with a key from https://app.tavily.com (OAuth alone is not enough for the SDK).
- Test: `python -m pytest test_tavily_helper.py -v`
- First report: `docs_THESIS_RESEARCH.md` — low-cost connected mobile robot with secure telemetry (Tavily Research, 11 sources).
