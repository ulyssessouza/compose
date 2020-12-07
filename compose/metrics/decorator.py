import functools
from docker import ContextAPI


from compose.metrics.client import MetricsCommand, Status, MetricsSource


class metrics:
    def __init__(self, command_name=None):
        self.command_name = command_name

    def __call__(self, fn):
        @functools.wraps(fn,
                         assigned=functools.WRAPPER_ASSIGNMENTS,
                         updated=functools.WRAPPER_UPDATES)
        def wrapper(*args, **kwargs):
            if not self.command_name:
                self.command_name = fn.__name__
            status = Status.SUCCESS
            result = None
            try:
                result = fn(*args, **kwargs)
            except:
                status = Status.FAILURE

            context = ContextAPI.get_context()
            MetricsCommand(self.command_name,
                           context,
                           MetricsSource.CLI,
                           "status").send()
            return result

        return wrapper
