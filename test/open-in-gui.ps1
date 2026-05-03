# ============================================================
#  在 JMeter GUI 模式下打开测试计划（可实时查看图表/截图）
#  用法: .\open-in-gui.ps1
# ============================================================
$JMETER_HOME = "D:\soft-coding\apache-jmeter-5.6.3\apache-jmeter-5.6.3"
$JMX_FILE    = "$PSScriptRoot\fish-commerce-perf-test.jmx"

if (-not (Test-Path "$JMETER_HOME\bin\jmeter.bat")) {
    Write-Host "JMeter 未找到: $JMETER_HOME" -ForegroundColor Red
    exit 1
}

Write-Host "以 GUI 模式打开测试计划..." -ForegroundColor Cyan
Write-Host "提示: GUI 模式下在菜单 Run > Start 运行，可实时截图各 Listener 图表" -ForegroundColor Yellow

Start-Process "$JMETER_HOME\bin\jmeter.bat" -ArgumentList "-t `"$JMX_FILE`""
