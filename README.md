# ShiftGraph

Studionet contract: [`0xbD0263B6A3b0D071Ab10C9999AA951d905946402`](https://explorer-studio.genlayer.com/address/0xbD0263B6A3b0D071Ab10C9999AA951d905946402) (chain ID 61997).

Live proof: [finalized multi-wallet Studionet lifecycle](docs/LIVE_STUDIONET_EVIDENCE.md).

ShiftGraph is a contract-only GenLayer Intelligent Contract that compiles an authenticated maintenance shift handoff into an immutable task dependency graph, enforces its execution order, and gates a single-use restart capability on-chain.

This is an AI compiler plus deterministic workflow engine—not a claim registry, evidence comparison, challenge court, remediation pipeline or one-time evidence permit.

## Why GenLayer

Maintenance handoffs express task boundaries, ordering and safety prerequisites in natural language. A leader proposes a bounded graph; validators independently try to falsify its coverage, non-invention, dependency safety and restoration safety. The contract validates graph structure and retains exclusive authority over roles, dependencies, countersignatures, recovery, capability binding, replay protection and closure.

## Workflow

```text
Supervisor creates shift and roster
  -> lead submits handoff
  -> validators compile bounded DAG
  -> workers claim READY tasks
  -> completion unlocks successors
  -> HIGH tasks require independent safety review
  -> supervisor issues an exact restart capability only after every task is DONE
  -> bound executor consumes it once
  -> contract closes the shift
```

## Contract methods

- `create_shift`
- `assign_role`
- `submit_handoff`
- `compile_handoff`
- `claim_task`
- `submit_completion`
- `review_high_risk`
- `reassign_task`
- `rotate_safety_reviewer`
- `issue_restart_authorization`
- `consume_restart_authorization`
- `cancel_shift`
- `get_shift`
- `get_task`
- `get_graph`
- `get_stats`
- `get_contract_version`

## Test

```bash
python -m pytest -q -p no:cacheprovider
```

The tests execute the production contract source with `gltest`. They cover validator falsification, prompt injection, malformed graphs, dependencies, role enforcement, safety review, rejection/rework, nonce replay, recovery, reviewer rotation, cancellation, exact capability binding and single-use consumption.

## Deploy

The v2 contract is deployed on Studionet with no constructor arguments. No frontend is required. The included handoff is a synthetic test fixture, not a real maintenance instruction.

## Authority and claim boundary

Each supervisor is the root authority only inside the shift namespace created by that sender. The supervisor appoints the lead, reviewer and workers; the contract does not prove those wallets hold an off-chain employment or safety credential. The authenticated lead is authoritative for the instruction, workers attest completion, and the reviewer countersigns high-risk attestations. These statements are not objective proof that physical work occurred. A production machinery adapter must require the exact single-use restart capability in addition to its device-level controls.

