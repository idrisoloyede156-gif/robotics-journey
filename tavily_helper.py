"""Tavily web-search helper for robotics-journey.

Uses TAVILY_API_KEY from environment (or .env) via TavilyClient.
Supports robotics learning builds: current docs, parts, ROS 2 references.
"""

import os

from dotenv import load_dotenv

load_dotenv()


def get_client():
    """Create TavilyClient using TAVILY_API_KEY env var.

    Raises:
        RuntimeError: if TAVILY_API_KEY is missing.
    """
    from tavily import TavilyClient

    api_key = os.getenv("TAVILY_API_KEY")
    if not api_key or api_key == "tvly-YOUR_KEY":
        raise RuntimeError(
            "TAVILY_API_KEY is missing. Copy .env.example to .env "
            "and set a key from https://app.tavily.com"
        )
    return TavilyClient(api_key=api_key)


def robotics_search(query, max_results=5, search_depth="advanced"):
    """Search the web for robotics topics. Returns Tavily search response."""
    client = get_client()
    return client.search(
        query=query,
        max_results=max_results,
        search_depth=search_depth,
    )


def robotics_extract(urls, query=None):
    """Extract clean content from robotics docs/pages. urls: list of up to 20."""
    client = get_client()
    kwargs = {"urls": urls}
    if query:
        kwargs.update({"query": query, "chunks_per_source": 3})
    return client.extract(**kwargs)


if __name__ == "__main__":
    import json

    try:
        resp = robotics_search("ROS 2 Humble diff-drive Gazebo Nav2 tutorial", max_results=5)
        print(json.dumps(resp, indent=2)[:3000])
    except RuntimeError as e:
        print(e)
