<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath }"></c:set>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<link rel="stylesheet" href="${ctx }/assets/jquery-easyui-1.4.5/themes/default/easyui.css" />
		<link rel="stylesheet" href="${ctx }/assets/jquery-easyui-1.4.5/themes/icon.css" />
		<script type="text/javascript" src="${ctx }/assets/jquery-easyui-1.4.5/jquery.min.js" ></script>
		<script type="text/javascript" src="${ctx }/assets/jquery-easyui-1.4.5/jquery.easyui.min.js" ></script>
		<style type="text/css">
			#fm{
				margin:0;
				padding:10px 30px;
			}
			.ftitle{
				font-size:14px;
				font-weight:bold;
				color:#666;
				padding:5px 0;
				margin-bottom:10px;
				border-bottom:1px solid #ccc;
			}
			.fitem{
				margin-bottom:5px;
			}
			.fitem label{
				display:inline-block;
				width:80px;
			}
		</style>
		<script>
		var url;
		function doSearch(){
			var startDate = $('#startDate').datebox('getValue');
			var endDate = $('#endDate').datebox('getValue');
			var title = $("#searchtitle").val();
			
			init(startDate,endDate,title);
		}
		function newUser(){
			$('#dlg').dialog('open').dialog('setTitle','添加文章');
			$('#fm').form('clear');
			url = 'AddAritcleServlet.do';
		}
		function editUser(){
			var row = $('#dg').datagrid('getSelected');
			if (row){
				$('#dlg').dialog('open').dialog('setTitle','编辑文章');
				$('#fm').form('load',row);
				url = 'UpdateAritcleServlet.do?id='+row.id;
			}
		}
		function saveUser(){
			$('#fm').form('submit',{
				url: url,
				onSubmit: function(){
					return $(this).form('validate');
				},
				success: function(result){
					var obj = JSON.parse(result);
					if (obj.res){
						$('#dlg').dialog('close');		// close the dialog
						$('#dg').datagrid('reload');	// reload the user data
						$.messager.show({
							title: '成功',
							msg: obj.msg,
							timeout:3000,
							showType:'fade',
							style:{
								right:'',
								top:document.body.scrollTop+document.documentElement.scrollTop,
								bottom:''
							}
						});
					} else {
						$.messager.show({
							title: '失败',
							msg: obj.msg
						});
					}
				}
			});
		}
		function removeUser(){
			var row = $('#dg').datagrid('getSelected');
			if (row){
				$.messager.confirm('Confirm','是否删除该文章?',function(r){
					if (r){
						$.ajax({
							type:'post',
							url:'RemoveAritcleServlet.do',
							data:{
								"id":row.id
							},
							success:function(data){
								var obj = JSON.parse(data);
								if (obj.res){
									$('#dg').datagrid('reload');	// reload the user data
									$.messager.show({	// show error message
										title: '成功',
										msg: obj.msg
									});
								} else {
									$.messager.show({	// show error message
										title: '失败',
										msg: obj.msg
									});
								}
							}
						});
						
						
						
					}
				});
			}
		}
		function init(sd,ed,tt){
			$('#dg').datagrid({    
			    url:'ListArtiServlet2.do',
			    method:'post',
			    fitColumns:'true',
			    singleSelect:'true',
			    striped:'true',
			    queryParams:{
					startDate: sd,
					endDate:ed,
					title: tt
				},
				pageSize:5,
				pageList:[5,10,15,20,25],
				pagination:"true",
				toolbar: '#toolbar',
			    columns:[[    
			        {field:'id',title:'主键',width:100,sortable:true},    
			        {field:'title',title:'文章标题',width:100},    
			        {field:'content',title:'内容',width:400,align:'right'},
			        {field:'thumb',title:'点赞数',width:100}, 
			        {field:'username',title:'作者',width:100},
			        {field:'date',title:'日期',width:100}
			    ]]    
			});
		}
		$(function(){
			init();
		});
		</script>
	</head>
	<body>
		<table id="dg"></table>
		<div id="toolbar">
			<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newUser()">添加文章</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editUser()">编辑文章</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="removeUser()">删除文章</a>
			<div>
				<form method="post" id="searchForm">
					开始日期: <input id="startDate" class="easyui-datebox" style="width:100px" name="startDate">
					结束日期: <input id="endDate" class="easyui-datebox" style="width:100px" name="endDate">
					文章标题: 
					<input name="title" id="searchtitle">
					<a href="#" class="easyui-linkbutton" iconCls="icon-search"  onclick="doSearch()">搜索</a>
				</form>
			</div>
		</div>
		<div id="dlg" class="easyui-dialog" style="width:400px;height:280px;padding:10px 20px"
			closed="true" buttons="#dlg-buttons">
			<div class="ftitle">文章的信息</div>
			<form id="fm" method="post" novalidate>
				<div class="fitem">
					<label>文章的标题:</label>
					<input name="title" class="easyui-validatebox" required="true">
				</div>
				<div class="fitem">
					<label>文章的内容:</label>
					<input name="content" class="easyui-validatebox" required="true">
				</div>
				<div class="fitem">
					<label>点赞数:</label>
					<input name="thumb">
				</div>
				<div class="fitem">
					<label>作者:</label>
					<input name="username" class="easyui-validatebox" required="true">
				</div>
			</form>
		</div>
	<div id="dlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveUser()">Save</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Cancel</a>
	</div>
	</body>
</html>
