<%@ page import="common.PropertiesConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>
<%
    String pCateName = request.getParameter("pCateName");     //父级分类名称
    String pCateCode = request.getParameter("pCateCode");   //父级分类编码
    String optType = request.getParameter("optType");       //操作类型
    String manType = request.getParameter("manType");       //针对处理哪级的分类
    String imgUrlPrefix = PropertiesConf.IMG_URL_PREFIX;
%>
<script>
    var imgUrlPrefix = "<%=imgUrlPrefix%>";

    //JavaScript代码区域
    layui.use(['laydate', 'layer', 'table', 'element'], function () {
        var element = layui.element;
        var $ = layui.jquery;
        var laydate = layui.laydate //日期
            , layer = layui.layer //弹层
            , table = layui.table//表格
            , form = layui.form;

        var optType = $("#optType").val();
        var manType = $("#manType").val();
        var pCateCode = $("#pCateCode").val();
        var pCateName = $("#pCateName").val();

        if (manType == 'topCate') { //渲染一级分类列表

            table.render({
                elem: '#mytable'
                	, cellMinWidth: 190
                //,height: 332
                //, url: './data/user.json' //数据接口
                , url: '${ctx}/goodsCategory?method=getTopCateList'

                , response: {
                    statusName: 'success' //数据状态的字段名称，默认：code
                    , statusCode: 1  //成功的状态码，默认：0
                    , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                    , countName: 'total' //数据总数的字段名称，默认：count
                    , dataName: 'rs' //数据列表的字段名称，默认：data
                }
                , id: 'listTable'
                //,page: true //开启分页
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left', field: "ids"}, 
                    {field: 'sort', type: 'text', title: '排序', edit: 'text'}, 
                    {field: 'dict_data_name', title: '分类名称'}, 
                    {field: 'memo', title: '备注'}, 
                    {field: 'dict_data_value', title: '分类编码'}, 
                    {field: 'wealth', width: 300, fixed: 'right', align: 'center', title: '操作', toolbar: "#barDemo"}
                ]]
            });

        } else if (manType == 'subCate') {  //渲染二级分类列表

            table.render({
                elem: '#mytable'
                //	, cellMinWidth: 190
                //,height: 332
                //, url: './data/user.json' //数据接口
                , url: '${ctx}/goodsCategory?method=getSubCateList&pCateCode=' + pCateCode

                , response: {
                    statusName: 'success' //数据状态的字段名称，默认：code
                    , statusCode: 1  //成功的状态码，默认：0
                    , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                    , countName: 'total' //数据总数的字段名称，默认：count
                    , dataName: 'rs' //数据列表的字段名称，默认：data
                }
                , id: 'listTable'
                ,page: true //开启分页
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left', field: "ids"}
                    , {field: 'sort',width: 50, type: 'text', title: '排序'}
                    , {field: 'dict_data_name',width: 100, title: '分类名称'}
                    , {field: 'memo',width: 100, title: '备注'}
                    , {field: 'dict_data_value',width: 100, title: '分类编码'}
                    , {field: 'wealth', width: 500, fixed: 'right', align: 'center', title: '操作', toolbar: "#barDemo"}
                ]]
            });

        } else if (manType == 'minCate') {  //渲染三级分类列表

            table.render({
                elem: '#mytable'
                	,height: 'full-247'
                //,height: 332
                //, url: './data/user.json' //数据接口
                , url: '${ctx}/goodsCategory?method=getMinCateList&pCateCode=' + pCateCode
                , response: {
                    statusName: 'success' //数据状态的字段名称，默认：code
                    , statusCode: 1  //成功的状态码，默认：0
                    , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                    , countName: 'total' //数据总数的字段名称，默认：count
                    , dataName: 'rs' //数据列表的字段名称，默认：data
                }
                , id: 'listTable'
                ,page: true //开启分页
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left', field: "ids"}
                    , {field: 'sort', type: 'text', title: '排序', edit: 'text'}
                    , {field: 'dict_data_name', title: '分类名称'}
                    , {field: 'sign', templet: '#imgTpl', title: '分类图片'}
                    , {field: 'memo', title: '备注'}
                    , {field: 'dict_data_value', title: '分类编码'}
                    , {field: 'GOODS_CNT', title: '关联商品数量'}
                    , {field: 'wealth', width: 300, fixed: 'right', align: 'center', title: '操作', toolbar: "#barDemo"}
                ]]
            });
        }

        //点击按钮 搜索
        $('#searchBtn').on('click', function () {
            var categoryName = $("#categoryName").val();
            //执行重载
            table.reload('listTable', {
                where: {
                    categoryName: $("#categoryName").val()
                }
            });
            return false;
        });


        //点击按钮 多项删除
        $('#delBtn').on('click', function () {
            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;
            if (selectCount == 0) {
                layer.msg("请选择一条数据！");
                return false;
            };

            layer.confirm('真的要删除选中的分类吗？', function (index) {
                layer.close(index);
                var ids = new Array(selectCount);
                for (var i = 0; i < selectCount; i++) {
                    ids[i] = checkStatus.data[i].id;
                }
                ;
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: false,
                    url: "${ctx}/goodsCategory?method=deteleCate&ids=" + ids,
                    //data: ids,
                    dataType: "json",
                    success: function (data) {

                        var nodelcnt = (Number(data.ALLCNT) - Number(data.DELCNT));

                        var msg = "";
                        if ((Number(nodelcnt) > 0) && data.DELCNT != 0) {
                            msg = "删除成功了" + data.DELCNT + "个分类，有" + nodelcnt + "个分类下挂有SPU商品，不能删除!";
                        } else if ((Number(data.DELCNT) == 0)) {
                            msg = "分类下挂有SPU商品，不能删除分类!";
                        } else if ((Number(nodelcnt) == 0)) {
                            msg = "删除成功了" + data.DELCNT + "个分类!";
                        }

                        layer.msg(msg, {time: 2000}, function () {
                            //执行重载
                            table.reload('listTable', {
                                // page: {
                                //     curr: 1 //重新从第 1 页开始
                                // }
                                where: {
                                    categoryName: $("#categoryName").val()
                                }
                            });

                        });
                    },
                    error: function () {
                        layer.alert("错误");
                    }
                })
            });
        });

        //点击按钮 添加分类
        $('#addCategoryBtn').on('click', function () {

            if (manType == 'topCate') {
                window.location.href = "${ctx}/goods/goodsCategoryAdd.jsp?optType=addTopCate&manType=" + manType;
            } else if (manType == 'subCate') {
                window.location.href = "${ctx}/goods/goodsCategoryAdd.jsp?pCateCode=" + pCateCode + "&pCateName=" + pCateName + "&optType=addSubCate&manType=subCate";
            } else if (manType == 'minCate') {
                window.location.href = "${ctx}/goods/goodsCategoryAdd.jsp?pCateCode=" + pCateCode + "&pCateName=" + pCateName + "&optType=addMinCate&manType=minCate";
            }
            return false;
        });


        //监听工具条
        table.on('tool(tableFilter)', function (obj) {

            var othis = $(this);
            var pCateName = othis.data('method');
            var pCateCode = othis.data('value');//此为工具条里的父级编码，区别于全局变量中的父级编码

            var data = obj.data;

            if (obj.event === 'detail') {
                layer.msg('ID：' + data.id + ' 的查看操作');
            } else if (obj.event === 'del') {
                layer.confirm('确认删除?', function (index) {
                    layer.close(index);
                    $.ajax({
                        type: "get",
                        url: "${ctx}/goodsCategory",
                        data: "method=deteleCate&ids=" + data.id,
                        cache: false,
                        async: false,
                        dataType: "json",
                        success: function (data) {
                            var nodelcnt = (Number(data.ALLCNT) - Number(data.DELCNT));

                            var msg = "";
                            if ((Number(nodelcnt) > 0) && data.DELCNT != 0) {
                                msg = "删除成功了" + data.DELCNT + "个分类，有" + data.NODELCNT + "分类下挂有SPU商品，不能删除!";
                            } else if ((Number(data.DELCNT) == 0)) {
                                msg = "分类下挂有SPU商品，不能删除分类!";
                            } else if ((Number(nodelcnt) == 0)) {
                                msg = "删除成功了" + data.DELCNT + "个分类!";
                            }

                            layer.msg(msg, {time: 2000}, function () {
                                //obj.del();//删除对应行（tr）的DOM结构，并更新缓存
                                table.reload('listTable');
                            });

                        },
                        error: function () {
                            layer.alert("错误");
                        }
                    });
                });
            } else if (obj.event === 'edit') {
                //layer.alert('编辑行：<br>'+ JSON.stringify(data))

                if (manType == 'topCate') {
                    window.location.href = "${ctx}/goods/goodsCategoryAdd.jsp?cateId=" + data.id + "&pCateCode=<%=pCateCode%>&pCateName=<%=pCateName%>&optType=addTopCate&manType=topCate";
                } else if (manType == 'subCate') {
                    window.location.href = "${ctx}/goods/goodsCategoryAdd.jsp?cateId=" + data.id + "&pCateCode=<%=pCateCode%>&pCateName=<%=pCateName%>&optType=addSubCate&manType=subCate";
                } else if (manType == 'minCate') {
                    window.location.href = "${ctx}/goods/goodsCategoryAdd.jsp?cateId=" + data.id + "&pCateCode=<%=pCateCode%>&pCateName=<%=pCateName%>&optType=addMinCate&manType=minCate";
                }


            } else if (obj.event === 'addCategory') {   //去添加子类页面

                if (manType == 'topCate') {
                    window.location.href = "${ctx}/goods/goodsCategoryAdd.jsp?pCateCode=" + pCateCode + "&pCateName=" + pCateName + "&optType=addSubCate&manType=subCate";
                } else if (manType == 'subCate') {
                    window.location.href = "${ctx}/goods/goodsCategoryAdd.jsp?pCateCode=" + pCateCode + "&pCateName=" + pCateName + "&optType=addMinCate&manType=minCate";
                }

            } else if (obj.event === 'viewCategory') {   //查看子类列表

                if (manType == 'topCate') {
                    window.location.href = "${ctx}/goods/goodsCategoryList.jsp?pCateCode=" + pCateCode + "&pCateName=" + pCateName + "&manType=subCate";
                } else if (manType == 'subCate') {
                    window.location.href = "${ctx}/goods/goodsCategoryList.jsp?pCateCode=" + pCateCode + "&pCateName=" + pCateName + "&manType=minCate";
                }


            }
        });

        //监听单元格编辑(排序)
        table.on('edit(tableFilter)', function (obj) {
            var value = obj.value //得到修改后的值
                , data = obj.data //得到所在行所有键值
                , field = obj.field; //得到字段
            var othis = $(this);

            if (!(/^\d+$/.test(value))) {

                othis.val(0);
                layer.tips('[分类名称:' + data.dict_data_name + ']的排序号请输入正整数，已归置为0，请重新输入！', othis);
                //othis.focus();
                return false;
            }
            var that = othis;
            $.ajax({
                type: "get",
                url: "${ctx}/goodsCategory",
                data: "method=updateSort&sort=" + value + "&id=" + data.id,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg('[分类名称:' + obj.data.dict_data_name + ']的排序号，更改成功!');
                    } else {
                        //that.val(0);
                        layer.msg("异常");
                    }
                },
                error: function () {
                    //that.val(0);
                    layer.alert("错误");
                }
            });


        });
        //刷新排序
        $('#freshSortBtn').on('click', function () {
            table.reload('listTable');
            return false;
        });
    });
