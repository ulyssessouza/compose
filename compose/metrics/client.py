import json
from time import sleep
from types import coroutine

import requests

from enum import Enum


class Status(Enum):
    SUCCESS = "success"
    FAILURE = "failure"
    CANCELED = "canceled"


class MetricsSource:
    CLI = "docker-compose"


class MetricsCommand:
    """
    Representation of a command in the metrics.
    """

    def __init__(self, command, context_type, status, source=MetricsSource.CLI, url="http://localhost/usage"):
        self.command = "compose " + command
        self.context = context_type
        self.status = status
        self.source = source
        self.url = url

    def send(self):
        metrics = post_metrics()
        next(metrics)
        try:
            metrics.send(self)
            metrics.close()
        except Exception:
            pass

    def to_map(self):
        return {
            'command': self.command,
            'context': self.context,
            'status': self.status,
            'source': self.source,
        }


@coroutine
def post_metrics():
    command = (yield)
    try:
        print(command.to_map())
        requests.post(command.url, json=command.to_map(), timeout=.05)
    except Exception:
        pass
