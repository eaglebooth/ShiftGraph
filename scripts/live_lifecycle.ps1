param(
    [ValidateSet("prepare", "retry-handoff", "compile", "tasks", "capability", "consume-only")]
    [string]$Phase
)

$ErrorActionPreference = "Stop"
$Contract = "0xbD0263B6A3b0D071Ab10C9999AA951d905946402"
$Rpc = "https://studio.genlayer.com/api"
$Shift = "sg-live-2709-a"
$Supervisor = "0x2da5393d7bbb9a037dc3abb56dbbc5c150fc843f"
$Lead = "0xfed97e2ae1a8c1983b7ca206b3545e6a2c685e43"
$Reviewer = "0xc67532aef9d2879cba9375a02e6217a3524657b8"

function Use-Account([string]$Name) {
    $output = (& genlayer.cmd account use $Name 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0) { throw "ACCOUNT_USE_FAILED $Name`n$output" }
}

function Invoke-FinalizedWrite([string]$Label, [string]$Account, [string]$Method, [string[]]$MethodArgs) {
    Use-Account $Account
    $cliArgs = @("write", $Contract, $Method, "--rpc", $Rpc, "--args") + $MethodArgs
    $writeOutput = (& genlayer.cmd @cliArgs 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0) { throw "$Label WRITE_FAILED`n$writeOutput" }
    $match = [regex]::Match($writeOutput, "0x[a-fA-F0-9]{64}")
    if (-not $match.Success) { throw "$Label TX_HASH_MISSING" }
    $tx = $match.Value.ToLowerInvariant()
    $receiptOutput = (& genlayer.cmd receipt $tx --status FINALIZED --rpc $Rpc 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0) { throw "$Label FINALITY_FAILED $tx`n$receiptOutput" }
    $finalized = $receiptOutput -match "status_name:\s*'FINALIZED'"
    $success = $receiptOutput -match "execution_result:\s*'SUCCESS'"
    if (-not $finalized -or -not $success) { throw "$Label NOT_SUCCESSFUL $tx" }
    Write-Output "$Label|$tx|FINALIZED|SUCCESS"
}

function Invoke-FinalizedError([string]$Label, [string]$Account, [string]$Method, [string[]]$MethodArgs, [string]$ExpectedError) {
    Use-Account $Account
    $cliArgs = @("write", $Contract, $Method, "--rpc", $Rpc, "--args") + $MethodArgs
    $writeOutput = (& genlayer.cmd @cliArgs 2>&1 | Out-String)
    $match = [regex]::Match($writeOutput, "0x[a-fA-F0-9]{64}")
    if (-not $match.Success) { throw "$Label TX_HASH_MISSING`n$writeOutput" }
    $tx = $match.Value.ToLowerInvariant()
    $receiptOutput = (& genlayer.cmd receipt $tx --status FINALIZED --rpc $Rpc 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0) { throw "$Label FINALITY_FAILED $tx`n$receiptOutput" }
    $finalized = $receiptOutput -match "status_name:\s*'FINALIZED'"
    $failed = $receiptOutput -match "execution_result:\s*'ERROR'"
    $reason = $receiptOutput -match [regex]::Escape($ExpectedError)
    if (-not $finalized -or -not $failed -or -not $reason) { throw "$Label EXPECTED_ERROR_NOT_PROVEN $tx" }
    Write-Output "$Label|$tx|FINALIZED|ERROR|$ExpectedError"
}

