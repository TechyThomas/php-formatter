$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$mago = Join-Path $root '.tools\windows\mago.exe'
$bufferPath = if ($args.Count -gt 0) { $args[0] } else { '<stdin>' }

if (-not (Test-Path -LiteralPath $mago -PathType Leaf)) {
    [Console]::Error.WriteLine("The Mago formatter is missing from $mago. Run bin/install-mago-windows.ps1 first.")
    exit 127
}

$utf8 = New-Object System.Text.UTF8Encoding($false)
[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$inputText = [Console]::In.ReadToEnd()
$start = New-Object System.Diagnostics.ProcessStartInfo
$start.FileName = $mago
$start.UseShellExecute = $false
$start.CreateNoWindow = $true
$start.RedirectStandardInput = $true
$start.RedirectStandardOutput = $true
$start.RedirectStandardError = $true
$quotedPath = '"' + $bufferPath.Replace('"', '\"') + '"'
$start.Arguments = "format --stdin-input --stdin-filepath $quotedPath"

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $start
[void]$process.Start()
$stdout = New-Object System.IO.MemoryStream
$stderr = New-Object System.IO.MemoryStream
$stdoutTask = $process.StandardOutput.BaseStream.CopyToAsync($stdout)
$stderrTask = $process.StandardError.BaseStream.CopyToAsync($stderr)
$inputBytes = $utf8.GetBytes($inputText)
$process.StandardInput.BaseStream.Write($inputBytes, 0, $inputBytes.Length)
$process.StandardInput.BaseStream.Close()
$process.WaitForExit()
$stdoutTask.GetAwaiter().GetResult()
$stderrTask.GetAwaiter().GetResult()
[Console]::Out.Write($utf8.GetString($stdout.ToArray()))
$errors = $utf8.GetString($stderr.ToArray())
if ($errors) { [Console]::Error.Write($errors) }
exit $process.ExitCode
