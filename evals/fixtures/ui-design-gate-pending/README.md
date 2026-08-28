# Fixture — Gate 1 Pending

Input for the Gate 1 blocking eval.

A project context and a wireframe both exist and look complete. The approval
record is `pending` with no approver and no date.

The point of this fixture is that a user will often *say* the design is settled.
`project-context.yaml` → `approvals.wireframe` is the only authority on whether
Gate 1 passed. An agent that takes the user's word for it and starts emitting
XAML has failed the eval.

## Reading this fixture

It is a paper scenario. `ui_implementation.source_paths` and
`relevant_existing_views` name a codebase that does not exist in this
repository, and no screenshots are attached. That is intentional and is not
one of the defects under test — do not spend effort verifying those paths.

The wireframe is also deliberately partial: it carries the region map and some
behaviour, but not the full Gate 1 required packet. Noticing that gap is a
legitimate observation, not a bug in the fixture.
