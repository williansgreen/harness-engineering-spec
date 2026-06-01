# UI Acceptance

Use this file for project-specific UI visual and interaction acceptance.

## Target Displays

| Target | Resolution | Windows Scale | DPI Policy | Font | Notes |
| --- | --- | --- | --- | --- | --- |
| primary | | | | | |
| fallback | | | | | |

## Required Screens

| Screen Or Form | Required State | Acceptance Criteria | Evidence |
| --- | --- | --- | --- |
| main screen | startup | no clipped text, overlaps, or hidden primary actions | |
| status or fault state | faulted | clear status, action, and log detail path | |
| settings or maintenance | connected and disconnected | controls remain reachable and readable | |

## Checks

- Text does not clip inside buttons, labels, grids, tabs, or status bars.
- Controls do not overlap at target size and scale.
- Critical actions remain visible or reachable through documented scroll.
- Status, warning, and fault information are not color-only.
- Designer-visible WinForms layouts still open in Visual Studio when applicable.
- Runtime visual checks use the same DPI awareness policy as production.

## Evidence

- Screenshot or render artifact path:
- Build or package tested:
- Manual tester:
- Unverified display targets:
