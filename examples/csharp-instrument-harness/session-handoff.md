# Session Handoff

## Verified

- Known working behavior: Harness files exist for the planned C# instrument project.
- Commands actually run: Run harness audit before implementation.
- Evidence: features are not started yet.

## Changed This Session

- Code or behavior: none.
- Harness or documentation: Added formal C# project harness example.

## Broken Or Unverified

- Known defects: no C# solution exists yet.
- Unverified paths: build, test, and run commands are future commands.
- Risks for the next session: do not mark features passing until the `.sln` exists and verification runs.

## Next Best Action

- Highest-priority unfinished feature: `arch-001`
- Why this is next: solution structure is the base for every later feature.
- What counts as passing: solution exists and `dotnet build` plus `dotnet test` pass.
- Files or areas not to touch: do not integrate real vendor SDK before simulated device abstraction exists.

## Commands

- Build: see `harness/build.md`
- Run: see `harness/run.md`
- Test: see `harness/test.md`
- Targeted debug: see `harness/quality.md`

