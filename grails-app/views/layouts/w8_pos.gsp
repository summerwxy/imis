<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
        <title><g:layoutTitle default="iwill 爱维尔"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />

		<!--basic styles-->

		<link href="${resource(dir: 'bootstrap/css', file: 'bootstrap.min.css')}" rel="stylesheet" />
		<link href="${resource(dir: 'bootstrap/css', file: 'bootstrap-responsive.min.css')}" rel="stylesheet" />
		<link rel="stylesheet" href="${resource(dir: 'themes/font-awesome/css', file: 'font-awesome.min.css')}" />

		<!--[if IE 7]>
		  <link rel="stylesheet" href="${resource(dir: 'themes/font-awesome/css', file: 'font-awesome-ie7.min.css')}" />
		<![endif]-->

		<!--page specific plugin styles-->

		<link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'prettify.css')}" />

		<!--fonts-->

		<!-- link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:400,300" / -->

		<!--ace styles-->

		<link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'w8.min.css')}" />
		<link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'w8-responsive.min.css')}" />
		<link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'w8-skins.min.css')}" />

		<!--[if lte IE 8]>
		  <link rel="stylesheet" href="themes/css/ace-ie.min.css" />
		<![endif]-->

		<!--inline styles if any-->
		<link rel="stylesheet" href="${resource(dir: 'bower_components/jquery-ui/themes/smoothness', file: 'jquery-ui.min.css')}" />
		

		<!--basic scripts-->
        
        <!--[if lt IE 9]>
		<script src="${resource(dir: 'bower_components/jquery-legacy', file: 'jquery.min.js')}"></script>
        <![endif]-->

		<script src="${resource(dir: 'bower_components/jquery/dist', file: 'jquery.min.js')}"></script>

		<script src="${resource(dir: 'bootstrap/js', file: 'bootstrap.min.js')}"></script>
		<script src="${resource(dir: 'bower_components/jquery-ui', file: 'jquery-ui.min.js')}"></script>
		<script src="${resource(dir: 'themes/js', file: 'jquery.ui.touch-punch.min.js')}"></script>
		
		<script src="${resource(dir: 'themes/js', file: 'jquery.slimscroll.min.js')}"></script>
		<script src="${resource(dir: 'themes/js', file: 'jquery.easy-pie-chart.min.js')}"></script>
		<script src="${resource(dir: 'themes/js', file: 'jquery.sparkline.min.js')}"></script>
		
		<script src="${resource(dir: 'themes/js', file: 'jquery.flot.min.js')}"></script>
		<script src="${resource(dir: 'themes/js', file: 'jquery.flot.pie.min.js')}"></script>
		<script src="${resource(dir: 'themes/js', file: 'jquery.flot.resize.min.js')}"></script>

		<!--w8 scripts-->

		<script src="${resource(dir: 'themes/js', file: 'w8-elements.min.js')}"></script>
		<script src="${resource(dir: 'themes/js', file: 'w8.min.js')}"></script>

        <!--bootstrap-datetimepicker-->
        <link rel="stylesheet" href="${resource(dir: 'bootstrap-datetimepicker/css', file: 'datetimepicker.css')}" />
        <script src="${resource(dir: 'bootstrap-datetimepicker/js', file: 'bootstrap-datetimepicker.min.js')}"></script>
        <script src="${resource(dir: 'bootstrap-datetimepicker/js/locales', file: 'bootstrap-datetimepicker.zh-CN.js')}"></script>

        <!-- chosen -->
        <link rel="stylesheet" href="${resource(dir: 'js/chosen_v1.0.0', file: 'chosen.min.css')}" />
        <script src="${resource(dir: 'js/chosen_v1.0.0', file: 'chosen.jquery.min.js')}"></script>

        <!-- ScrollToFixed -->
        <script src="${resource(dir: 'js', file: 'jquery-scrolltofixed-min.js')}"></script>

        <!-- my scripts -->
        <script src="${resource(dir: 'js', file: 'underscore-min.js')}"></script>

		<!--inline scripts related to this page-->
    	<g:layoutHead/>

        <style type="text/css" media="screen">
        #links a {
            font-size: 20px;
            font-weight: bold;
            text-decoration: underline;
        }

        <g:if env="development">
            .navbar .navbar-inner {
                background-color: #ff5555;
            }
        </g:if>

        </style>

	</head>

	<body>
        <g:applyLayout name="w8Navbar_pos"></g:applyLayout>

		<div class="container-fluid" id="main-container">

			<div id="main-content-dummy" class="clearfix">
				<div id="breadcrumbs">

					<div class="row-fluid">
                        <div class="span10 offset1" id="links">
                            <g:link controller="pos" action="ann_pos">签报单</g:link>
                            |
                            <g:link controller="pos" action="refund_pos">门店单品项退货明细</g:link>
                            |
                            <g:link controller="pos" action="r1_pos">销售与退货</g:link>
                        </div>
                    </div>

				</div>

				<div id="page-content" class="clearfix">

					<div class="row-fluid">
                        <div class="span10 offset1">
                            <h1>${pageProperty(name:'page.title')}</h1>
                            <h5>${pageProperty(name:'page.subtitle')}</h5>
                        </div>

						<!--PAGE CONTENT BEGINS HERE-->

                        <g:layoutBody/> 

						<!--PAGE CONTENT ENDS HERE-->
					</div><!--/row-->
				</div><!--/#page-content-->

				<div id="ace-settings-container">

				</div><!--/#ace-settings-container-->
			</div><!--/#main-content-->
		</div><!--/.fluid-container#main-container-->

		<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
			<i class="icon-double-angle-up icon-only bigger-110"></i>
		</a>

	</body>
</html>
