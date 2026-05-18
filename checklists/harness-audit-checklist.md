# Harness Audit Checklist

## Instructions

- [ ] `AGENTS.md` exists.
- [ ] Startup workflow is explicit.
- [ ] Task routing or task selection is explicit.
- [ ] Detailed rules are linked instead of embedded in one giant file.

## State

- [ ] Feature state is tracked.
- [ ] There is at most one active feature.
- [ ] Passing features include evidence.
- [ ] Progress or session log exists.
- [ ] Handoff file exists for long-running work.

## Verification

- [ ] Build command is real and executable.
- [ ] Test command is real and executable.
- [ ] Quality or lint command is recorded when applicable.
- [ ] Substitute verification is documented for missing external dependencies.

## Scope

- [ ] Definition of Done is written.
- [ ] Out-of-scope work is explicitly constrained.
- [ ] Blockers are recorded instead of hidden.

## Lifecycle

- [ ] There is a standard startup check.
- [ ] There is an end-of-session clean-state checklist.
- [ ] New sessions can continue without relying on chat history.

## Result

Score each subsystem 1-5:

| Subsystem | Score | Bottleneck |
| --- | --- | --- |
| Instructions |  |  |
| State |  |  |
| Verification |  |  |
| Scope |  |  |
| Lifecycle |  |  |

