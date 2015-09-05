<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>iwill 爱维尔</title>
    <!-- Bootstrap Core CSS - Uses Bootswatch Flatly Theme: http://bootswatch.com/flatly/ -->
    <link href="/imis/bower_components/startbootstrap-freelancer/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="/imis/bower_components/startbootstrap-freelancer/css/freelancer.css" rel="stylesheet">
    <!-- Custom Fonts -->
    <link href="/imis/bower_components/startbootstrap-freelancer/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="/imis/bower_components/startbootstrap-freelancer/js/jquery.js"></script>
    <!-- Bootstrap Core JavaScript -->
    <script src="/imis/bower_components/startbootstrap-freelancer/js/bootstrap.min.js"></script>
</head>

<body id="page-top" class="index">
    <!-- Header -->
    <header>
        <div class="container" style="padding-top: 60px; padding-bottom: 60px;">
            <div class="row">
                <img class="img-responsive" src="/imis/mooncake/${pno}.jpg" style="margin-bottom: 0px;" alt="">
            </div>
        </div>
    </header>
    <g:if test="${!express}">
        <!-- Contact Section -->
        <section id="contact">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 text-center">
                        <h2>收货信息</h2>
                        <hr class="star-primary">
                    </div>
                </div>

                <g:if test="${flash.msg}">
                    <div class='alert alert-info'>
                      <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>
                      <strong>${flash.msg}</strong>
                    </div>
                </g:if>
                
                <div class="row">
                    <div class="col-lg-8 col-lg-offset-2">
                        <form name="sentMessage" id="contactForm" novalidate>
                            <div class="row control-group">
                                <div class="form-group col-xs-12 floating-label-form-group controls">
                                    <label>收件人</label>
                                    <input type="text" class="form-control" placeholder="例：王先生" id="name" name="name" required data-validation-required-message="请输入收件人名称" value="${name}">
                                    <p class="help-block text-danger"></p>
                                </div>
                            </div>
                            <div class="row control-group">
                                <div class="form-group col-xs-12 floating-label-form-group controls">
                                    <label>联系电话</label>
                                    <input type="tel" class="form-control" placeholder="例:18112345678" id="phone" name="phone" required data-validation-required-message="请输入联系电话" value="${phone}">
                                    <p class="help-block text-danger"></p>
                                </div>
                            </div>
                            <div class="row control-group">
                                <div class="form-group col-xs-12 floating-label-form-group controls">
                                    <label>送货地址</label>
                                    <textarea rows="5" class="form-control" placeholder="（限江浙沪皖）例：苏州市石湖西路159号" id="address" name="address" required data-validation-required-message="请输入送货地址">${address}</textarea>
                                    <p class="help-block text-danger"></p>
                                </div>
                            </div>

                            <br>
                            <div id="success"></div>
                            <div class="row">
                                <div class="form-group col-xs-12">
                                    <input type="hidden" name="code" value="${vid}" /><br/>
                                    <input type="hidden" name="pno" value="${pno}" /><br/>
                                    <button type="submit" name="act" value="兑换" class="btn btn-success btn-lg">
                                        <g:if test="${!name}">
                                            兑换
                                        </g:if>
                                        <g:else>
                                            更新信息
                                        </g:else>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </g:if>
    <g:else>
        <section id="contact">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 text-center">
                        <h2>快递信息</h2>
                        <hr class="star-primary">
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-8 col-lg-offset-2">
                        <table class="table">
                            <tr>
                                <td>
                                    <img src="/imis/images/logoSF.png" alt="">
                                </td>
                                <td style="text-align: right;">
                                    <h5>快递单号：${express}</h5>
                                </td>
                            </tr>
                        </table>
                        <table class="table table-striped">
                            <tr>
                                <th>时间</th>
                                <th>记录</th>
                            </tr>
                            <g:each in="${einfo['result']['list']}" status="i" var="it">
                                <tr>
                                    <td>${it.datetime}</td> 
                                    <td>${it.remark}</td<
                                </tr>
                            </g:each>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </g:else>

    <!-- Footer -->
    <footer class="text-center">
        <div class="footer-above">
            <div class="container">
                <div class="row">
                    <div class="footer-col col-md-12">
                        <h3>注意事项</h3>
                        <p>爱维尔未处理订单前都可扫码更改地址.</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-below">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        Copyright &copy; iwill 2015
                    </div>
                </div>
            </div>
        </div>
    </footer>
    <!-- Contact Form JavaScript -->
    <script src="/imis/bower_components/startbootstrap-freelancer/js/jqBootstrapValidation.js"></script>
    <script src="/imis/mooncake/mooncake.js?v=3"></script>
</body>

</html>

