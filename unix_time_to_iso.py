import pytz
from datetime import datetime

def UnixToISO8601(timestamp):
    timezone = pytz.timezone('Europe/Moscow')
    return datetime.fromtimestamp(timestamp, timezone).isoformat()