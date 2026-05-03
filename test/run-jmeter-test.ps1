# Fish-Commerce JMeter Performance Test Runner
# Usage: .\run-jmeter-test.ps1

# ============ Config (modify as needed) ============
$JMETER_HOME  = "D:\soft-coding\apache-jmeter-5.6.3\apache-jmeter-5.6.3"
$TARGET_HOST  = "localhost"
$TARGET_PORT  = "8080"
$TEST_USER    = "testuser"
$TEST_PASS    = "123456"
# ====================================================

$JMETER_BIN   = "$JMETER_HOME\bin\jmeter.bat"
$TEST_DIR     = $PSScriptRoot
$JMX_FILE     = "$TEST_DIR\fish-commerce-perf-test.jmx"
$RESULTS_DIR  = "$TEST_DIR\results"
$REPORT_DIR   = "$RESULTS_DIR\html_report"
$RESULTS_FILE = "$RESULTS_DIR\all_results.jtl"
$BASE_URL     = "http://" + $TARGET_HOST + ":" + $TARGET_PORT

function Write-Banner([string]$text) {
    Write-Host ""
    Write-Host ("=" * 60) -ForegroundColor Cyan
    Write-Host "  $text" -ForegroundColor Cyan
    Write-Host ("=" * 60) -ForegroundColor Cyan
}
function Write-OK([string]$msg)   { Write-Host "  [OK]   $msg" -ForegroundColor Green  }
function Write-WARN([string]$msg) { Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Write-FAIL([string]$msg) { Write-Host "  [FAIL] $msg" -ForegroundColor Red    }
function Write-INFO([string]$msg) { Write-Host "  [INFO] $msg" -ForegroundColor White  }

# ====================================================
# Step 1 - Check JMeter
# ====================================================
Write-Banner "Step 1/6  Check JMeter"
if (-not (Test-Path $JMETER_BIN)) {
    Write-FAIL "JMeter not found: $JMETER_BIN"
    Write-INFO "Please update JMETER_HOME in this script"
    exit 1
}
Write-OK "JMeter: $JMETER_HOME"
Write-OK "Target: $BASE_URL"

# ====================================================
# Step 2 - Check system availability
# ====================================================
Write-Banner "Step 2/6  Check System Availability"
$checkUri = $BASE_URL + "/api/product/list?page=1"
$sysOnline = $false
try {
    $resp = Invoke-WebRequest -Uri $checkUri -Method GET -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    if ($resp.StatusCode -eq 200) {
        Write-OK "System online ($BASE_URL)"
        $sysOnline = $true
    }
} catch {
    Write-FAIL "System unreachable: $BASE_URL"
    Write-WARN "Docker mode:  docker-compose up -d  (nginx on 8080)"
    Write-WARN "Local mode:   start Nacos+services+Gateway, set TARGET_PORT=5000"
    $ans = Read-Host "  System offline, continue anyway? (y/N)"
    if ($ans -ne 'y') { exit 1 }
}

# ====================================================
# Step 3 - Prepare test account
# ====================================================
Write-Banner "Step 3/6  Prepare Test Account ($TEST_USER)"
$loginUri  = $BASE_URL + "/api/user/login"
$loginBody = '{"username":"' + $TEST_USER + '","password":"' + $TEST_PASS + '"}'
$loginOk   = $false

try {
    $lResp = Invoke-WebRequest -Uri $loginUri -Method POST -Body $loginBody `
             -ContentType "application/json" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    $lJson = $lResp.Content | ConvertFrom-Json
    if ($lJson.code -eq 200) {
        Write-OK "Login success (UserId = $($lJson.data.id))"
        $loginOk = $true
    } else {
        Write-WARN "Login failed: $($lJson.message) - trying register..."
    }
} catch {
    Write-WARN "Login request failed - trying register..."
}

if (-not $loginOk) {
    $regUri  = $BASE_URL + "/api/user/register"
    $regBody = '{"username":"' + $TEST_USER + '","password":"' + $TEST_PASS + '","confirmPassword":"' + $TEST_PASS + '","email":"testuser@fish.com","phone":"18800001234","agreement":true}'
    try {
        $rResp = Invoke-WebRequest -Uri $regUri -Method POST -Body $regBody `
                 -ContentType "application/json" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
        $rJson = $rResp.Content | ConvertFrom-Json
        if ($rJson.code -eq 200) {
            Write-OK "Register success"
        } else {
            Write-WARN "Register result: $($rJson.message)"
        }
    } catch {
        Write-WARN "Register failed - Scene3 (order flow) may fail, other scenes unaffected"
    }
}

