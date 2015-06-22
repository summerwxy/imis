<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title><g:layoutTitle default="爱维尔"/></title>

    <!-- Bootstrap Core CSS - Uses Bootswatch Flatly Theme: http://bootswatch.com/flatly/ -->
    <link href="${resource(dir: 'bower_components/startbootstrap-freelancer/css', file: 'bootstrap.min.css')}" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="${resource(dir: 'bower_components/startbootstrap-freelancer/css', file: 'freelancer.css')}" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="${resource(dir: 'bower_components/startbootstrap-freelancer/font-awesome/css', file: 'font-awesome.min.css')}" rel="stylesheet">


    <!-- jQuery -->
    <script src="${resource(dir: 'bower_components/startbootstrap-freelancer/js', file: 'jquery.js')}"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="${resource(dir: 'bower_components/startbootstrap-freelancer/js', file: 'bootstrap.min.js')}"></script>

    <!-- Plugin JavaScript -->
    <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
    <script src="${resource(dir: 'bower_components/startbootstrap-freelancer/js', file: 'classie.js')}"></script>
    <script src="${resource(dir: 'bower_components/startbootstrap-freelancer/js', file: 'cbpAnimatedHeader.js')}"></script>

    <!-- g layoutHead -->
	<g:layoutHead/>    
</head>

<body id="page-top" class="index">

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container">
            <div class="navbar-header page-scroll">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#page-top"></a>
            </div>

            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li class="hidden">
                        <a href="#page-top"></a>
                    </li>
                    <li class="page-scroll">
                        <a href="/imis/wechat/my">我的爱维尔</a>
                    </li>
                    <li class="page-scroll">
                        <a href="/imis/wechat/unbind">取消绑定</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <br/>
    <br/>
    <br/>

    <!-- g layoutBody -->
    <g:layoutBody/>


</body>

</html>
