<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath }"></c:set>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<script type="text/javascript" src="${ctx }/assets/js/jquery-1.12.4.min.js" ></script>
		<script type="text/javascript" src="${ctx }/assets/js/echarts.min.js" ></script>
		<script>
			$(function(){
				 // 基于准备好的dom，初始化echarts实例
        		var myChart = echarts.init(document.getElementById('main'));
        		myChart.showLoading();
				$.ajax({
					type:"post",
					url:"GetSaleCountServlet.do",
					async:true,
					success:function(data){
						myChart.hideLoading();
						var obj = JSON.parse(data);
						 // 使用刚指定的配置项和数据显示图表。
				        myChart.setOption({
				            title: {
				                text: 'ECharts 入门示例'
				            },
				            tooltip: {},
				            legend: {
				                data:['销量','销量2']
				            },
				            xAxis: {
				                data: obj.xAxis
				            },
				            yAxis: {},
				            series: [{
				                name: '销量',
				                type: 'line',
				                data: obj.list
				            },{
				                name: '销量2',
				                type: 'bar',
				                data: obj.list
				            }]
				        });
					}
				});
		       
        		
			});
		</script>
	</head>
	<body>
		<div id="main"  style="width: 600px;height:400px;"></div>
	</body>
</html>
