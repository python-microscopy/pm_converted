
# similar to htsms-two-color protocol, but camera is restarted on each z step, the focus lock is not re-enabled
# afterwards (since it may never have been set up) and analysis is not automatically launched.

from PYME.Acquire.protocol import *

# T(when, what, *args) creates a new task. "when" is the frame number, "what" is a function to
# be called, and *args are any additional arguments.
taskList = [
    T(-1, scope.l642.TurnOn),
    T(-1, scope.l560.TurnOn),
    T(0, scope.focus_lock.DisableLock),
    T(maxint, scope.turnAllLasersOff),
    # T(maxint, scope.focus_lock.EnableLock),
    # T(maxint, scope.spoolController.LaunchAnalysis)
]

metaData = [
    ('Protocol.DataStartsAt', 0),
]

preflight = []  # no preflight checks

# must be defined for protocol to be discovered
PROTOCOL = TaskListProtocol(taskList, metaData, preflight)
PROTOCOL_STACK = ZStackTaskListProtocol(taskList, 1, 3, metaData, preflight, slice_order='triangle',
                                        require_camera_restart=True)
