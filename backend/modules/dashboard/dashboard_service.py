from shared.enums import PriorityLevel
from modules.dashboard import dashboard_repository
from modules.user.user_schemas import UserDTO
from sqlalchemy.orm import Session
from datetime import datetime


async def get_events_by_priority(session: Session, current_user: UserDTO) -> dict:
    returned_dictionary = await dashboard_repository.count_events_priority(session, current_user.id)
    mapped_dictionary = {
        PriorityLevel(int(key)).name: value for key, value in returned_dictionary.items()
    }
    return mapped_dictionary

async def get_events_by_category(session: Session, current_user: UserDTO) -> dict:
    returned_dictionary = await dashboard_repository.get_events_by_category(session, current_user.id)
    return returned_dictionary


async def get_events_heatmap(session: Session, current_user: UserDTO) -> dict:
    returned_dictionary = await dashboard_repository.get_events_heatmap(session, current_user.id)
    return returned_dictionary


async def get_notification_priority_distribution(session: Session, current_user: UserDTO) -> dict:
    returned_dictionary = await dashboard_repository.get_notification_priority_distribution(session, current_user.id)

    return returned_dictionary

async def get_top_hosts(session: Session, current_user: UserDTO) -> dict:
    returned_dictionary = await dashboard_repository.get_top_hosts(session, current_user.id)
    return returned_dictionary

async def get_recent_events(session: Session, current_user: UserDTO) -> dict:
    returned_dictionary = await dashboard_repository.get_recent_events(session, current_user.id)
    return returned_dictionary


async def get_number_of_events_by_month(session: Session, current_user: UserDTO) -> list[dict]:
    # Fetch the original data
    events_by_month = await dashboard_repository.get_number_of_events_by_month(session, current_user.id)
    
    # Mapping month numbers to short names
    month_short_names = {
        1: "JAN", 2: "FEB", 3: "MAR", 4: "APR",
        5: "MAY", 6: "JUN", 7: "JUL", 8: "AUG",
        9: "SEP", 10: "OCT", 11: "NOV", 12: "DEC"
    }

    # Process and cast data to the desired format
    formatted_data = []
    for event in events_by_month:
        # Extract month number from the `event_month` field
        month_number = datetime.strptime(event["event_month"], "%Y-%m").month
        # Map month number to short name
        month_short_name = month_short_names[month_number]
        # Add to the result
        formatted_data.append({month_short_name: event["event_count"]})
    print(formatted_data)
    return formatted_data
