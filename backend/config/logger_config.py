from datetime import datetime, timezone
from loguru import logger
import sys


log_file = f'logs/{datetime.now(timezone.utc).strftime("%d-%m-%Y")}.log'

logger.remove()
logger.add(
    log_file, 
    rotation="10 MB", 
    retention="7 days",
    compression="zip", 
    format="{time:YYYY-MM-DD at HH:mm:ss} | {level} | {message}",  
    level="INFO",
)
logger.add(sys.stdout, level="INFO")
