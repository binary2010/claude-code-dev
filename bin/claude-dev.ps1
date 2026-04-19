param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ArgsFromCaller
)

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$CallerDir = (Get-Location).Path
$RecoveryCliPath = Join-Path $RepoRoot "src\localRecoveryCli.ts"

$env:CALLER_DIR = $CallerDir

# 将当前目录入栈保存，并跳转到 $RepoRoot
Push-Location $RepoRoot

try {
    if (
        $env:CLAUDE_CODE_FORCE_RECOVERY_CLI -eq "1" -and
        (Test-Path $RecoveryCliPath)
    ) {
        bun --env-file=.env .\src\localRecoveryCli.ts @ArgsFromCaller
    }
    else {
        bun --env-file=.env .\src\entrypoints\cli.tsx @ArgsFromCaller
    }
}
finally {
    # 无论脚本是正常结束还是异常中断，finally 都会执行，确保切回 A 目录
    Pop-Location
}
