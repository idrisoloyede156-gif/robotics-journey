"""Smoke tests for tavily_helper. Live tests skip without TAVILY_API_KEY."""

import os


def test_imports():
    import tavily_helper

    assert hasattr(tavily_helper, "robotics_search")
    assert hasattr(tavily_helper, "robotics_extract")


def test_missing_key_raises_or_live_search():
    import tavily_helper

    key = os.getenv("TAVILY_API_KEY")
    if not key or key == "tvly-YOUR_KEY":
        try:
            tavily_helper.robotics_search("test", max_results=1)
        except RuntimeError as e:
            assert "TAVILY_API_KEY" in str(e)
            return
        raise AssertionError("expected RuntimeError without API key")
    else:
        resp = tavily_helper.robotics_search("ESP32 ultrasonic sensor tutorial", max_results=2)
        assert "results" in resp
