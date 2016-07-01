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
        		var lineStyle = {
        			    normal: {
        			        width: 1,
        			        opacity: 0.5
        			    }
        			};
				$.ajax({
					type:"post",
					url:"GetKaiXiaoServlet.do",
					async:true,
					success:function(data){
					var obj = 	JSON.parse(data);
						// 使用刚指定的配置项和数据显示图表。
				        myChart.setOption({
				        backgroundColor: '#161627',
					    title: {
					        text: '基础雷达图',
					        left: 'center',
					        textStyle: {
					            color: '#eee'
					        }
					    },
					    tooltip: {},
					    legend: {
					    	bottom: 5,
					    	itemGap: 20,
					        data: ['预算分配（Allocated Budget）1', '实际开销（Actual Spending）2'],
					        textStyle: {
					            color: '#fff',
					            fontSize: 14
					        },
					    },
					    radar: {
					        // shape: 'circle',
					        indicator: [
					           { name: 'AQI', max: 6500},
					           { name: '管理（Administration）', max: 16000},
					           { name: '信息技术（Information Techology）', max: 30000},
					           { name: '客服（Customer Support）', max: 38000},
					           { name: '研发（Development）', max: 52000},
					           { name: '市场（Marketing）', max: 25000}
					        ],
					        shape: 'circle',
					        name: {//配置六星字体的颜色
					            textStyle: {
					                color: 'rgb(238, 197, 102)'
					            }
					        },
					        splitLine: {//配置坐标线的颜色
					            lineStyle: {
					                color: [
					                    'rgba(238, 197, 102, 0.1)', 'rgba(238, 197, 102, 0.2)',
					                    'rgba(238, 197, 102, 0.4)', 'rgba(238, 197, 102, 0.6)',
					                    'rgba(238, 197, 102, 0.8)', 'rgba(238, 197, 102, 1)'
					                ].reverse()
					            }
					        },
					        splitArea: {//配置是否显示坐标背景
					            show: false
					        },
					        axisLine: {//配置坐标三条线的颜色
					            lineStyle: {
					                color: 'rgba(238, 197, 102, 0.5)'
					            }
					        }
					        
					    },
					    series: [{
					        name: '预算 vs 开销（Budget vs spending）',
					        type: 'radar',
					        lineStyle: {//配置数据线的颜色
					            normal: {
					                width: 1,
					                opacity: 0.5
					            }
					        },
					        data : obj,
					        symbol: 'none',//是否显示焦点圆圈
					        itemStyle: {
				                normal: {
				                    color: '#F9713C'
				                }
				            },
				            areaStyle: {
				                normal: {
				                    opacity: 0.1
				                }
				            }
					    }]
					});
						
				}
				});
			});
		</script>
	</head>
	<body>
		<div id="main"  style="width: 1000px;height:600px;"></div>
	</body>
</html>
