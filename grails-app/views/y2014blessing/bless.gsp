<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <link rel="stylesheet" href="${resource(dir: 'bootstrap-datetimepicker/css', file: 'datetimepicker.css')}" />
    <style>
    .hide {
        display: none;
    }
    </style> 
    <script type="text/javascript">
    $(function() {
        $('#lights').on('click', 'a', function() {
            $('#lights i').hide();
            var tar = $(this);
            tar.parent().find('i').show();
            var n = tar.attr('href').substr(1);
            $('#light').val(n);
            return false;
        });

        $('#theForm').submit(function() {
            var pray = $('#pray').val();
            var someone = $('#someone').val();
            var light = $('#light').val();
            var content = $('#content').val();
            if (!pray || !someone || !light || !content) {
                alert('請把資料全部填上!');
                return false;    
            }
        });

        // close sidebar
        $('#sidebar').addClass('menu-min');
    });

    </script>
</head>
<content tag="title">线上祈福</content>
<content tag="subtitle">2014祈福</content>
<body>

<div class="span2"></div>
<div class="span8">
    <form id="theForm" method="POST">
        <table>
            <tr><td>祈福人/Sender：</td></tr>
            <tr><td><input type="text" id="pray" name="pray"/></td></tr>
            <tr><td>祈福對象/Recipient：</td></tr>
            <tr><td><input type="text" id="someone" name="someone"/></td></tr>
            <tr><td>祈福種類/Choose a blessing：</td></tr>
            <tr>
                <td>
                    <ul id="lights">
                        <li class="span2" style="text-align: center;">
                            <i class="icon-ok green hide"></i><br/>
                            <a href="#jx">
                                <img src="${resource(dir: '2014blessing', file: 'jx.png')}" alt="吉祥" />
                            </a>
                        </li>
                        <li class="span2" style="text-align: center;">
                            <i class="icon-ok green hide"></i><br/>
                            <a href="#fh">
                                <img src="${resource(dir: '2014blessing', file: 'fh.png')}" alt="福慧" />
                            </a>
                        </li>
                        <li class="span2" style="text-align: center;">
                            <i class="icon-ok green hide"></i><br/>
                            <a href="#pa">
                                <img src="${resource(dir: '2014blessing', file: 'pa.png')}" alt="平安" />
                            </a>
                        </li>
                        <li class="span2" style="text-align: center;">
                            <i class="icon-ok green hide"></i><br/>
                            <a href="#gm">
                                <img src="${resource(dir: '2014blessing', file: 'gm.png')}" alt="光明" />
                            </a>
                        </li>
                        <li class="span2" style="text-align: center;">
                            <i class="icon-ok green hide"></i><br/>
                            <a href="#fg">
                                <img src="${resource(dir: '2014blessing', file: 'fg.png')}" alt="富貴" />
                            </a>
                        </li>
                    </ul> 
                </td>
            </tr>
            <tr><td>祈願內容/Description：</td></tr>
            <tr><td><textarea rows="4" cols="40" id="content" name="content"></textarea></td></tr>
            <tr>
                <td>
                    <input id="light" name="light" type="hidden"/>
                    <input type="image" src="${resource(dir: '2014blessing', file: 'submitbtn.png')}" alt="Submit Form"/>
                </td>
            </tr>
        </table>
    </form>
</div>
<div class="span2"></div>

</body>
</html>
