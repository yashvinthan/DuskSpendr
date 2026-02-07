
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_predict_cash_flow():
    response = client.post("/api/v1/ai/predict/cash-flow", params={"user_id": "test_user", "months_ahead": 3})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "predictions" in data["data"]
    assert len(data["data"]["predictions"]) == 3
    assert "summary" in data["data"]
    summary = data["data"]["summary"]
    assert "average_monthly_balance" in summary
    assert "total_predicted_savings" in summary
    assert "risk_months" in summary

def test_predict_cash_flow_large():
    # Test with max months allowed
    response = client.post("/api/v1/ai/predict/cash-flow", params={"user_id": "test_user", "months_ahead": 12})
    assert response.status_code == 200
    data = response.json()
    assert len(data["data"]["predictions"]) == 12
