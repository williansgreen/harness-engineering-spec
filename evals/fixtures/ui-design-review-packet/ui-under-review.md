# UI Under Review — Build 0.9.4

Evidence supplied with this packet:

- Screenshot A: `running` state, 1920x1080, 100% scaling, zh-CN, build 0.9.4.
- Screenshot B: `faulted` state, 1920x1080, 100% scaling, zh-CN, build 0.9.4.
- No screenshot at 1366x768.
- No screenshot at 150% scaling.
- No `save_failed` state capture.

## Screenshot A — running (described)

- Header shows run identity, elapsed time, and target duration.
- Alarm strip is present. Current severity is shown **only** as a colored band: green / amber / red, with the alarm text beside it. No icon, no severity word.
- Trend workspace occupies the largest region. Live curve renders.
- Key values row shows six values with units. No timestamp, no freshness indicator; a value that stopped updating looks identical to a live one.
- Parameter inspector lists 14 parameters. All are editable, including `Pump rate` and `Cell temperature`, which the context marks dangerous while running.
- Status bar shows workflow state and a Stop button.
- Persistence state is not shown anywhere on this screen.

## Screenshot B — faulted (described)

- Alarm strip turns red with the text `设备故障`.
- The trend workspace is replaced by a full-region modal panel reading `设备故障，请联系维护人员`.
- The modal covers the status bar. **The Stop button is not reachable while the modal is displayed.**
- The panel does not state whether the run's data was written, nor what the operator should do next.

## Additional note from the implementer

- At 1366x768 the parameter inspector was given a fixed width of 380 px with no scrolling; the team has not captured a screenshot at that size.