# ====================================================
# Step 4 - Clean old results
# ====================================================
Write-Banner "Step 4/6  Clean Old Results"
if (Test-Path $RESULTS_DIR) {
    Remove-Item $RESULTS_DIR -Recurse -Force
    Write-OK "Removed old results: $RESULTS_DIR"
}
New-Item -ItemType Directory -Path $RESULTS_DIR -Force | Out-Null
Write-OK "Created results dir: $RESULTS_DIR"

# ====================================================
# Step 5 - Run JMeter (CLI + HTML report)
# ====================================================
Write-Banner "Step 5/6  Running JMeter Tests"
Write-INFO "Plan:  $JMX_FILE"
Write-INFO "ETA:   ~15-25 minutes (500 concurrent + 60s availability)"
Write-INFO "Scenarios:"
Write-INFO "  [Scene1] Product API   - 500 threads x5 loops (response time + concurrency)"
Write-INFO "  [Scene2] User Login    - 200 threads x5 loops (auth concurrency)"
Write-INFO "  [Scene3] Order Flow    -  50 threads x10 loops (order success rate)"
Write-INFO "  [Scene4] Availability  -  10 threads  60s      (uptime)"
Write-INFO "  [Scene5] Cache Test    -  50 threads x50 loops (Redis hit rate)"
Write-Host ""

$startTime = Get-Date

# Change to test dir so JMeter relative paths (results/scene*.csv) resolve to test/results/
Push-Location $TEST_DIR

& "$JMETER_BIN" `
    -n `
    -t  "$JMX_FILE" `
    -l  "$RESULTS_FILE" `
    -e  -o "$REPORT_DIR" `
    "-JHOST=$TARGET_HOST" `
    "-JPORT=$TARGET_PORT" `
    "-JUSERNAME=$TEST_USER" `
    "-JPASSWORD=$TEST_PASS"

$exitCode = $LASTEXITCODE
Pop-Location  # restore working directory
$elapsed  = (Get-Date) - $startTime
Write-Host ""
Write-INFO "JMeter exit code: $exitCode"
Write-INFO ("Elapsed: {0}m {1}s" -f [int]$elapsed.TotalMinutes, $elapsed.Seconds)

# ====================================================
# Step 6 - Analyze results
# ====================================================
Write-Banner "Step 6/6  Test Result Analysis"

if (-not (Test-Path $RESULTS_FILE)) {
    Write-FAIL "Results file not found: $RESULTS_FILE"
    Write-WARN "Possible cause: JMeter error or wrong JMX path"
    exit 1
}

$csv     = Import-Csv $RESULTS_FILE
$total   = $csv.Count
$success = ($csv | Where-Object { $_.success -eq "true" }).Count
$fail    = $total - $success
$sucRate = if ($total -gt 0) { [Math]::Round($success / $total * 100, 2) } else { 0 }

$rts   = $csv | ForEach-Object { [int]$_.elapsed } | Sort-Object
$avgRT = if ($rts.Count -gt 0) { [Math]::Round(($rts | Measure-Object -Average).Average, 0) } else { 9999 }
$p90RT = if ($rts.Count -gt 0) { $rts[[Math]::Floor($rts.Count * 0.90)] } else { 9999 }
$p95RT = if ($rts.Count -gt 0) { $rts[[Math]::Floor($rts.Count * 0.95)] } else { 9999 }
$p99RT = if ($rts.Count -gt 0) { $rts[[Math]::Floor($rts.Count * 0.99)] } else { 9999 }
$maxRT = if ($rts.Count -gt 0) { ($rts | Measure-Object -Maximum).Maximum } else { 9999 }

