﻿// Set up the chart
var chart = new Highcharts.Chart({
    chart: {
        renderTo: 'container',
        margin: 100,
        type: 'scatter3d',
        animation: false,
        options3d: {
            enabled: true,
            alpha: 10,
            beta: 30,
            depth: 250,
            viewDistance: 5,
            fitToPlot: false,
            frame: {
                bottom: { size: 1, color: 'rgba(0,0,0,0.02)'},
                back: { size: 1, color: 'rgba(0,0,0,0.04)'},
                side: { size: 1, color: 'rgba(0,0,0,0.06)'}
            }
        }
    },
    title: {
        text: 'Pozos Saturaciones'
    },
    subtitle: {
        text: 'Click y arrastre para rotar los ejes '
    },
    plotOptions: {
        scatter: {
            width: 10,
            height: 10,
            depth: 10
        }
    },
    yAxis: {
        min: getMinY(data),
        max: getMaxY(data),
        title: null
    },
    xAxis: {
        min: getMinX(data),
        max: getMaxX(data),
        gridLineWidth: 1
    },
    zAxis: {
        min: getMinZ(data),
        max: getMaxZ(data),
        showFirstLabel: false
    },
    legend: {
        enabled: false
    },
    tooltip: {
        pointFormat: 'Pozo:{point.pname}<br>x:{point.x}<br>y:{point.y}<br>z:{point.z}<br>Sor: {point.percentage}%'


    },
    series: [{
        name: '',
        colorByPoint: true,
        accessibility: {
            exposeAsGroupOnly: true
        },
        data: data
        }]
});
// Add mouse and touch events for rotation
(function (H) {
    function dragStart(eStart) {
        eStart = chart.pointer.normalize(eStart);

        var posX = eStart.chartX,
            posY = eStart.chartY,
            alpha = chart.options.chart.options3d.alpha,
            beta = chart.options.chart.options3d.beta,
            sensitivity = 5,  // lower is more sensitive
            handlers = [];

        function drag(e) {
            // Get e.chartX and e.chartY
            e = chart.pointer.normalize(e);

            chart.update({
                chart: {
                    options3d: {
                        alpha: alpha + (e.chartY - posY) / sensitivity,
                        beta: beta + (posX - e.chartX) / sensitivity
                    }
                }
            }, undefined, undefined, false);
        }

        function unbindAll() {
            handlers.forEach(function (unbind) {
                if (unbind) {
                    unbind();
                }
            });
            handlers.length = 0;
        }

        handlers.push(H.addEvent(document, 'mousemove', drag));
        handlers.push(H.addEvent(document, 'touchmove', drag));


        handlers.push(H.addEvent(document, 'mouseup', unbindAll));
        handlers.push(H.addEvent(document, 'touchend', unbindAll));
    }
    H.addEvent(chart.container, 'mousedown', dragStart);
    H.addEvent(chart.container, 'touchstart', dragStart);
}(Highcharts));

function getMaxX(data) {

    return Math.max.apply(Math, data.map(function (o) { return o.x; }));
}
function getMinX(data) {
    return Math.min.apply(Math, data.map(function (o) { return o.x; }));
}


function getMaxY(data) {
    return Math.max.apply(Math, data.map(function (o) { return o.y; }));
}
function getMinY(data) {

    return Math.min.apply(Math, data.map(function (o) { return o.y; }));
}

function getMaxZ(data) {
    return Math.max.apply(Math, data.map(function (o) { return o.z; }));
}
function getMinZ(data) {

    return Math.min.apply(Math, data.map(function (o) { return o.z; }));
}