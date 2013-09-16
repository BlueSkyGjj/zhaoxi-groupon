function HighchartsPieWrap(id,names,datas){
		new Highcharts.Chart({
        chart: {renderTo: id,plotBackgroundColor: null,plotBorderWidth: null,plotShadow: false},
        title: null,
        exporting: {enabled: false},
        tooltip: {pointFormat: '{series.name}: <b>{point.percentage}%</b>',percentageDecimals: 1},
        credits:{enabled: false},
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {enabled: true,color: '#000000',connectorColor: '#000000',formatter: function() {
                        return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
                    }}}
        },series: [{type: 'pie',name: names,data: datas}]});
}

function StockChartWrap(id,eventsfun,line1,line2){
	this.stock = new Highcharts.StockChart({
		chart : {renderTo : id,events : eventsfun},
		rangeSelector: {buttons: [{count: 1,type: 'minute',text: '1M'}, {count: 5,type: 'minute',text: '5M'}, {type: 'all',text: 'All'}],inputEnabled: false,selected: 0},
		exporting: {enabled: false},
		credits:{enabled: false},
		series : [
		        {name : line1,data : (function() {
				var data = [], time = (new Date()).getTime(), i;
				for( i = -600; i <= 0; i++) {
					data.push([time + i * 1000,null]);
				}
				return data;
			})()},{
				name : line2,
				data : (function() {
					var data = [], time = (new Date()).getTime(), i;
					for( i = -600; i <= 0; i++) {
						data.push([time + i * 1000,null]);
					}
					return data;
				})()}]
	});
}