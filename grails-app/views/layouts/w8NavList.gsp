<ul class="nav nav-list">
<!-- 功能清单 -->
<li class="active">
    <a href="#" class="dropdown-toggle">
        <i class="icon-list"></i>
        <span>功能菜单</span>
        <b class="arrow icon-angle-down"></b>
    </a>
    <ul class="submenu">
        <li>
            <g:link controller="calendar" action="index">
                <i class="icon-double-angle-right"></i>
                会议安排
            </g:link>
        </li>    
        <li>
            <g:link controller="xout" action="page1">
                <i class="icon-double-angle-right"></i>
                [送货上门]出货单明细
            </g:link>
        </li>
        <!--
        <li>
            <g:link controller="market" action="list_mooncake">
                <i class="icon-double-angle-right"></i>
                节庆快递（邮寄版）
            </g:link>
        </li>
        -->
        <li>
            <g:link controller="market" action="list_mooncake2">
                <i class="icon-double-angle-right"></i>
                节庆快递（顺丰提货版）
            </g:link>
        </li>
        <li>
            <g:link controller="market" action="express_update">
                <i class="icon-double-angle-right"></i>
                节庆快递（单号更新）
            </g:link>
        </li>
        
        <li>
            <g:link controller="market" action="express_map">
                <i class="icon-double-angle-right"></i>
                节庆快递（地图）
            </g:link>
        </li>
        <!--
        <li>
            <g:link controller="qyZqlh" action="console">
                <i class="icon-double-angle-right"></i>
                微信订单
            </g:link>
        </li>
        <li>
            <g:link controller="pos" action="f2">
                <i class="icon-double-angle-right"></i>
                门店营业模式设定
            </g:link>
        </li>
        -->
        <li>
            <g:link controller="pos" action="f1">
                <i class="icon-double-angle-right"></i>
                回收券检查
            </g:link>
        </li>
        <!--
        <li>
            <g:link controller="mm" action="page1">
                <i class="icon-double-angle-right"></i>
                称重
            </g:link>
        </li>
        -->
        <li>
            <g:link controller="xout" action="page3">
                <i class="icon-double-angle-right"></i>
                发货异常处理
            </g:link>
        </li>
        <li>
            <g:link controller="sys" action="lock_table">
                <i class="icon-double-angle-right"></i>
                运行中作业
            </g:link>
        </li>
    </ul>
</li>

<li class="active">
    <a href="#" class="dropdown-toggle">
        <i class="icon-search"></i>
        <span>查资料</span>
        <b class="arrow icon-angle-down"></b>
    </a>
    <ul class="submenu">
        <li>
            <g:link controller="pos" action="store">
                <i class="icon-double-angle-right"></i>
                门店查询
            </g:link>
        </li>
        <li>
            <g:link controller="pos" action="part">
                <i class="icon-double-angle-right"></i>
                物料查询
            </g:link>
        </li>
        <li>
            <g:link controller="pos" action="pos_6l">
                <i class="icon-double-angle-right"></i>
                6L 产品异动明细表
            </g:link>
        </li>
        <li>
            <g:link controller="pos" action="pos_1v">
                <i class="icon-double-angle-right"></i>
                1V 门市产品模板
            </g:link>
        </li>
    </ul>    
</li>


<li class="active">
    <a href="#" class="dropdown-toggle">
        <i class="icon-fire"></i>
        <span>POS 功能</span>
        <b class="arrow icon-angle-down"></b>
    </a>
    <ul class="submenu">
        <li>
            <g:link controller="pos" action="ann">
                <i class="icon-double-angle-right"></i>
                签报单管理
            </g:link>
        </li>
        <li>
            <g:link controller="pos" action="refund">
                <i class="icon-double-angle-right"></i>
                单品退货管理
            </g:link>
        </li>
        <li>
            <g:link controller="hr" action="page1">
                <i class="icon-double-angle-right"></i>
                POS考勤查询
            </g:link>
        </li>
        <!--
        <li>
            <g:link controller="pos" action="adimg">
                <i class="icon-double-angle-right"></i>
                客显图片
            </g:link>
        </li>
        -->
        <li>
            <g:link controller="fi" action="allot">
                <i class="icon-double-angle-right"></i>
                拆帐
            </g:link>
        </li>
        <!--
        <li>
            <g:link controller="xout" action="page2">
                <i class="icon-double-angle-right"></i>
                发货
            </g:link>
        </li>
        -->
    </ul>    
