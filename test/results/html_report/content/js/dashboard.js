/*
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
var showControllersOnly = false;
var seriesFilter = "";
var filtersOnlySampleSeries = true;

/*
 * Add header in statistics table to group metrics by category
 * format
 *
 */
function summaryTableHeader(header) {
    var newRow = header.insertRow(-1);
    newRow.className = "tablesorter-no-sort";
    var cell = document.createElement('th');
    cell.setAttribute("data-sorter", false);
    cell.colSpan = 1;
    cell.innerHTML = "Requests";
    newRow.appendChild(cell);

    cell = document.createElement('th');
    cell.setAttribute("data-sorter", false);
    cell.colSpan = 3;
    cell.innerHTML = "Executions";
    newRow.appendChild(cell);

    cell = document.createElement('th');
    cell.setAttribute("data-sorter", false);
    cell.colSpan = 7;
    cell.innerHTML = "Response Times (ms)";
    newRow.appendChild(cell);

    cell = document.createElement('th');
    cell.setAttribute("data-sorter", false);
    cell.colSpan = 1;
    cell.innerHTML = "Throughput";
    newRow.appendChild(cell);

    cell = document.createElement('th');
    cell.setAttribute("data-sorter", false);
    cell.colSpan = 2;
    cell.innerHTML = "Network (KB/sec)";
    newRow.appendChild(cell);
}

/*
 * Populates the table identified by id parameter with the specified data and
 * format
 *
 */
function createTable(table, info, formatter, defaultSorts, seriesIndex, headerCreator) {
    var tableRef = table[0];

    // Create header and populate it with data.titles array
    var header = tableRef.createTHead();

    // Call callback is available
    if(headerCreator) {
        headerCreator(header);
    }

    var newRow = header.insertRow(-1);
    for (var index = 0; index < info.titles.length; index++) {
        var cell = document.createElement('th');
        cell.innerHTML = info.titles[index];
        newRow.appendChild(cell);
    }

    var tBody;

    // Create overall body if defined
    if(info.overall){
        tBody = document.createElement('tbody');
        tBody.className = "tablesorter-no-sort";
        tableRef.appendChild(tBody);
        var newRow = tBody.insertRow(-1);
        var data = info.overall.data;
        for(var index=0;index < data.length; index++){
            var cell = newRow.insertCell(-1);
            cell.innerHTML = formatter ? formatter(index, data[index]): data[index];
        }
    }

    // Create regular body
    tBody = document.createElement('tbody');
    tableRef.appendChild(tBody);

    var regexp;
    if(seriesFilter) {
        regexp = new RegExp(seriesFilter, 'i');
    }
    // Populate body with data.items array
    for(var index=0; index < info.items.length; index++){
        var item = info.items[index];
        if((!regexp || filtersOnlySampleSeries && !info.supportsControllersDiscrimination || regexp.test(item.data[seriesIndex]))
                &&
                (!showControllersOnly || !info.supportsControllersDiscrimination || item.isController)){
            if(item.data.length > 0) {
                var newRow = tBody.insertRow(-1);
                for(var col=0; col < item.data.length; col++){
                    var cell = newRow.insertCell(-1);
                    cell.innerHTML = formatter ? formatter(col, item.data[col]) : item.data[col];
                }
            }
        }
    }

    // Add support of columns sort
    table.tablesorter({sortList : defaultSorts});
}

