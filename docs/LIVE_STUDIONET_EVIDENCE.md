# Live Studionet evidence

- Contract: [`0xbD0263B6A3b0D071Ab10C9999AA951d905946402`](https://explorer-studio.genlayer.com/address/0xbD0263B6A3b0D071Ab10C9999AA951d905946402)
- Chain ID: `61997`
- Shift: `sg-live-2709-a`
- Supervisor: `0x2da5393d7bbb9a037dc3abb56dbbc5c150fc843f`
- Shift lead / worker / executor: `0xfed97e2ae1a8c1983b7ca206b3545e6a2c685e43`
- Safety reviewer: `0xc67532aef9d2879cba9375a02e6217a3524657b8`
- Graph digest: `cf343a950b764e9235d235c266958316e6b29b47fa154d9b34c0ffde73457653`
- Restart payload digest: `193159f8faff52a3ee9df9a55d32b642bd10c14b372377c2f4645c787fd54978`

All rows below were observed at `FINALIZED`. `SUCCESS`/`ERROR` refers to leader execution, not merely transaction submission.

| Operation | Transaction | Execution | Authoritative outcome |
|---|---|---|---|
| Create shift | [`f37ff2…f2b5`](https://explorer-studio.genlayer.com/tx/0xf37ff282c570d68f8dfaaaf8bffc977a47475edffbcc278b2d01b47e1758f2b5) | SUCCESS | Three distinct control wallets registered |
| Assign MECHANICAL | [`234880…4122`](https://explorer-studio.genlayer.com/tx/0x23488091f1749f06740b2402b14eb81c29da9b837df38a9d9c1546b6e6da4122) | SUCCESS | Worker bound |
| Assign SAFETY | [`932816…c40c`](https://explorer-studio.genlayer.com/tx/0x932816b22d3fdd2ab205bc1fd2183abd82532fa41aba734629001e70e45ec40c) | SUCCESS | Worker bound |
| Assign OPERATIONS | [`8ddc77…ef73`](https://explorer-studio.genlayer.com/tx/0x8ddc77ce2daad1ae475249fee054eded8643bfcbcccd886c76a222f47e70ef73) | SUCCESS | Worker bound |
| Submit handoff revision 1 | [`496b88…f07f`](https://explorer-studio.genlayer.com/tx/0x496b88e6d51d867d246c799df44d04d2438891fbbc9fcfd61834a80d97a6f07f) | SUCCESS | `READY_TO_COMPILE` |
| Compile revision 1 | [`922b8e…1c73`](https://explorer-studio.genlayer.com/tx/0x922b8eb3abe6e863cab619a004f66a0ee7108f16fb1c7a45226c2c64a11d1c73) | SUCCESS | Returned `NEEDS_CLARIFICATION`; state `COMPILE_FAILED`; no graph/capability created because model targets contained spaces |
| Submit handoff revision 2 | [`ef761e…fa06`](https://explorer-studio.genlayer.com/tx/0xef761e3b19ff0048994b70fa9c693147666cc68fd3236040e434868ea5d5fa06) | SUCCESS | Exact machine-token identifiers supplied |
| Compile revision 2 | [`f1f98b…cb1e`](https://explorer-studio.genlayer.com/tx/0xf1f98bbbe59fa8c86379b79955d29c48a1517e2bd10f4252c0f38be7f78ecb1e) | SUCCESS | Validator consensus accepted four-task DAG; shift `ACTIVE` |
| Reviewer attempts T1 claim | [`a852b3…3535`](https://explorer-studio.genlayer.com/tx/0xa852b3d1929a781a3227052707b49730dc2521f22d2848c8a55b15c0cfb23535) | ERROR | `ASSIGNED_WORKER_REQUIRED`; graph unchanged |
| Claim T1 | [`2f0ddd…694d`](https://explorer-studio.genlayer.com/tx/0x2f0ddd4a4814586ed42bce628202cb3e9b3e8bf55e6d1e4fc8f1aed027ae694d) | SUCCESS | T1 claimed by assigned worker |
| Complete T1 | [`40656e…0c44`](https://explorer-studio.genlayer.com/tx/0x40656ee33332e30976f950e25bd1861d79ef360b3077ef155e0f413f2ff70c44) | SUCCESS | T1 `DONE`; T2 unlocked |
| Claim T2 | [`8abb76…535a`](https://explorer-studio.genlayer.com/tx/0x8abb769927f325e21fecb85b968ec263608d64a183a8b0d74eb5943272f5535a) | SUCCESS | Dependency gate passed |
| Complete T2 | [`e0e340…1b1f`](https://explorer-studio.genlayer.com/tx/0xe0e340665126bf524481b804ad3eaa8abb922d2ed074fc924e3867417fda1b1f) | SUCCESS | T2 `DONE`; T3 unlocked |
| Claim T3 | [`7743c9…b331`](https://explorer-studio.genlayer.com/tx/0x7743c90c18a76fb965cd3d57b1d4d4c95794e14d04bb490a2ba858043abab331) | SUCCESS | Dependency gate passed |
| Complete T3 | [`fb9f81…1afd`](https://explorer-studio.genlayer.com/tx/0xfb9f814afbeaf7d2928b59dec8bc4df1f10666be6959ceaf5b5c4885a3be1afd) | SUCCESS | T3 `DONE`; T4 unlocked |
| Claim T4 | [`94965b…9628`](https://explorer-studio.genlayer.com/tx/0x94965b99bf7848ba236f7243aeaaca8737599a45776f46782384612e19759628) | SUCCESS | High-risk RESTORE task claimed |
| Submit T4 | [`907e87…1776`](https://explorer-studio.genlayer.com/tx/0x907e87c7bd1e629e253941fbea5d6178ed1818304c14ec65a191986026e51776) | SUCCESS | T4 `SUBMITTED`, not yet done |
| Independent review T4 | [`d8332f…75f4`](https://explorer-studio.genlayer.com/tx/0xd8332f91480046686eb5e659eabad3d656ce41336f136e75d6ff4908b62075f4) | SUCCESS | Reviewer approved; 4/4 tasks `DONE` |
| Issue restart capability | [`ddb705…3b67`](https://explorer-studio.genlayer.com/tx/0xddb705cd78106af3724410611c77756432e0e182b961ff9614ff2ef97fae3b67) | SUCCESS | Exact executor/graph/target/payload/nonce capability `ISSUED` |
| Reviewer attempts consume | [`42a532…b854`](https://explorer-studio.genlayer.com/tx/0x42a53275e48fad82c96c1516a7bdf83f2ffa88fa2a236d27a5c458b01cf4b854) | ERROR | `AUTHORIZED_EXECUTOR_REQUIRED`; capability remained active |
| Executor consumes capability | [`355326…eab1`](https://explorer-studio.genlayer.com/tx/0x355326bcc6525ac32d7d44a281c66b1fb58307bea5057b8b8c805e6ecac6eab1) | SUCCESS | Capability atomically `CONSUMED`; shift `CLOSED` |
| Replay consumed capability | [`0c779a…298c`](https://explorer-studio.genlayer.com/tx/0x0c779ab6fd9565cd7776dd43033d0fa276418ada4b8181dbd4781b15fae6298c) | ERROR | `AUTHORIZATION_NOT_ACTIVE`; terminal state unchanged |

## Final authoritative readback

```json
{
  "shift_id": "sg-live-2709-a",
  "status": "CLOSED",
  "authorization_status": "CONSUMED",
  "task_count": 4,
  "done_count": 4,
  "handoff_revision": 2,
  "graph_digest": "cf343a950b764e9235d235c266958316e6b29b47fa154d9b34c0ffde73457653",
  "restart_target": "pump-17-power"
}
```

Aggregate readback: `{"closed":1,"compiled":1,"shifts":1}`.

## Scope limitation

This synthetic lifecycle proves sender authorization, semantic graph compilation, deterministic dependency enforcement, independent high-risk review and exact single-use capability consumption. Completion digests are actor attestations; they do not prove physical maintenance or control real equipment.
