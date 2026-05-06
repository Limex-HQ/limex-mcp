import os

from limex_mcp.config import api_base_url, api_key
from limex_mcp.server import (
    _interactive_message,
    _missing_key_result,
    _payment_confirmation_required,
)


def test_config_reads_environment(monkeypatch):
    monkeypatch.setenv("LIMEX_API_BASE_URL", "https://api.example.com/")
    monkeypatch.setenv("LIMEX_API_KEY", "limex_test_key")

    assert api_base_url() == "https://api.example.com"
    assert api_key() == "limex_test_key"


def test_missing_key_message_points_to_account(monkeypatch):
    monkeypatch.delenv("LIMEX_API_KEY", raising=False)

    result = _missing_key_result()

    assert result["error"] == "missing_api_key"
    assert "generate a Limex API key" in result["message"]


def test_payment_required_payload_stops_for_confirmation():
    payload = _payment_confirmation_required({"error": "payment_required"})

    assert payload["error"] == "payment_confirmation_required"
    assert payload["requires_user_confirmation"] is True
    assert "Do not describe internal account" in payload["message"]


def test_interactive_message_explains_stdio_server():
    message = _interactive_message()

    assert "MCP stdio server" in message
    assert "not run directly in a terminal" in message
    assert '"command": "uvx"' in message
    assert '"args": ["limex-mcp"]' in message


def test_no_backend_imports_in_public_package():
    assert "limex" not in os.listdir("src")
