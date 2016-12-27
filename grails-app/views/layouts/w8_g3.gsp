<!DOCTYPE html>
<html lang="en">
	<head>
        <meta property="qc:admins" content="1117065601464317144637571513" />
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
		

		<link rel="stylesheet" href="${resource(dir: 'bower_components/selectize/dist/css', file: 'selectize.bootstrap2.css')}" />

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
        <script src="${resource(dir: 'bower_components/microplugin/src', file: 'microplugin.js')}"></script>
        <script src="${resource(dir: 'bower_components/sifter', file: 'sifter.min.js')}"></script>
        <script src="${resource(dir: 'bower_components/selectize/dist/js', file: 'selectize.min.js')}"></script>

		<!--inline scripts related to this page-->
    	<g:layoutHead/>
	</head>

	<body>
        <g:if env="development">
          <div style="background-color: #ff5555;" onclick="$(this).hide();">DEV MODE</div>
        </g:if>
        <g:layoutBody/> 
	</body>
</html>
