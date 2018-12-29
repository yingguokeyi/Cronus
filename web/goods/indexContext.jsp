
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 内容主体区域 -->
<div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
        <blockquote class="layui-elem-quote">管理中心</blockquote>
        <blockquote class="layui-elem-quote">重要提醒：<span style="color: red; ">有三个新订单等待处理</span></blockquote>

        <table class="layui-table">
            <colgroup>
                <col width="150">
                <col width="200">
                <col>
            </colgroup>
            <thead>
            <tr>
                <th style="width:25%;">订单统计信息</th>
                <th style="width:25%;"></th>
                <th style="width:25%;"></th>
                <th style="width:25%;">
                    <div class="layui-form">
                        <div class="layui-input-block">
                            <select name="city" lay-verify="required" style="width:190px;">
                                <option></option>
                                <option selected="selected">全部</option>
                                <option>北京东城区</option>
                                <option>武汉武昌区</option>
                            </select>
                        </div>
                    </div>
                </th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td><span style="color: red; ">待支付订单:</span></td>
                <td><span style="color: red; ">150</span></td>
                <td>待发货订单:</td>
                <td>10</td>
            </tr>
            <tr>
                <td>待提货订单:</td>
                <td>455</td>
                <td>待确认订单</td>
                <td>5454</td>
            </tr>
            <tr>
                <td>已成交订单总数:</td>
                <td>45566</td>
                <td></td>
                <td></td>
            </tr>
            </tbody>
        </table>


        <table class="layui-table">
            <colgroup>
                <col width="150">
                <col width="200">
                <col>
            </colgroup>
            <thead>
            <tr>
                <th style="width:25%;">商品统计信息</th>
                <th style="width:25%;"></th>
                <th style="width:25%;"></th>
                <th style="width:25%;">
                    <div class="layui-form">
                        <div class="layui-input-block">
                            <select name="city" lay-verify="required" style="width:190px;">
                                <option></option>
                                <option selected="selected">全部</option>
                                <option>北京东城区</option>
                                <option>武汉武昌区</option>
                            </select>
                        </div>
                    </div>
                </th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td><span style="color: red; ">商品总数（SPU）:</span></td>
                <td><span style="color: red; ">150</span></td>
                <td>库存警告商品数:</td>
                <td>5</td>
            </tr>
            <tr>
                <td>商品总数（SKU）:</td>
                <td>455</td>
                <td>新品推荐数</td>
                <td>50</td>
            </tr>
            <tr>
                <td>销售商品数:</td>
                <td>54</td>
                <td>下架商品</td>
                <td>454</td>
            </tr>
            </tbody>
        </table>


    </div>