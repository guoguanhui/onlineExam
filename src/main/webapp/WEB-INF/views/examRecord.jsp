<%--
  Created by IntelliJ IDEA.
  User: lemon
  Date: 2019/12/7
  Time: 17:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%
        //这个的路径是以斜线开始的，不以斜线结束
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <meta http-equiv="Content-Type" content="text/html; Charset=gb2312">
    <meta http-equiv="Content-Language" content="zh-CN">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>考试记录</title>
    <link rel="shortcut icon" href="${APP_PATH}/statics/main/images/Logo_40.png" type="image/x-icon">
    <!--Layui-->
    <link href="${APP_PATH}/statics/main/plug/layui/css/layui.css" rel="stylesheet" />
    <!--font-awesome-->
    <link href="${APP_PATH}/statics/main/plug/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <!--全局样式表-->
    <link href="${APP_PATH}/statics/main/css/global.css" rel="stylesheet" />
    <!-- 本页样式表 -->
    <link href="${APP_PATH}/statics/main/css/resource.css" rel="stylesheet" />
    <script src="${APP_PATH}/statics/js/jquery-1.10.2.js"></script>
    <link href="${APP_PATH}/statics/css/bootstrap-3.3.7-dist/css/bootstrap.css" rel="stylesheet">
    <script src="${APP_PATH}/statics/css/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <style>
        .dropdown-menu li a{
            color:#1aa094 !important;
        }
        #message{
            width:100px;
            height:20px;
            margin-top:10px;
        }
        /*角标 */
        .ii{
            /*display: none;*/
            background: #f00!important;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            position: absolute;
            top: 20px;
            right: 60px;
            text-align: center;
            color: #FFF;
            z-index: 99999;
        }

    </style>
</head>
<body>
<!-- 编辑板块模态框 -->
<div class="modal fade" id="inviCodeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">邀请码</h4>
            </div>
            <div class="modal-body">
                <!--编辑表单-->
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="input_code" class="col-sm-2 control-label">请填写邀请码：</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="input_code" id="input_code" placeholder="请填写邀请码">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">关闭</button>
                <button type="submit" class="btn btn-primary btn-sm" id="code_btn">确定</button>
            </div>
        </div>
    </div>
</div>
<!-- 导航 -->
<nav class="blog-nav layui-header">
    <div class="blog-container">
        <!-- QQ互联登陆 -->

<%--        <a href="javascript:;" class="blog-user layui-hide">--%>
<%--            <img src="${APP_PATH}/statics/main/images/Absolutely.jpg" alt="Absolutely" title="Absolutely" />--%>
<%--        </a>--%>
        <!-- 不落阁 -->
        <a class="blog-logo" href="index2.jsp">在线考试系统</a>
        <!-- 导航菜单 -->
        <ul class="layui-nav" lay-filter="nav" style="margin-left:170px">
            <li class="layui-nav-item">
                <a href="${APP_PATH}/index2.jsp"><i class="fa fa-home fa-fw"></i>&nbsp;网站首页</a>
            </li>
            <li class="layui-nav-item">
                <a href="${APP_PATH}/toWhere?where=paperCenter"><i class="fa fa-file-text fa-fw"></i>&nbsp;试卷中心</a>
            </li>
            <li class="layui-nav-item layui-this">
                <a href="${APP_PATH}/toWhere?where=examRecord"><i class="fa fa-tags fa-fw"></i>&nbsp;考试记录</a>
            </li>
            <li class="layui-nav-item">
                <a href="${APP_PATH}/toWhere?where=wrongRecord"><i class="fa fa-tags fa-fw"></i>&nbsp;错题记录</a>
            </li>

            <c:if test="${userid==null}">
                <li class="layui-nav-item">
                    <a href="${APP_PATH}/login"><i class="fa fa-info fa-fw"></i>登录</a>
                </li>
                <li class="layui-nav-item">
                    <a href="${APP_PATH}/register"><i class="fa fa-info fa-fw"></i>注册</a>
                </li>
                <li class="layui-nav-item">
                    <a href="${APP_PATH}/admin"><i class="fa fa-tags fa-fw"></i>&nbsp;管理员入口</a>
                </li>
            </c:if>
            <c:if test="${userid!=null&&role!=3}">
                <li class="layui-nav-item dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                        <img src="${userheadpic}" alt='头像' class="img-circle" width=30px height=30px><span> ${username}</span><span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="${APP_PATH}/toWhere?where=personalCenter">个人主页</a></li>
                        <li id="message">
                            <a href="${APP_PATH}/toReadMessage?userId=${userid}">
                                个人消息<span id="msgNum" class="ii">4</span></a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="${APP_PATH}/userExit">退出登录</a></li>
                    </ul>
                </li>
            </c:if>
            <c:if test="${userid!=null&&role==3}">
                <li class="layui-nav-item">
                    <a href="${APP_PATH}/admin"><i class="fa fa-tags fa-fw"></i>&nbsp;管理员入口</a>
                </li>
            </c:if>
        </ul>
        <!-- 手机和平板的导航开关 -->
        <a class="blog-navicon" href="javascript:;">
            <i class="fa fa-navicon"></i>
        </a>
    </div>
