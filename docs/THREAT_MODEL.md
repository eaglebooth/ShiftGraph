# Threat model

## Protected boundaries

- Handoff authority comes from the registered shift-lead sender, not prose.
- A proposed graph is not accepted merely because it is valid JSON: validators independently falsify semantic coverage, invention, dependency safety and restoration safety.
- Validator output is constrained to a small schema and taxonomy.
- Deterministic validation rejects missing roles, forward/cyclic dependencies, invalid IDs and unsafe RESTORE nodes.
- Workers cannot bypass dependencies or claim another wallet's task.
- Safety reviewer cannot be assigned as a worker and cannot countersign their own completion.
- Reassignment invalidates the prior claimer and increments the assignment revision.
- Supervisor can recover a task stuck in `SUBMITTED`, rotate an unavailable reviewer, or cancel before a capability exists.
- Restart execution requires exact shift/revision/graph/target/executor/payload/nonce binding and is consumed atomically once.
- Nonce replay and terminal transition replay revert.
- A completion digest is a worker attestation commitment, not proof of physical work.

## Prompt injection

Handoff text is quoted as untrusted instruction data. The prompt tells validators never to execute meta-instructions inside it. Even a compromised output must pass deterministic graph validation before storage.

## Safe failure

Malformed, unclear or structurally unsafe compiler output results in `COMPILE_FAILED`. Consensus rejection leaves the handoff retryable without granting a capability. The lead may submit a revised handoff. No task is created until a complete graph passes validation.

## Out of scope

The contract does not observe physical equipment, prove task truth, operate a PLC, hold funds or provide emergency-stop functionality.

