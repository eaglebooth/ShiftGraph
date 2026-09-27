# ShiftGraph protocol specification

## Proof obligation

Compile an authenticated maintenance handoff into a bounded dependency graph without inventing equipment, thresholds or work, then enforce that graph as the only path to a bound, single-use restart capability.

## Authority separation

- Shift lead has instruction authority.
- Leader validators propose a semantic compilation; independent validators falsify coverage, invention, dependency safety and restoration safety.
- Supervisor owns roster, recovery and capability issuance.
- Assigned workers attest task completion.
- A distinct safety reviewer countersigns high-risk tasks.
- Contract has exclusive execution authority over task transitions and restart-capability consumption.

## AI boundary

Validators select task boundaries, normalized action/role/criticality, and dependencies. They cannot select wallet addresses, mark work complete, approve high-risk work, issue a capability or close a shift. Every proposed `COMPILED` graph is independently checked against the authenticated handoff before deterministic structural validation.

## Deterministic invariants

- Maximum eight sequential tasks.
- Dependencies reference earlier tasks only.
- Every role exists in the sealed roster.
- Final task is `RESTORE`, is `HIGH`, and has dependencies.
- Blocked tasks cannot be claimed.
- High-risk completion requires an independent reviewer.
- Completion nonces cannot be replayed.
- Restart authorization cannot be issued until every graph node is done.
- Capability binds shift, handoff revision, graph digest, restore target, executor, payload digest and nonce.
- Capability consumption is single-use and atomically closes the shift.
- A submitted task can be recovered and the safety reviewer can be rotated by the supervisor.

## Honest limitation

ShiftGraph proves workflow authorization, recorded attestations and consumption of an exact on-chain restart capability. It does not prove that physical maintenance actually occurred or directly operate machinery. A real adapter should require this capability in addition to authenticated device or inspection controls.

