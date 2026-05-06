import os


def api_base_url() -> str:
    return os.getenv("LIMEX_API_BASE_URL", "https://api.getlimex.com").rstrip("/")


def api_key() -> str | None:
    return os.getenv("LIMEX_API_KEY")
