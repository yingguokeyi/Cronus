<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/common.jsp"%>

<div class="" style=""><span style="margin-left:30px;">联系人信息</span></div>
<div class="" style="">
    <form class="layui-form" action="">
        <div class="layui-inline">
            <label class="layui-form-label">姓名:</label>
            <div class="layui-input-block">
                <input type="text" name="username" required lay-verify="required" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">手机号:</label>
            <div class="layui-input-inline">
                <input type="text" name="phonenumber" required lay-verify="required|phone|number" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item" style="margin-top:10px;">
            <div class="layui-inline">
                <label class="layui-form-label">性别:</label>
                <div class="layui-input-inline">
                    <select name="modules" lay-verify="required" lay-search="">
                        <option value=""></option>
                        <option value="0">男</option>
                        <option value="1">女</option>

                    </select>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">生日:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="date" id="date" lay-verify="date" placeholder="yyyy-MM-dd"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">邮箱:</label>
                <div class="layui-input-inline">
                    <input type="text" name="email" lay-verify="email" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">职务:</label>
                    <div class="layui-input-block">
                        <input type="text" name="post" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">头像:</label>
                <div class="layui-input-block" id="LAY_demo3">
                    <img src="image/1.png">
                    <div>
                        <a href="">删除&nbsp;&nbsp;</a>
                        <a href="">查看</a>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">联系人名片:</label>
                <div class="layui-input-block" id="LAY_demo3">
                    <img src="image/1.png">
                    <img src="image/1.png">
                    <img src="image/1.png">
                    <img src="image/1.png">
                    <button type="add1" class="layui-btn layui-btn-primary">添加</button>
                    <div>
                        <a href="">删除&nbsp;&nbsp;</a>
                        <a href="">查看</a>&nbsp;&nbsp;
                        <a href="">删除&nbsp;&nbsp;</a>
                        <a href="">查看</a>
                    </div>

                </div>
            </div>
            <div class="" style=""><span style="margin-left:30px;">账号信息</span></div>
            <div class="layui-form-item layui-form-text">
                <div class="layui-inline">
                    <label class="layui-form-label">账号:</label>
                    <div class="layui-input-block">
                        <input type="text" name="username" required lay-verify="required" autocomplete="off"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">邀请码:</label>
                    <div class="layui-input-block">
                        <input type="text" name="username" required lay-verify="required" autocomplete="off"
                               class="layui-input" disabled="disabled">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">密码:</label>
                <div class="layui-input-inline">
                    <input type="password" name="email" lay-verify="email" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">会员类型:</label>
                    <div class="layui-input-block">
                        <input type="text" name="post" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">确认密码:</label>
                <div class="layui-input-inline">
                    <input type="password" name="email" lay-verify="email" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="" style=""><span style="margin-left:30px;">注册信息</span></div>
            <div class="layui-form-item">
                <label class="layui-form-label"> 注册时间:</label>
                <div class="layui-input-inline">
                    <input type="text" name="rtime" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">注册来源:</label>
                    <div class="layui-input-block">
                        <input type="text" name="soucer" value="{p.source}" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="" style=""><span style="margin-left:30px;">银行账户</span></div>
            <div class="layui-form-item">
                <label class="layui-form-label"> 账户余额:</label>
                <div class="layui-input-inline">
                    <input type="text" name="balance" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label"> 实际收益总额:</label>
                <div class="layui-input-inline">
                    <input type="text" name="total" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <button type="reset" class="layui-btn layui-btn-primary">收支详情</button>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label"> 预估收益总额:</label>
                <div class="layui-input-inline">
                    <input type="text" name="totalincome" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <button type="reset" class="layui-btn layui-btn-primary">收支详情</button>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button type="reset" class="layui-btn layui-btn-primary">取消</button>
                    <button class="layui-btn" lay-submit lay-filter="formDemo">确认</button>
                </div>
            </div>
    </form>

    <script>
        //Demo
        layui.use(['form', 'laydate'], function () {
            var form = layui.form, laydate = layui.laydate;
            ;

            //监听提交
            form.on('submit(formDemo)', function (data) {
                layer.msg(JSON.stringify(data.field));
                return false;
            });
            //日期
            laydate.render({
                elem: '#date'
            });
            laydate.render({
                elem: '#date1'
            });
        });
    </script>

</div>




<%@ include file="/common/footer.jsp"%>