</li>


<li>
    <a href="#" class="dropdown-toggle">
        <i class="icon-globe"></i>
        <span>Test Pages</span>
        <b class="arrow icon-angle-down"></b>
    </a>
    <ul class="submenu">
        <li>
            <g:link controller="pos" action="ann_pos">
                <i class="icon-double-angle-right"></i>
                POS前台网址
            </g:link>
        </li>
        <li>
            <g:link controller="test" action="d3">
                <i class="icon-double-angle-right"></i>
                D3
            </g:link>
        </li>    
        <li>
            <g:link controller="test" action="welcome">
                <i class="icon-double-angle-right"></i>
                Welcome to Grails
            </g:link>
        </li>
        <li>
            <g:link controller="test" action="sample1">
                <i class="icon-double-angle-right"></i>
                Sample 1
            </g:link>
        </li>
        <li>
            <g:link controller="test" action="sample2">
                <i class="icon-double-angle-right"></i>
                Sample 2
            </g:link>
        </li>
        <li>
            <g:link controller="test" action="ng">
                <i class="icon-double-angle-right"></i>
                Angular
            </g:link>
        </li>
        <li>
            <g:link controller="test" action="map">
                <i class="icon-double-angle-right"></i>
                Map
            </g:link>
        </li>
        <li>
            <g:link controller="iwillData1" action="list">
                <i class="icon-double-angle-right"></i>
                送货司机基本资料
            </g:link>
        </li>
        <li>
            <g:link controller="ticket" action="i2014NewYear">
                <i class="icon-double-angle-right"></i>
                2014年礼提货
            </g:link>
        </li>
        <li>
            <g:link controller="sales" action="page1">
                <i class="icon-double-angle-right"></i>
                门店业绩上传
            </g:link>
        </li>
        <li>
            <g:link controller="qyZqlh" action="syncWxcpUser">
                <i class="icon-double-angle-right"></i>
                同步企业号用户
            </g:link>
        </li>
        <li>
            <g:link controller="remind" action="list">
                <i class="icon-double-angle-right"></i>
                证件提醒
            </g:link>
        </li>        
    </ul>    
</li>


<!-- 
<li>
    <a href="index.html">
        <i class="icon-dashboard"></i>
        <span>Dashboard</span>
    </a>
</li>

<li>
    <a href="typography.html">
        <i class="icon-text-width"></i>
        <span>Typography</span>
    </a>
</li>

<li>
    <a href="#" class="dropdown-toggle">
        <i class="icon-desktop"></i>
        <span>UI Elements</span>

        <b class="arrow icon-angle-down"></b>
    </a>

    <ul class="submenu">
        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Elements
            </a>
        </li>

        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Buttons &amp; Icons
            </a>
        </li>

        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Treeview
            </a>
        </li>
    </ul>
</li>

<li>
    <a href="#">
        <i class="icon-list"></i>
        <span>Tables</span>
    </a>
</li>

<li>
    <a href="#" class="dropdown-toggle">
        <i class="icon-edit"></i>
        <span>Forms</span>

        <b class="arrow icon-angle-down"></b>
    </a>

    <ul class="submenu">
        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Form Elements
            </a>
        </li>

        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Wizard &amp; Validation
            </a>
        </li>

        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Wysiwyg &amp; Markdown
            </a>
        </li>
    </ul>
</li>

<li>
    <a href="#">
        <i class="icon-list-alt"></i>
        <span>Widgets</span>
    </a>
</li>

<li>
    <a href="#">
        <i class="icon-calendar"></i>
        <span>Calendar</span>
    </a>
</li>

<li>
    <a href="#">
        <i class="icon-picture"></i>
        <span>Gallery</span>
    </a>
</li>

<li>
    <a href="#">
        <i class="icon-th"></i>
        <span>Grid</span>
    </a>
</li>

<li>
    <a href="#" class="dropdown-toggle">
        <i class="icon-file"></i>
        <span>Other Pages</span>

        <b class="arrow icon-angle-down"></b>
    </a>

    <ul class="submenu">
        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Pricing Tables
            </a>
        </li>

        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Invoice
            </a>
        </li>

        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Login &amp; Register
            </a>
        </li>

        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Error 404
            </a>
        </li>

        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Error 500
            </a>
        </li>

        <li>
            <a href="#">
                <i class="icon-double-angle-right"></i>
                Blank Page
            </a>
        </li>
    </ul>
</li>
-->
</ul><!--/.nav-list-->