$(document).ready(function() {

    // Customize table sorter default options
    $.extend( $.tablesorter.defaults, {
        theme: 'blue',
        cssInfoBlock: "tablesorter-no-sort",
        widthFixed: true,
        widgets: ['zebra']
    });

    var data = {"OkPercent": 100.0, "KoPercent": 0.0};
    var dataset = [
        {
            "label" : "FAIL",
            "data" : data.KoPercent,
            "color" : "#FF6347"
        },
        {
            "label" : "PASS",
            "data" : data.OkPercent,
            "color" : "#9ACD32"
        }];
    $.plot($("#flot-requests-summary"), dataset, {
        series : {
            pie : {
                show : true,
                radius : 1,
                label : {
                    show : true,
                    radius : 3 / 4,
                    formatter : function(label, series) {
                        return '<div style="font-size:8pt;text-align:center;padding:2px;color:white;">'
                            + label
                            + '<br/>'
                            + Math.round10(series.percent, -2)
                            + '%</div>';
                    },
                    background : {
                        opacity : 0.5,
                        color : '#000'
                    }
                }
            }
        },
        legend : {
            show : true
        }
    });

    // Creates APDEX table
    createTable($("#apdexTable"), {"supportsControllersDiscrimination": true, "overall": {"data": [1.0, 500, 1500, "Total"], "isController": false}, "titles": ["Apdex", "T (Toleration threshold)", "F (Frustration threshold)", "Label"], "items": [{"data": [1.0, 500, 1500, "GET 商品列表"], "isController": false}, {"data": [1.0, 500, 1500, "Step3-GET 获取收货地址"], "isController": false}, {"data": [1.0, 500, 1500, "GET 商品详情(id=1)"], "isController": false}, {"data": [1.0, 500, 1500, "GET 可用性探测-商品列表"], "isController": false}, {"data": [1.0, 500, 1500, "POST 用户登录"], "isController": false}, {"data": [1.0, 500, 1500, "GET 热门商品[Redis缓存接口]"], "isController": false}, {"data": [1.0, 500, 1500, "GET 商品列表-按销量[Redis缓存]"], "isController": false}, {"data": [1.0, 500, 1500, "Step1-POST 登录获取UserId"], "isController": false}, {"data": [1.0, 500, 1500, "GET 商品分类列表"], "isController": false}, {"data": [1.0, 500, 1500, "Step2-POST 加入购物车"], "isController": false}, {"data": [1.0, 500, 1500, "GET 热门商品"], "isController": false}, {"data": [1.0, 500, 1500, "Step4-POST 创建订单[核心]"], "isController": false}]}, function(index, item){
        switch(index){
            case 0:
                item = item.toFixed(3);
                break;
            case 1:
            case 2:
                item = formatDuration(item);
                break;
        }
        return item;
    }, [[0, 0]], 3);

    // Create statistics table
    createTable($("#statisticsTable"), {"supportsControllersDiscrimination": true, "overall": {"data": ["Total", 32138, 0, 0.0, 15.174186321488607, 3, 499, 8.0, 49.0, 77.0, 133.0, 93.16469493476036, 447.1761102859325, 19.08514852489716], "isController": false}, "titles": ["Label", "#Samples", "FAIL", "Error %", "Average", "Min", "Max", "Median", "90th pct", "95th pct", "99th pct", "Transactions/s", "Received", "Sent"], "items": [{"data": ["GET 商品列表", 4000, 0, 0.0, 17.248500000000046, 7, 130, 14.0, 26.0, 35.0, 65.0, 43.282548476454295, 482.99946877434644, 8.495890863054017], "isController": false}, {"data": ["Step3-GET 获取收货地址", 1000, 0, 0.0, 19.408000000000026, 6, 89, 16.0, 35.0, 41.94999999999993, 59.99000000000001, 103.27377878756585, 32.17220257151709, 22.28857921098833], "isController": false}, {"data": ["GET 商品详情(id=1)", 4000, 0, 0.0, 9.68599999999997, 4, 72, 8.0, 14.0, 19.0, 34.0, 43.34117086173083, 36.48509707067861, 8.041818812235213], "isController": false}, {"data": ["GET 可用性探测-商品列表", 138, 0, 0.0, 9.637681159420294, 7, 19, 9.0, 12.0, 12.049999999999983, 19.0, 2.3384677952315593, 13.957961328436108, 0.4567319912561639], "isController": false}, {"data": ["POST 用户登录", 2000, 0, 0.0, 6.292999999999995, 3, 37, 6.0, 9.0, 10.0, 13.0, 100.32605969400551, 60.38609857035365, 24.297717582141964], "isController": false}, {"data": ["GET 热门商品[Redis缓存接口]", 5000, 0, 0.0, 5.620399999999992, 3, 21, 5.0, 7.0, 8.0, 10.0, 32.6047263811362, 151.59302617507433, 6.145226749569617], "isController": false}, {"data": ["GET 商品列表-按销量[Redis缓存]", 5000, 0, 0.0, 8.513200000000001, 6, 51, 8.0, 10.0, 12.0, 17.0, 32.60557685786577, 363.8400790196155, 6.814056101155541], "isController": false}, {"data": ["Step1-POST 登录获取UserId", 1000, 0, 0.0, 20.584000000000003, 7, 93, 18.0, 36.0, 47.899999999999864, 69.95000000000005, 90.15506671474937, 54.31543426568698, 21.834430219978362], "isController": false}, {"data": ["GET 商品分类列表", 4000, 0, 0.0, 10.073500000000022, 4, 96, 8.0, 14.0, 21.0, 44.98999999999978, 43.38159535816929, 51.22442858304864, 7.922224933571933], "isController": false}, {"data": ["Step2-POST 加入购物车", 1000, 0, 0.0, 82.08800000000008, 29, 227, 75.0, 125.79999999999995, 143.0, 181.99, 101.94719135487817, 32.47575568355592, 30.166014629421962], "isController": false}, {"data": ["GET 热门商品", 4000, 0, 0.0, 9.697000000000017, 4, 80, 8.0, 14.0, 19.949999999999818, 50.95999999999913, 43.35103500596077, 201.5602985802536, 8.170654058740652], "isController": false}, {"data": ["Step4-POST 创建订单[核心]", 1000, 0, 0.0, 94.18400000000001, 29, 499, 80.0, 147.89999999999998, 202.89999999999986, 328.7600000000002, 103.15659170621002, 65.08113104755519, 32.9416069218073], "isController": false}]}, function(index, item){
        switch(index){
            // Errors pct
            case 3:
                item = item.toFixed(2) + '%';
                break;
            // Mean
            case 4:
            // Mean
            case 7:
            // Median
            case 8:
            // Percentile 1
            case 9:
            // Percentile 2
            case 10:
            // Percentile 3
            case 11:
            // Throughput
            case 12:
            // Kbytes/s
            case 13:
            // Sent Kbytes/s
                item = item.toFixed(2);
                break;
        }
        return item;
    }, [[0, 0]], 0, summaryTableHeader);

    // Create error table
    createTable($("#errorsTable"), {"supportsControllersDiscrimination": false, "titles": ["Type of error", "Number of errors", "% in errors", "% in all samples"], "items": []}, function(index, item){
        switch(index){
            case 2:
            case 3:
                item = item.toFixed(2) + '%';
                break;
        }
        return item;
    }, [[1, 1]]);

        // Create top5 errors by sampler
    createTable($("#top5ErrorsBySamplerTable"), {"supportsControllersDiscrimination": false, "overall": {"data": ["Total", 32138, 0, "", "", "", "", "", "", "", "", "", ""], "isController": false}, "titles": ["Sample", "#Samples", "#Errors", "Error", "#Errors", "Error", "#Errors", "Error", "#Errors", "Error", "#Errors", "Error", "#Errors"], "items": [{"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}]}, function(index, item){
        return item;
    }, [[0, 0]], 0);

});