function Get-Sha256([string]$Text) {
    $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
    $hash = [Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
    return ([BitConverter]::ToString($hash)).Replace("-", "").ToLowerInvariant()
}

if ($Phase -eq "prepare") {
    Invoke-FinalizedWrite "assign-mechanical" "dbl-adapter" "assign_role" @($Shift, "MECHANICAL", $Lead)
    Invoke-FinalizedWrite "assign-safety" "dbl-adapter" "assign_role" @($Shift, "SAFETY", $Lead)
    Invoke-FinalizedWrite "assign-operations" "dbl-adapter" "assign_role" @($Shift, "OPERATIONS", $Lead)
    $handoff = (Get-Content -Raw (Join-Path $PSScriptRoot "..\fixtures\HANDOFF.txt")).Trim()
    Invoke-FinalizedWrite "submit-handoff" "lifecycle-a" "submit_handoff" @($Supervisor, $Shift, $handoff)
}

if ($Phase -eq "compile") {
    Invoke-FinalizedWrite "compile-handoff" "dbl-adapter" "compile_handoff" @($Supervisor, $Shift)
}

if ($Phase -eq "retry-handoff") {
    $handoff = "Equipment identifiers are exact machine tokens. Mechanical must replace component pump-17-seal, then run test pump-17-leak-test. Safety must inspect pump-17-guard after that test. Operations may restore pump-17-power only after both the successful leak test and guard inspection are complete."
    Invoke-FinalizedWrite "submit-handoff-revision-2" "lifecycle-a" "submit_handoff" @($Supervisor, $Shift, $handoff)
}

if ($Phase -eq "tasks") {
    Invoke-FinalizedError "unauthorized-t1-claim" "lifecycle-b" "claim_task" @($Supervisor, $Shift, "T1") "ASSIGNED_WORKER_REQUIRED"
    Invoke-FinalizedWrite "claim-t1" "lifecycle-a" "claim_task" @($Supervisor, $Shift, "T1")
    Invoke-FinalizedWrite "complete-t1" "lifecycle-a" "submit_completion" @($Supervisor, $Shift, "T1", (Get-Sha256 "pump-17 seal replaced revision 2"), "sg-t1-r2")
    Invoke-FinalizedWrite "claim-t2" "lifecycle-a" "claim_task" @($Supervisor, $Shift, "T2")
    Invoke-FinalizedWrite "complete-t2" "lifecycle-a" "submit_completion" @($Supervisor, $Shift, "T2", (Get-Sha256 "pump-17 leak test passed revision 2"), "sg-t2-r2")
    Invoke-FinalizedWrite "claim-t3" "lifecycle-a" "claim_task" @($Supervisor, $Shift, "T3")
    Invoke-FinalizedWrite "complete-t3" "lifecycle-a" "submit_completion" @($Supervisor, $Shift, "T3", (Get-Sha256 "pump-17 guard inspected revision 2"), "sg-t3-r2")
    Invoke-FinalizedWrite "claim-t4" "lifecycle-a" "claim_task" @($Supervisor, $Shift, "T4")
    Invoke-FinalizedWrite "submit-t4" "lifecycle-a" "submit_completion" @($Supervisor, $Shift, "T4", (Get-Sha256 "pump-17 restart command prepared revision 2"), "sg-t4-r2")
    Invoke-FinalizedWrite "review-t4" "lifecycle-b" "review_high_risk" @($Supervisor, $Shift, "T4", "true", (Get-Sha256 "independent restart review approved revision 2"))
}

if ($Phase -eq "capability") {
    $graphDigest = "cf343a950b764e9235d235c266958316e6b29b47fa154d9b34c0ffde73457653"
    $payloadDigest = Get-Sha256 "execute exact pump-17-power restart revision 2"
    $nonce = "sg-restart-r2"
    Invoke-FinalizedWrite "issue-restart-capability" "dbl-adapter" "issue_restart_authorization" @($Shift, $Lead, $payloadDigest, $nonce)
    Invoke-FinalizedError "wrong-actor-consume" "lifecycle-b" "consume_restart_authorization" @($Supervisor, $Shift, $graphDigest, "pump-17-power", $payloadDigest, $nonce) "AUTHORIZED_EXECUTOR_REQUIRED"
    Invoke-FinalizedWrite "consume-restart-capability" "lifecycle-a" "consume_restart_authorization" @($Supervisor, $Shift, $graphDigest, "pump-17-power", $payloadDigest, $nonce)
    Invoke-FinalizedError "replay-restart-capability" "lifecycle-a" "consume_restart_authorization" @($Supervisor, $Shift, $graphDigest, "pump-17-power", $payloadDigest, $nonce) "AUTHORIZATION_NOT_ACTIVE"
}

if ($Phase -eq "consume-only") {
    $graphDigest = "cf343a950b764e9235d235c266958316e6b29b47fa154d9b34c0ffde73457653"
    $payloadDigest = Get-Sha256 "execute exact pump-17-power restart revision 2"
    $nonce = "sg-restart-r2"
    Invoke-FinalizedError "wrong-actor-consume" "lifecycle-b" "consume_restart_authorization" @($Supervisor, $Shift, $graphDigest, "pump-17-power", $payloadDigest, $nonce) "AUTHORIZED_EXECUTOR_REQUIRED"
    Invoke-FinalizedWrite "consume-restart-capability" "lifecycle-a" "consume_restart_authorization" @($Supervisor, $Shift, $graphDigest, "pump-17-power", $payloadDigest, $nonce)
    Invoke-FinalizedError "replay-restart-capability" "lifecycle-a" "consume_restart_authorization" @($Supervisor, $Shift, $graphDigest, "pump-17-power", $payloadDigest, $nonce) "AUTHORIZATION_NOT_ACTIVE"
}
