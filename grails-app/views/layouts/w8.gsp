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

        <style type="text/css" media="screen">
        <g:if env="development">
            .navbar .navbar-inner {
                background-color: #ff5555;
            }
        </g:if>
        </style>

		<!--inline scripts related to this page-->
    	<g:layoutHead/>

        
	</head>

	<body>
        <g:applyLayout name="w8Navbar"></g:applyLayout>

		<div class="container-fluid" id="main-container">
			<a id="menu-toggler" href="#">
				<span></span>
			</a>

			<div id="sidebar">
                <!-- #sidebar-shortcuts icon 
				<div id="sidebar-shortcuts">
					<div id="sidebar-shortcuts-large">
						<button class="btn btn-small btn-success">
							<i class="icon-signal"></i>
						</button>

						<button class="btn btn-small btn-info">
							<i class="icon-pencil"></i>
						</button>

						<button class="btn btn-small btn-warning">
							<i class="icon-group"></i>
						</button>

						<button class="btn btn-small btn-danger">
							<i class="icon-cogs"></i>
						</button>
					</div>

					<div id="sidebar-shortcuts-mini">
						<span class="btn btn-success"></span>

						<span class="btn btn-info"></span>

						<span class="btn btn-warning"></span>

						<span class="btn btn-danger"></span>
					</div>
                </div>
                #sidebar-shortcuts icon -->

                <g:applyLayout name="w8NavList"></g:applyLayout>

				<div id="sidebar-collapse">
					<i class="icon-double-angle-left"></i>
				</div>
			</div>

			<div id="main-content" class="clearfix">
				<div id="breadcrumbs">
					<ul class="breadcrumb">
						<li>
							<i class="icon-home"></i>
                            <g:link controller="sys" action="home">Home</g:link>

							<span class="divider">
								<i class="icon-angle-right"></i>
							</span>
						</li>
						<li class="active">
                            ${pageProperty(name:'page.title')}
                        </li>
					</ul><!--.breadcrumb-->

                    <!-- #nav-search 
					<div id="nav-search">
						<form class="form-search">
							<span class="input-icon">
								<input type="text" placeholder="Search ..." class="input-small search-query" id="nav-search-input" autocomplete="off" />
								<i class="icon-search" id="nav-search-icon"></i>
							</span>
						</form>
                    </div>
                    #nav-search-->
				</div>

				<div id="page-content" class="clearfix">
					<div class="page-header position-relative">
						<h1>
							${pageProperty(name:'page.title')}
							<small>
								<i class="icon-double-angle-right"></i>
                                ${pageProperty(name:'page.subtitle')}
							</small>
						</h1>
					</div><!--/.page-header-->

					<div class="row-fluid">
						<!--PAGE CONTENT BEGINS HERE-->

                        <g:layoutBody/> 

						<!--PAGE CONTENT ENDS HERE-->
					</div><!--/row-->
				</div><!--/#page-content-->

				<div id="ace-settings-container">
                  <!--
					<div class="btn btn-app btn-mini btn-warning" id="ace-settings-btn">
						<i class="icon-cog"></i>
					</div>

					<div id="ace-settings-box">
						<div>
							<div class="pull-left">
								<select id="skin-colorpicker" class="hidden">
									<option data-class="default" value="#438EB9">#438EB9</option>
									<option data-class="skin-1" value="#222A2D">#222A2D</option>
									<option data-class="skin-2" value="#C6487E">#C6487E</option>
									<option data-class="skin-3" value="#D0D0D0">#D0D0D0</option>
								</select>
							</div>
							<span>&nbsp; Choose Skin</span>
						</div>

						<div>
							<input type="checkbox" class="ace-checkbox-2" id="ace-settings-header" />
							<label class="lbl" for="ace-settings-header"> Fixed Header</label>
						</div>

						<div>
							<input type="checkbox" class="ace-checkbox-2" id="ace-settings-sidebar" />
							<label class="lbl" for="ace-settings-sidebar"> Fixed Sidebar</label>
						</div>
					</div>
                  -->
				</div><!--/#ace-settings-container-->
			</div><!--/#main-content-->
		</div><!--/.fluid-container#main-container-->

		<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
			<i class="icon-double-angle-up icon-only bigger-110"></i>
		</a>

	</body>
</html>