</nav>
<!-- 主体（一般只改变这里的内容） -->
<div class="blog-body">
    <div class="blog-container">
        <blockquote class="layui-elem-quote sitemap layui-breadcrumb shadow">
            <a href="${APP_PATH}/index2.jsp" title="网站首页">网站首页</a>
            <a><cite>考试记录</cite></a>
        </blockquote>
        <div class="blog-main">
            <div class="blog-main">
                <div class="resource-main">
                    <%-- 从这里开始构建--%>
                    <div class="resource shadow">
                        <div class="resource-cover">
                            <a href="" target="_blank">
                                <img src="${APP_PATH}/statics/main/images/cover/201703051349045432.jpg" alt="时光轴" />
                            </a>
                        </div>
                        <h1 class="resource-title"><a href="" target="_blank">时光轴</a></h1>
                        <p class="resource-abstract">本博客使用的时光轴的源码，手工打造！</p>
                        <div class="resource-footer">
                            <a class="layui-btn layui-btn-small layui-btn-primary" href="" target="_blank"><i class="fa fa-eye fa-fw"></i>开始考试</a>
                            <a class="layui-btn layui-btn-small layui-btn-primary" href="" target="_blank"><i class="fa fa-download fa-fw"></i>详情</a>
                        </div>
                    </div>
                    <!--结束构建试题列表-->

                    <!-- 清除浮动 -->
                    <%--                    <div class="clear"></div>--%>
                </div>
                <!--显示分页信息-->
                <div class="row">
                    <!--分页文字信息-->
                    <div class="col-md-6" id="page_info_area">
                        sdf
                    </div>
                    <!--分页条-->
                    <div class="col-md-6" id="page_nav_area">
                        sdf
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- 底部 -->
<footer class="blog-footer">
    <p><span>Copyright</span><span>&copy;</span><span>2020</span><a href="">郭观辉</a><span>Design By Guanhui Guo</span></p>
    <p><a href="http://www.miibeian.gov.cn/" target="_blank">南昌大学</a></p>
</footer>
<!--侧边导航-->
<ul class="layui-nav layui-nav-tree layui-nav-side blog-nav-left layui-hide" lay-filter="nav">
    <li class="layui-nav-item">
        <a href="${APP_PATH}index2.jsp"><i class="fa fa-home fa-fw"></i>&nbsp;网站首页</a>
    </li>
    <li class="layui-nav-item">
        <a href="${APP_PATH}/toWhere?where=paperCenter"><i class="fa fa-file-text fa-fw"></i>&nbsp;试卷中心</a>
    </li>
    <li class="layui-nav-item layui-this">
        <a href="${APP_PATH}/toWhere?where=examRecord"><i class="fa fa-tags fa-fw"></i>&nbsp;考试记录</a>
    </li>
    <li class="layui-nav-item">
        <a href="${APP_PATH}/toWhere?where=wrongRecord"><i class="fa fa-tags fa-fw"></i>&nbsp;错题记录</a>
    </li>

    <c:if test="${userid==null}">
        <li class="layui-nav-item">
            <a href="${APP_PATH}/login"><i class="fa fa-info fa-fw"></i>登录</a>
        </li>
        <li class="layui-nav-item">
            <a href="${APP_PATH}/register"><i class="fa fa-info fa-fw"></i>注册</a>
        </li>
        <li class="layui-nav-item">
            <a href="${APP_PATH}/admin"><i class="fa fa-tags fa-fw"></i>&nbsp;管理员入口</a>
        </li>
    </c:if>
    <c:if test="${userid!=null&&role!=3}">
        <li class="layui-nav-item dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                <img src="${userheadpic}" alt='头像' class="img-circle" width=30px height=30px><span> ${username}</span><span class="caret"></span></a>
            <ul class="dropdown-menu">
                <li><a href="${APP_PATH}/jumpwang/toSelfInfo">个人主页</a></li>
                <li role="separator" class="divider"></li>
                <li><a href="${APP_PATH}/userExit">退出登录</a></li>
            </ul>
        </li>
    </c:if>
    <c:if test="${userid!=null&&role==3}">
        <li class="layui-nav-item">
            <a href="${APP_PATH}/admin"><i class="fa fa-tags fa-fw"></i>&nbsp;管理员入口</a>
        </li>
    </c:if>
