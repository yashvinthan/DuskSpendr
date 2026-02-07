from datetime import datetime
from fastapi.testclient import TestClient

def test_get_time_series_deterministic(client: TestClient):
    """
    Test that get_time_series returns deterministic output for the same inputs.
    """
    metric_name = "active_users"
    start_date = datetime(2023, 1, 1)
    end_date = datetime(2023, 1, 10)

    response = client.get(
        f"/api/v1/metrics/time-series/{metric_name}",
        params={
            "start_date": start_date.isoformat(),
            "end_date": end_date.isoformat(),
            "granularity": "day"
        }
    )

    assert response.status_code == 200
    data = response.json()
    assert data["name"] == metric_name
    # 2023-01-01 to 2023-01-10 inclusive is 10 days
    assert len(data["values"]) == 10

    # Check specific values (since random seed is fixed)
    # Based on random.seed(42), the first value should be consistent
    first_value = data["values"][0]["value"]
    assert isinstance(first_value, float)

    # Verify the second call returns the same values
    response2 = client.get(
        f"/api/v1/metrics/time-series/{metric_name}",
        params={
            "start_date": start_date.isoformat(),
            "end_date": end_date.isoformat(),
            "granularity": "day"
        }
    )
    assert response2.json() == data

def test_get_time_series_granularity(client: TestClient):
    """Test different granularities."""
    metric_name = "transactions"
    start_date = datetime(2023, 1, 1)
    end_date = datetime(2023, 1, 2)

    # Hour granularity
    response = client.get(
        f"/api/v1/metrics/time-series/{metric_name}",
        params={
            "start_date": start_date.isoformat(),
            "end_date": end_date.isoformat(),
            "granularity": "hour"
        }
    )
    assert response.status_code == 200
    data = response.json()
    # 24 hours + 1 for end date match (if <=)
    # start: 2023-01-01 00:00:00
    # end: 2023-01-02 00:00:00
    # 00, 01, ..., 23, 00 (next day) -> 25 points
    assert len(data["values"]) == 25

def test_get_time_series_unknown_metric(client: TestClient):
    """Test with unknown metric name."""
    metric_name = "unknown_metric"
    start_date = datetime(2023, 1, 1)
    end_date = datetime(2023, 1, 5)

    response = client.get(
        f"/api/v1/metrics/time-series/{metric_name}",
        params={
            "start_date": start_date.isoformat(),
            "end_date": end_date.isoformat(),
            "granularity": "day"
        }
    )
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == metric_name
    # Should use base value 100
    # values should be around 100
    for v in data["values"]:
        assert 80 <= v["value"] <= 130 # 100 +/- 20% to 30%

def test_get_time_series_default_dates(client: TestClient):
    """Test default date handling."""
    metric_name = "signups"
    response = client.get(f"/api/v1/metrics/time-series/{metric_name}")
    assert response.status_code == 200
    data = response.json()
    assert len(data["values"]) > 0
    # Default is last 30 days. start = end - 30 days.
    # If end is inclusive, it might be 30 or 31 points depending on exact time math if not stripped of time
    # But since it's mock data generated with current += delta, it should be robust.
    assert 28 <= len(data["values"]) <= 32

def test_get_time_series_invalid_range(client: TestClient):
    """Test where start_date > end_date."""
    metric_name = "active_users"
    start_date = datetime(2023, 1, 10)
    end_date = datetime(2023, 1, 1)

    response = client.get(
        f"/api/v1/metrics/time-series/{metric_name}",
        params={
            "start_date": start_date.isoformat(),
            "end_date": end_date.isoformat(),
            "granularity": "day"
        }
    )
    assert response.status_code == 200
    data = response.json()
    assert len(data["values"]) == 0
    assert data["total"] == 0
    assert data["average"] == 0
