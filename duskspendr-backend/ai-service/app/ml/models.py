"""ML model management."""
from typing import Any

from app.core.logging import get_logger
from app.ml.categorizer import get_categorizer

logger = get_logger(__name__)

# Model registry
_models: dict[str, Any] = {}


async def load_models() -> None:
    """Load all ML models on startup."""
    logger.info("loading_ml_models")
    
    # Load categorizer
    categorizer = await get_categorizer()
    _models["categorizer"] = categorizer
    
    logger.info("ml_models_loaded", count=len(_models))


async def unload_models() -> None:
    """Unload models on shutdown."""
    logger.info("unloading_ml_models")
    _models.clear()


async def get_model_status() -> dict[str, dict[str, Any]]:
    """Get status of all models."""
    return {
        "categorizer": {
            "loaded": "categorizer" in _models,
            "type": "transaction_categorization",
            "version": "1.0.0",
        },
        "anomaly_detector": {
            "loaded": "anomaly_detector" in _models,
            "type": "anomaly_detection",
            "version": "1.0.0",
        },
        "forecaster": {
            "loaded": "forecaster" in _models,
            "type": "time_series_forecasting",
            "version": "1.0.0",
        },
    }
