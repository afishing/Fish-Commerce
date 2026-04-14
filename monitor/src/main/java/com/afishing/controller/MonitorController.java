package com.afishing.controller;

import com.afishing.common.result.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.management.MemoryUsage;
import java.lang.management.OperatingSystemMXBean;
import java.lang.management.RuntimeMXBean;
import java.lang.management.ThreadMXBean;
import java.util.HashMap;
import java.util.Map;

/**
 * 系统监控控制器
 */
@RestController
@RequestMapping("/api/monitor")
public class MonitorController {

    /**
     * 获取系统基本信息
     */
    @GetMapping("/info")
    public Result<Map<String, Object>> getSystemInfo() {
        Map<String, Object> info = new HashMap<>();
        
        // JVM 信息
        RuntimeMXBean runtimeMXBean = ManagementFactory.getRuntimeMXBean();
        info.put("jvmName", runtimeMXBean.getVmName());
        info.put("jvmVersion", runtimeMXBean.getVmVersion());
        info.put("startTime", runtimeMXBean.getStartTime());
        info.put("uptime", runtimeMXBean.getUptime());
        
        // 操作系统信息
        OperatingSystemMXBean osMXBean = ManagementFactory.getOperatingSystemMXBean();
        info.put("osName", osMXBean.getName());
        info.put("osVersion", osMXBean.getVersion());
        info.put("osArch", osMXBean.getArch());
        info.put("availableProcessors", osMXBean.getAvailableProcessors());
        
        // 运行时信息
        Runtime runtime = Runtime.getRuntime();
        info.put("totalMemory", runtime.totalMemory() / 1024 / 1024); // MB
        info.put("freeMemory", runtime.freeMemory() / 1024 / 1024); // MB
        info.put("maxMemory", runtime.maxMemory() / 1024 / 1024); // MB
        info.put("usedMemory", (runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024); // MB
        
        return Result.success(info);
    }

    /**
     * 获取内存使用情况
     */
    @GetMapping("/memory")
    public Result<Map<String, Object>> getMemoryInfo() {
        Map<String, Object> memory = new HashMap<>();
        
        MemoryMXBean memoryMXBean = ManagementFactory.getMemoryMXBean();
        
        // 堆内存
        MemoryUsage heapUsage = memoryMXBean.getHeapMemoryUsage();
        Map<String, Object> heap = new HashMap<>();
        heap.put("init", heapUsage.getInit() / 1024 / 1024);
        heap.put("used", heapUsage.getUsed() / 1024 / 1024);
        heap.put("committed", heapUsage.getCommitted() / 1024 / 1024);
        heap.put("max", heapUsage.getMax() / 1024 / 1024);
        memory.put("heap", heap);
        
        // 非堆内存
        MemoryUsage nonHeapUsage = memoryMXBean.getNonHeapMemoryUsage();
        Map<String, Object> nonHeap = new HashMap<>();
        nonHeap.put("init", nonHeapUsage.getInit() / 1024 / 1024);
        nonHeap.put("used", nonHeapUsage.getUsed() / 1024 / 1024);
        nonHeap.put("committed", nonHeapUsage.getCommitted() / 1024 / 1024);
        nonHeap.put("max", nonHeapUsage.getMax() / 1024 / 1024);
        memory.put("nonHeap", nonHeap);
        
        return Result.success(memory);
    }

    /**
     * 获取线程信息
     */
    @GetMapping("/threads")
    public Result<Map<String, Object>> getThreadInfo() {
        Map<String, Object> threads = new HashMap<>();
        
        ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();
        threads.put("threadCount", threadMXBean.getThreadCount());
        threads.put("peakThreadCount", threadMXBean.getPeakThreadCount());
        threads.put("daemonThreadCount", threadMXBean.getDaemonThreadCount());
        threads.put("totalStartedThreadCount", threadMXBean.getTotalStartedThreadCount());
        
        return Result.success(threads);
    }

    /**
     * 获取 CPU 使用率（近似值）
     */
    @GetMapping("/cpu")
    public Result<Map<String, Object>> getCpuInfo() {
        Map<String, Object> cpu = new HashMap<>();
        
        OperatingSystemMXBean osMXBean = ManagementFactory.getOperatingSystemMXBean();
        cpu.put("systemLoadAverage", osMXBean.getSystemLoadAverage());
        cpu.put("availableProcessors", osMXBean.getAvailableProcessors());
        
        // 计算进程 CPU 使用率
        RuntimeMXBean runtimeMXBean = ManagementFactory.getRuntimeMXBean();
        long uptime = runtimeMXBean.getUptime();
        ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();
        long cpuTime = threadMXBean.getCurrentThreadCpuTime();
        
        // 近似 CPU 使用率
        double cpuUsage = uptime > 0 ? (cpuTime / 1000000.0) / uptime * 100 : 0;
        cpu.put("processCpuUsage", Math.min(cpuUsage, 100));
        
        return Result.success(cpu);
    }
}