$ts_sorted = $csv | ForEach-Object { [long]$_.timeStamp } | Sort-Object
$dur_s = if ($ts_sorted.Count -gt 1) { ($ts_sorted[-1] - $ts_sorted[0]) / 1000.0 } else { 1 }
$tps   = if ($dur_s -gt 0) { [Math]::Round($total / $dur_s, 1) } else { 0 }

Write-Host ""
Write-Host "  +--------------------------------------------------+" -ForegroundColor White
Write-Host "  |              Raw Data Summary                    |" -ForegroundColor White
Write-Host "  +--------------------------------------------------+" -ForegroundColor White
Write-Host ("  |  Total Requests:   {0,-10}                    |" -f $total)
Write-Host ("  |  Success:          {0,-10}                    |" -f $success)
Write-Host ("  |  Failed:           {0,-10}                    |" -f $fail)
Write-Host ("  |  Throughput(TPS):  {0,-10} req/s              |" -f $tps)
Write-Host "  +--------------------------------------------------+" -ForegroundColor White
Write-Host ("  |  Avg Response:     {0,-10} ms                 |" -f $avgRT)
Write-Host ("  |  P90 Response:     {0,-10} ms                 |" -f $p90RT)
Write-Host ("  |  P95 Response:     {0,-10} ms                 |" -f $p95RT)
Write-Host ("  |  P99 Response:     {0,-10} ms                 |" -f $p99RT)
Write-Host ("  |  Max Response:     {0,-10} ms                 |" -f $maxRT)
Write-Host "  +--------------------------------------------------+" -ForegroundColor White
Write-Host ""

Write-Host "  +--------------------------------------------------+" -ForegroundColor White
Write-Host "  |          Performance Metrics Evaluation          |" -ForegroundColor White
Write-Host "  +--------------------------------------------------+" -ForegroundColor White

$metrics = @(
    @{ Name="Avg Response < 2000ms";   Pass=($avgRT  -lt 2000);   Val="${avgRT}ms"  },
    @{ Name="P90 Response < 2000ms";   Pass=($p90RT  -lt 2000);   Val="${p90RT}ms"  },
    @{ Name="P99 Response < 2000ms";   Pass=($p99RT  -lt 2000);   Val="${p99RT}ms"  },
    @{ Name="Success Rate  > 99%";     Pass=($sucRate -ge 99);     Val="${sucRate}%" },
    @{ Name="Availability  > 99.5%";   Pass=($sucRate -ge 99.5);   Val="${sucRate}%" },
    @{ Name="Concurrency   >= 500";    Pass=($total  -ge 2500);    Val="total=${total}" }
)
foreach ($m in $metrics) {
    $icon  = if ($m.Pass) { "PASS" } else { "FAIL" }
    $color = if ($m.Pass) { "Green" } else { "Red" }
    $line  = ("  |  [{0}] {1,-30}  {2}" -f $icon, $m.Name, $m.Val)
    Write-Host $line -ForegroundColor $color
}
Write-Host "  +--------------------------------------------------+" -ForegroundColor White
Write-Host ""
Write-WARN "Cache hit rate: check Scene5 response time in HTML report (< 500ms = cache hit)"
Write-WARN "DB query efficiency: inferred from Scene1/Scene2 response time trend"

# Open HTML report
Write-Host ""
if (Test-Path "$REPORT_DIR\index.html") {
    Write-OK "HTML report: $REPORT_DIR\index.html"
    Write-Host ""
    Write-INFO "Opening report in browser..."
    Start-Process "$REPORT_DIR\index.html"
} else {
    Write-FAIL "HTML report not generated"
    Write-INFO "Manually regenerate:"
    Write-INFO "  & `"$JMETER_BIN`" -g `"$RESULTS_FILE`" -o `"$REPORT_DIR`""
}

Write-Host ""
Write-Host "  Done! Files for screenshot/archive:" -ForegroundColor Cyan
Write-Host "    HTML Report:  $REPORT_DIR\index.html" -ForegroundColor White
Write-Host "    Raw JTL:      $RESULTS_FILE" -ForegroundColor White
Write-Host "    Scene CSVs:   $RESULTS_DIR\scene*.csv" -ForegroundColor White
Write-Host ""
