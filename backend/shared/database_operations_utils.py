from datetime import datetime

from modules.notifications.notifications_schemas import NotificationData
from shared.enums import PriorityLevel


def format_SQL_statement(data: list, ip_dict: dict, time_occured) -> str:
    start = "INSERT INTO Event\n(uuid, status, host, port, priority, category_name, creation_date, last_occurrence, asset_id, updated_at)\nVALUES\n"
    statement = ""
    end = "AS new_values \n ON DUPLICATE KEY UPDATE \n uuid = new_values.uuid,\nstatus = new_values.status,\nlast_occurrence = new_values.last_occurrence, \n updated_at=new_values.updated_at;"
    for idx, l in enumerate(data):
        timestamp = l.get('@timestamp')
        received_timestamp = datetime.strptime(timestamp, "%Y-%m-%dT%H:%M:%S.%fZ")
        parsed_timestamp = received_timestamp.strftime("%Y-%m-%d %H:%M:%S.%f")
        event_uuid = l.get('event_uuid')
        ip = l.get('ip')
        port = l.get('port')
        category_name = l.get('category_name')
        urgency = l.get('urgency')
        priority_level = PriorityLevel[urgency].value
        updated_at=datetime.now().strftime("%Y-%m-%d")
        line = f'("{event_uuid}",0,"{ip}","{port}",{priority_level},"{category_name}","{time_occured}","{parsed_timestamp}","{ip_dict[ip]}","{updated_at}")'
        if idx < len(data) - 1:
            line += "," 
        statement += (f'{line}\n')

    return start + statement + end


def format_sql_for_single_asset(data: list, asset_id, time_occured) -> str:
    start = "INSERT INTO Event\n(uuid, status, host, port, priority, category_name, creation_date, last_occurrence, asset_id, updated_at)\nVALUES\n"
    statement = ""
    end = "AS new_values \n ON DUPLICATE KEY UPDATE \n uuid = new_values.uuid,\nstatus = new_values.status,\nlast_occurrence = new_values.last_occurrence, \n updated_at=new_values.updated_at;"
    for idx, l in enumerate(data):
        timestamp = l.get('@timestamp')
        received_timestamp = datetime.strptime(timestamp, "%Y-%m-%dT%H:%M:%S.%fZ")
        parsed_timestamp = received_timestamp.strftime("%Y-%m-%d %H:%M:%S.%f")
        event_uuid = l.get('event_uuid')
        ip = l.get('ip')
        port = l.get('port')
        category_name = l.get('category_name')
        urgency = l.get('urgency')
        priority_level = PriorityLevel[urgency].value
        updated_at=datetime.now().strftime("%Y-%m-%d")
        line = f'("{event_uuid}",0,"{ip}","{port}",{priority_level},"{category_name}","{time_occured}","{parsed_timestamp}","{asset_id}","{updated_at}")'
        if idx < len(data) - 1:
            line += "," 
        statement += (f'{line}\n')

    return start + statement + end

def format_sql_for_notifications(data: list[NotificationData]) -> str:
    creation_datetime = datetime.now()
    start = "INSERT INTO Notification\n(user_id, asset_id, asset_ip, seen, description, creation_date)\nVALUES\n"
    statement = ""
    end = "AS new_values \n ON DUPLICATE KEY UPDATE \n user_id = new_values.user_id,\n asset_id = new_values.asset_id,\n asset_ip = new_values.asset_ip,\n seen = FALSE,\n description = new_values.description,\n creation_date = new_values.creation_date;"
    for idx, datum in enumerate(data):
        line = f'("{datum.user_id}", "{datum.asset_id}", "{datum.asset_ip}", FALSE, "{datum.asset_ip} has {datum.event_count} discovered events", "{creation_datetime}")'
        if idx < len(data) - 1:
            line += "," 
        statement += (f'{line}\n')
    return start + statement + end
