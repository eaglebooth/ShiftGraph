# Release evidence

Current status: **LOCAL V2 CONTRACT VERIFICATION PASSED**

| Gate | Evidence | Status |
|---|---|---|
| Production contract | `contracts/shift_graph.py` loaded and executed by `gltest` | PASS |
| Behavioral tests | `python -m pytest -q -p no:cacheprovider` — 14 passed in 1.20s on 2026-09-27 | PASS |
| Studio schema | Live `genlayer schema` readback exposes the v2 capability and recovery methods | PASS (STUDIONET) |
| Studionet deployment | [`0xbD0263B6A3b0D071Ab10C9999AA951d905946402`](https://explorer-studio.genlayer.com/address/0xbD0263B6A3b0D071Ab10C9999AA951d905946402) | PASS |
| Live lifecycle | [Finalized multi-wallet happy path and rejection controls](LIVE_STUDIONET_EVIDENCE.md) | PASS |

The local suite covers authenticated handoff submission, leader proposal plus independent validator falsification, prompt injection, fail-closed malformed graphs, dependency gating, assigned-worker claims, low/medium completion, high-risk independent review, rejection and rework, nonce replay rejection, submitted-task recovery, reviewer rotation, cancellation, exact restart-capability binding, one-time consumption, reviewer/worker separation, and premature authorization rejection.

This file records test results; it is not an authority source for contract decisions. Runtime authority comes from transaction senders, sealed on-chain roles, the compiled graph, and contract state transitions.

Runtime: Python 3.12.10, `genlayer-py` 0.16.3, `genlayer-test` 0.29.2, contract runner header v0.2.16. The local runner warned that `gltest.config.yaml` is absent and therefore used its default localnet configuration. No Studionet write-lifecycle consensus or transaction finality is claimed here.

Studionet readback on 2026-09-27 returned `{"name":"ShiftGraph","schema":"semantic-handoff-capability-v2","version":2}` and initial stats `{"closed":0,"compiled":0,"shifts":0}`. This proves deployed schema/version identity and clean initial state only; it does not prove the multi-wallet lifecycle.

The finalized lifecycle later produced terminal readback `CLOSED / CONSUMED / 4 of 4 DONE` and aggregate stats `{"closed":1,"compiled":1,"shifts":1}`. Negative controls finalized with explicit errors for unauthorized task claim, wrong capability consumer and terminal replay. Revision 1 also demonstrated safe `COMPILE_FAILED` recovery before revision 2 succeeded.

