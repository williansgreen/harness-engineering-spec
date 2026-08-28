# Approved Wireframe — Continuous Acquisition Screen

Revision: `wireframe-r3`
Gate 1 result: approved (see `project-context.yaml` → `approvals.wireframe`)

## Region map (default window 1920x1080)

```text
+--------------------------------------------------------------------+
| Header: run identity | device state | connection | elapsed / target |
+-------------------+------------------------------------------------+
| Alarm strip: severity + text + acknowledge + details                |
+-------------------+------------------------------------------------+
|                   |                                                |
| Parameter         | Trend workspace (primary space)                 |
| inspector         |   - live curve                                  |
|   - grouped by    |   - value + unit + freshness                    |
|     effect        |   - scale / reset view                          |
|   - scrollable    |                                                 |
|   - dangerous     +------------------------------------------------+
|     params        | Key values row: value | unit | freshness | state |
|     read-only     +------------------------------------------------+
|     while running |                                                |
+-------------------+------------------------------------------------+
| Status bar: workflow state | data state | persistence state | Stop  |
+--------------------------------------------------------------------+
```

## Approved behaviour (excerpt)

- Stop remains reachable in every state where a run is active, including `faulted`.
- Alarm severity is conveyed by text and icon, not by color alone.
- Every displayed measurement carries value, unit, and freshness; `stale` is visually and textually distinct from `live`.
- Parameter inspector scrolls at the minimum window; dangerous parameters become read-only while running.
- Persistence state is visible at all times; `save_failed` states what was affected and the next action.
- At 1366x768 the trend workspace and Stop remain usable; the parameter inspector may collapse.

## Minimum-window intent

```text
+------------------------------------------+
| Header (compact)                         |
+------------------------------------------+
| Alarm strip                              |
+------------------------------------------+
| Trend workspace                          |
+------------------------------------------+
| Key values (scrollable)                  |
+------------------------------------------+
| Status bar | Stop                        |
+------------------------------------------+
```
