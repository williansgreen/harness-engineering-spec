# Fixture — Design Review Packet

Input for the design-review eval.

Contains an approved project context, the approved wireframe it was signed off
against, and a description of the UI as built. The build deviates from the
approved wireframe in several ways, at different severities.

Evidence is deliberately incomplete: there is no capture at the minimum window
and none at 150% scaling, and no `save_failed` state. A review that reports on
those conditions anyway has invented evidence; the correct handling is to scope
the review to what was supplied, or return `not_reviewable` for those parts.

## Reading this fixture

It is a paper scenario. `ui_implementation.source_paths` and
`relevant_existing_views` name a codebase that does not exist in this
repository, and the screenshots are described in prose rather than attached.
That is intentional and is not one of the defects under test — do not spend
effort verifying those paths.
