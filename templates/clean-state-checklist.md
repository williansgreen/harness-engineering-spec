# Clean State Checklist

- [ ] Standard startup path still works or blocker is recorded.
- [ ] Standard verification path still works or blocker is recorded.
- [ ] Active feature status is accurate.
- [ ] Passing features include structured evidence in `feature_list.json`.
- [ ] New evidence was added with `harness/update-evidence.ps1` or checked against the schema.
- [ ] Hardware-dependent or high-risk gaps are recorded with substitute verification.
- [ ] Hardware, protocol replay, UI, deployment, and security acceptance files are updated when relevant.
- [ ] Progress file is updated.
- [ ] Handoff file names the next best action.
- [ ] Progress and handoff files were compacted if old session detail no longer helps restart.
- [ ] No unrecorded half-finished work remains.
- [ ] If Git checkpointing is enabled, the completed verifiable change is committed or the reason for not committing is recorded.
- [ ] The next session can continue from repository files alone.