</script>

<!-- 排序 -->
<script id="sortTpl" type="text/html">
    <input type="text" style="width: 100px;" name="sort" value="{{d.city}}">
</script>

<script id="imgTpl" type="text/html">
    <img src="<%=imgUrlPrefix%>{{d.img_path}}" class="layui-nav-img">
</script>


<script type="text/html" id="barDemo">
    <% if (manType.equals("topCate") || manType.equals("subCate")) {%>
    <input type="button" name="addSubCategory" value="添加子类" lay-data="{{d.dict_data_value}} "
           data-value="{{d.dict_data_value}}" data-method="{{d.dict_data_name}}" class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius"
           lay-event="addCategory" lay-filter="fixedFilter">

    <input type="button" name="viewSubCate" value="查看子类" lay-data="{{d.dict_data_value}} "
           data-value="{{d.dict_data_value}}" data-method="{{d.dict_data_name}}" class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius"
           lay-event="viewCategory" lay-filter="fixedFilter">
    <%
        } else {
        }
    %>
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit"><i class="layui-icon">&#xe642;</i>编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="del"><i class="layui-icon">&#xe640;</i>删除</a>
</script>


<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">
            <% if (manType.equals("topCate")) {%>
            一级商品分类列表
            <%} else if (manType.equals("subCate")) {%>
            [<%=pCateName%>]下的商品分类(类目等级：二级)
            <%} else {%>
            [<%=pCateName%>]下的商品分类(类目等级：三级)
            <%}%>
            <!-- 存放页面参数 -->
            <input type="hidden" id="manType" name="manType" value="<%=manType%>" lay-verify="required"
                   autocomplete="off">
            <input type="hidden" id="pCateCode" name="pCateCode" value="<%=pCateCode%>" lay-verify="required"
                   autocomplete="off">
            <input type="hidden" id="optType" name="optType" value="<%=optType%>" lay-verify="required"
                   autocomplete="off">
            <input type="hidden" id="pCateName" name="pCateName" value="<%=pCateName%>" lay-verify="required"
                   autocomplete="off">
        </div>
        <form class="layui-form layui-form-pane">
            <div style="background-color:#f2f2f2;padding:5px 0">
                <div class="layui-form-item" style="padding: 0;margin: 0">
                        <label class="layui-form-label">分类名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="categoryName" name="categoryName" placeholder="" class="layui-input">
                        </div>
                    <% if (manType.equals("minCate")) {%>
                        <label class="layui-form-label">默认类型</label>
					<div class="layui-input-inline">
						<select name="interest">
							<option value=""></option>
							<option value="0">默认类型1</option>
							<option value="1">默认类型2</option>
						</select>
					</div>
					<%
						}
					%>
                     <label class="layui-label">&nbsp;</label>
                     <div class="layui-inline">
                         <button id="searchBtn" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe615;</i>搜索</button>
                         <button type="reset" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#x2746;</i>重置</button>
                     </div>
                </div>
            </div>

            <div>
                <button id="freshSortBtn" data-method="offset" data-type="auto" class="layui-btn layui-btn-sm"  style="margin-top: 5px"><i
                        class="layui-icon">&#xe60a;</i>刷新排序
                </button>

                <% if (manType.equals("topCate")) {%>
                <button id="addCategoryBtn" class="layui-btn layui-btn-sm" href="./goodsCategoryAdd.jsp"  style="margin-top: 5px"><i
                        class="layui-icon">&#xe61f;</i>添加一级分类
                </button>
                <%} else if (manType.equals("subCate")) {%>
                <button data-method="offset" id="delBtn" data-type="auto" class="layui-btn layui-btn-sm"  style="margin-top: 5px"><i
                        class="layui-icon">&#xe640;</i>批量删除
                </button>
                <button id="addCategoryBtn" class="layui-btn layui-btn-sm" href="./goodsCategoryAdd.jsp"  style="margin-top: 5px"><i
                        class="layui-icon">&#xe61f;</i>添加二级分类
                </button>
                <%} else if (manType.equals("minCate")) {%>
                <button id="addCategoryBtn" class="layui-btn layui-btn-sm" href="./goodsCategoryAdd.jsp"  style="margin-top: 5px"><i
                        class="layui-icon">&#xe61f;</i>添加三级分类
                </button>
                <button data-method="offset" id="delBtn" data-type="auto" class="layui-btn layui-btn-sm"  style="margin-top: 5px"><i
                        class="layui-icon">&#xe640;</i>批量删除
                </button>
                <%}%>
            </div>
        </form>
        <table class="layui-hide" id="mytable" lay-filter="tableFilter"></table>
    </div>
</div>
<%@ include file="/common/footer.jsp" %>