</ul>
<!--分享窗体-->
<div class="blog-share layui-hide">
    <div class="blog-share-body">
        <div style="width: 200px;height:100%;">
            <div class="bdsharebuttonbox">
                <a class="bds_qzone" data-cmd="qzone" title="分享到QQ空间"></a>
                <a class="bds_tsina" data-cmd="tsina" title="分享到新浪微博"></a>
                <a class="bds_weixin" data-cmd="weixin" title="分享到微信"></a>
                <a class="bds_sqq" data-cmd="sqq" title="分享到QQ好友"></a>
            </div>
        </div>
    </div>
</div>
<!--遮罩-->
<div class="blog-mask animated layui-hide"></div>
<!-- layui.js -->
<script src="${APP_PATH}/statics/main/plug/layui/layui.js"></script>
<!-- 全局脚本 -->
<script src="${APP_PATH}/statics/js/common.js"></script>
<script src="${APP_PATH}/statics/main/js/global.js"></script>
<%--<script type="text/javascript" src="${APP_PATH}/statics/bootstrapValidator/vendor/jquery/jquery-1.10.2.min.js"></script>--%>
<script src="${APP_PATH}/statics/layuimini/lib/layui-v2.5.5/lay/modules/layer.js" charset="utf-8"></script>

<script>
    function showNoReadCount(){
        if("${userid}"==""){
            $("#msgNum").text("");
            $("#msgNum").hide();
        }else{
            var userid="${userid}";
            userid=parseInt(userid);
            var data={
                "userId":userid
            };
            $.ajax({
                url:"${APP_PATH}/findNoReadCount",
                data:data,
                type:"get",
                success:function (result) {
                    //console.log(result);
                    var noReadCount=result.extend.noReadCount;
                    if(noReadCount==0){
                        $("#msgNum").text("");
                        $("#msgNum").hide();
                    }else{
                        $("#msgNum").text(""+noReadCount);
                        $("#msgNum").show();
                    }
                }
            });
        }
    }
    function buildPaperPage(result){
        //首先清空所有内容
        $(".resource-main").empty();
        var paperlist=result.extend.pageInfo.list;
        $.each(paperlist,function (index,item) {//所有的版块
            var pageCount=index%10+1;
            //alert(item.sSectionname);//测试是否成功
            var img=$("<img src=\"${APP_PATH}/statics/images/section/section"+pageCount+".jpg\" alt=\"试卷封面\"/>");
            var sectionA=$("<a target='_blank'></a>").append(img);
            <%--sectionA.attr("href","${APP_PATH}/section/thesection?sectionId="+item.sId);--%>
            var cover=$("<div class='resource-cover'></div>").append(sectionA);

            var sectionB=$("<a target='_blank'></a>").append(item.paperName);
            var title=$("<h1 class='resource-title'></h1>").append(sectionB);
            var date=formatDate(item.submitTime);
            var hourandminute=formatDateHourAndMinute(item.submitTime);
            var abstract=$("<p class='resource-abstract'></p>").append("提交时间: "+date+" "+hourandminute+" 用时: "+item.doTime+"分");
            var start_time=item.startTime;
            var end_time=item.endTime;
            var now=new Date();
            var now_time=now.getTime();
            var footer=$("<div class='resource-footer'></div>");
            <%--var sectionC=$("<a class='layui-btn layui-btn-small layui-btn-primary' href='${APP_PATH}/thePaper?paperId="+item.id+"' target='_blank'>开始考试</a>")--%>

            //考试是否开始或者结束
            if(item.status==1)//未批改
            {
                var sectionC=$("<a class='layui-btn layui-btn-small layui-btn-primary'>未批改</a>")
                    .append($("<i class='fa fa-eye fa-fw'></i>"));
                sectionC.attr("inviCode",item.inviCode);
                var sectionD=$("<a class='layui-btn layui-btn-small layui-btn-primary' target='_blank'  href=\"${APP_PATH}/theSheetRecord?paperId="+item.paperId+"\">查看详情</a>")
                    .append($("<i class='fa fa-download fa-fw'></i>"));
            } else {//已批改
                var sectionC=$("<a class='layui-btn layui-btn-small layui-btn-primary' id='"+item.id+"'>已批改</a>")
                    .append($("<i class='fa fa-eye fa-fw'></i>"));
                sectionC.attr("inviCode",item.inviCode);
                var sectionD=$("<a class='layui-btn layui-btn-small layui-btn-primary' target='_blank'  href=\"${APP_PATH}/theScoreSheetRecord?sheetId="+item.id+"\">分数详情</a>")
                    .append($("<i class='fa fa-download fa-fw'></i>"));
            }

            footer.append(sectionC).append(sectionD);

            <%--var detailsection=$("<a></a>").append("详细");--%>
            <%--detailsection.attr("href","${APP_PATH}/section/thesection?sectionId="+item.sId);--%>

            $("<div class='resource shadow'></div>")//section
                .append(cover)
                .append(title)
                .append(abstract)
                .append(footer)
                .appendTo(".resource-main");
        });
        $(".resource-main").append($("<div class=\"clear\"></div>"));
    }

    $(function () {
        to_page(1);
        showNoReadCount();
    });
    function to_page(pn){
        $.ajax({
            data:{"pn":pn},
            url:"${APP_PATH}/findHasDone",
            type:"GET",
            success:function(result){
                buildPaperPage(result);
                //2.解析并且显示分页信息
                build_page_info(result);
                //3.分页条的显示
                build_page_nav(result);
            }
        });
    }
    function checkHasDoExam(paperId,userId){
        var inviCode=$(this).attr('inviCode');
        if(inviCode!=""){//参加这次考试需要邀请码
            $("#inviCodeModal").modal({
                backdrop:"static"
            });
        }else{
            window.open("${APP_PATH}/thePaper?paperId="+$(this).attr('id'));
        }
        $("#code_btn").click(function () {
            var code=$("#input_code").val();
            var paperId=parseInt($(this).attr("paperId"));
            // alert(paperId);
            $.ajax({
                data: {"paperId": paperId,"code":code},
                url: "${APP_PATH}/checkInviCode",
                async: false, //异步提交
                type: "post",
                success: function (result) {
                    if(result.code==200){
                        alert("输入的邀请码不正确，请重新输入！！！");
                        return false;
                    }else{
                        window.location.href="${APP_PATH}/thePaper?paperId="+paperId;
                        return true;
                    }
                }
            });
        });
    }
    $(document).on('click',".startExam",function (event){
        var paperId=$(this).attr('id');
        paperId=parseInt(paperId);
        $("#code_btn").attr("paperId",paperId);
        checkHasDoExam(paperId,${userid});
    });

    //解析显示分页信息
    function build_page_info(result){
        $("#page_info_area").empty();
        $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，" +
            "总共"+result.extend.pageInfo.pages+"页，" +
            "总共"+result.extend.pageInfo.total+"条记录");
        totalRecord=result.extend.pageInfo.total;
        currentPage=result.extend.pageInfo.pageNum;
    }
    //解析显示分页条，点击分页要去下一页
    function build_page_nav(result){
        $("#page_nav_area").empty();
        var ul=$("<ul><ul>").addClass("pagination");
        var firstPageLi=$("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi=$("<li></li>").append($("<a></a>").append("&laquo;"));
        if(result.extend.pageInfo.hasPreviousPage==false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //为元素添加翻页事件
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum-1);
            });
        }
        var nextPageLi=$("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi=$("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if(result.extend.pageInfo.hasNextPage==false){
            lastPageLi.addClass("disabled");
            nextPageLi.addClass("disabled");
        }else{
            //为元素添加翻页事件
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum+1);
            });
        }
        //添加首页和前一页的提示
        ul.append(firstPageLi).append(prePageLi);
        //遍历给ul中添加页码
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
            var numLi=$("<li></li>").append($("<a></a>").append(item));
            if(result.extend.pageInfo.pageNum==item){
                numLi.addClass("active");//高亮显示
            }
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        });
        //添加末页和下一页的提示
        ul.append(nextPageLi).append(lastPageLi);
        //把ul添加到nav中
        var navEle=$("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }
</script>
</body>
</html>
