from datetime import datetime

from shared.enums import PriorityLevel


def format_SQL_statement(data: list, ip_dict: dict, time_occured) -> str:
    start = "INSERT INTO Event\n(uuid, status, host, port, priority, category_name, creation_date, last_occurrence, asset_id)\nVALUES\n"
    statement = ""
    end = "AS new_values \n ON DUPLICATE KEY UPDATE \n uuid = new_values.uuid,\nstatus = new_values.status,\nlast_occurrence = new_values.last_occurrence;"
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
        line = f'("{event_uuid}",0,"{ip}","{port}",{priority_level},"{category_name}","{time_occured}","{parsed_timestamp}","{ip_dict[ip]}")'
        if idx < len(data) - 1:
            line += "," 
        statement += (f'{line}\n')

    return start + statement + end


def format_sql_for_single_asset(data: list, asset_id, time_occured) -> str:
    start = "INSERT INTO Event\n(uuid, status, host, port, priority, category_name, creation_date, last_occurrence, asset_id)\nVALUES\n"
    statement = ""
    end = "AS new_values \n ON DUPLICATE KEY UPDATE \n uuid = new_values.uuid,\nstatus = new_values.status,\nlast_occurrence = new_values.last_occurrence;"
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
        line = f'("{event_uuid}",0,"{ip}","{port}",{priority_level},"{category_name}","{time_occured}","{parsed_timestamp}","{asset_id}")'
        if idx < len(data) - 1:
            line += "," 
        statement += (f'{line}\n')

    return start + statement + end