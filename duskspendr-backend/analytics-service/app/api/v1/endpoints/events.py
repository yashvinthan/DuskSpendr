"""Event tracking endpoints for analytics."""
from datetime import datetime
from typing import Any
from uuid import uuid4

import structlog
from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, Field

logger = structlog.get_logger()
router = APIRouter()


class EventCreate(BaseModel):
    """Event creation request."""
    event_type: str = Field(..., description="Event type identifier")
    user_id: str | None = Field(None, description="User ID if authenticated")
    properties: dict[str, Any] = Field(default_factory=dict, description="Event properties")
    timestamp: datetime | None = Field(None, description="Event timestamp")
    session_id: str | None = Field(None, description="Session identifier")
    device_info: dict[str, Any] | None = Field(None, description="Device information")


class EventResponse(BaseModel):
    """Event creation response."""
    id: str
    event_type: str
    received_at: datetime
    status: str = "accepted"


class BatchEventCreate(BaseModel):
    """Batch event creation request."""
    events: list[EventCreate] = Field(..., min_length=1, max_length=100)


class BatchEventResponse(BaseModel):
    """Batch event creation response."""
    accepted: int
    rejected: int
    event_ids: list[str]


# In-memory storage for demo (replace with database)
events_store: list[dict[str, Any]] = []
type_counts: dict[str, int] = {}


@router.post("", response_model=EventResponse, status_code=status.HTTP_201_CREATED)
async def track_event(event: EventCreate) -> EventResponse:
    """
    Track a single analytics event.

    Events are processed asynchronously after being accepted.
    """
    event_id = str(uuid4())
    received_at = datetime.utcnow()

    event_data = {
        "id": event_id,
        "event_type": event.event_type,
        "user_id": event.user_id,
        "properties": event.properties,
        "timestamp": event.timestamp or received_at,
        "received_at": received_at,
        "session_id": event.session_id,
        "device_info": event.device_info,
    }

    events_store.append(event_data)
    type_counts[event.event_type] = type_counts.get(event.event_type, 0) + 1

    logger.info(
        "Event tracked",
        event_id=event_id,
        event_type=event.event_type,
        user_id=event.user_id,
    )

    return EventResponse(
        id=event_id,
        event_type=event.event_type,
        received_at=received_at,
    )


@router.post("/batch", response_model=BatchEventResponse, status_code=status.HTTP_201_CREATED)
async def track_events_batch(batch: BatchEventCreate) -> BatchEventResponse:
    """
    Track multiple analytics events in a single request.

    Maximum 100 events per batch.
    """
    accepted = 0
    rejected = 0
    event_ids: list[str] = []
    received_at = datetime.utcnow()

    for event in batch.events:
        try:
            event_id = str(uuid4())
            event_data = {
                "id": event_id,
                "event_type": event.event_type,
                "user_id": event.user_id,
                "properties": event.properties,
                "timestamp": event.timestamp or received_at,
                "received_at": received_at,
                "session_id": event.session_id,
                "device_info": event.device_info,
            }
            events_store.append(event_data)
            type_counts[event.event_type] = type_counts.get(event.event_type, 0) + 1
            event_ids.append(event_id)
            accepted += 1
        except Exception as e:
            logger.warning("Event rejected", error=str(e))
            rejected += 1

    logger.info("Batch events tracked", accepted=accepted, rejected=rejected)

    return BatchEventResponse(
        accepted=accepted,
        rejected=rejected,
        event_ids=event_ids,
    )


@router.get("/types")
async def get_event_types() -> dict[str, Any]:
    """Get all tracked event types with counts."""
    return {
        "event_types": [
            {"name": name, "count": count}
            for name, count in sorted(type_counts.items(), key=lambda x: -x[1])
        ]
    }


@router.get("/{event_id}")
async def get_event(event_id: str) -> dict[str, Any]:
    """Get a specific event by ID."""
    for event in events_store:
        if event.get("id") == event_id:
            return event

    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"Event {event_id} not found",
    )
