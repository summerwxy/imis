<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">
    th {
        white-space: nowrap;
        text-align: center;
    }
    td {
        text-align: right!important;
    }
    </style>
    <script type="text/javascript">
    $(function() {
        // datetimepicker
        $('.form_datetime').datetimepicker({
            language:  'zh-CN',
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            minView: 2,
            forceParse: 0
        });
    })    
    </script>
</head>
<content tag="title">拆帐</content>
<content tag="subtitle">....</content>
<body>
<div class="row">
    <div class="span2 offset5">
        <g:if test="${msg}">
            <p class="text-success lead">${msg} </p>
        </g:if>
    </div>
</div>

<div class="row">
    <div class="span10 offset1">
        <form class="form-horizontal" method="POST" action="allot">
            <div class="control-group">
                <label class="control-label" for="store_no">门店</label>
                <div class="controls">
                    <select class="form-control" name="store_no" id="store_no">
                        <g:each in="${storeList}" var="s">
                            <g:if test="${params.store_no == s.S_NO}">
                                <option value="${s.S_NO}" selected="selected">${s.S_NO} ${s.S_NAME}</option>
                            </g:if>
                            <g:else>
                                <option value="${s.S_NO}">${s.S_NO} ${s.S_NAME}</option>
                            </g:else>
                        </g:each> 
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="sDate">开始日期</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="sDate" class="input-small" type="text" value="${params.sDate?params.sDate: '2015/01/15'}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <label class="control-label" for="eDate">结束日期</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="eDate" class="input-small" type="text" value="${params.eDate?params.eDate:'2015/01/20'}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <div class="controls">
                    <button type="submit" name="q" value="true" class="btn btn-primary">查询</button>
                </div>
            </div>
        </form>    
    </div>
</div>


<div class="row">
    <div class="span10 offset1">
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th rowspan="2">日期</th>
                    <th colspan="7">进货</th>
                    <g:each in="${spList}" var="sp">
                        <th rowspan="2">特殊结算-${sp}</th>
                    </g:each>
                    <th colspan="7">生产</th>
                    <g:each in="${spList}" var="sp">
                        <th rowspan="2">特殊结算-${sp}</th>
                    </g:each>
                    <th colspan="7">拨入</th>
                    <g:each in="${spList}" var="sp">
                        <th rowspan="2">特殊结算-${sp}</th>
                    </g:each>
                    <th colspan="7">拨出</th>
                    <g:each in="${spList}" var="sp">
                        <th rowspan="2">特殊结算-${sp}</th>
                    </g:each>
                    <th colspan="7">退货</th>
                    <g:each in="${spList}" var="sp">
                        <th rowspan="2">特殊结算-${sp}</th>
                    </g:each>

                    <th colspan="6">券、卡</th>
                </tr>
                <tr>
                    <th>${iwill.AllotDao.prType['01']}</th>
                    <th>${iwill.AllotDao.prType['02']}</th>
                    <th>${iwill.AllotDao.prType['03']}</th>
                    <th>${iwill.AllotDao.prType['04']}</th>
                    <th>${iwill.AllotDao.prType['05']}</th>
                    <th>${iwill.AllotDao.prType['06']}</th>
                    <th>其它</th>

                    <th>${iwill.AllotDao.prType['01']}</th>
                    <th>${iwill.AllotDao.prType['02']}</th>
                    <th>${iwill.AllotDao.prType['03']}</th>
                    <th>${iwill.AllotDao.prType['04']}</th>
                    <th>${iwill.AllotDao.prType['05']}</th>
                    <th>${iwill.AllotDao.prType['06']}</th>
                    <th>其它</th>

                    <th>${iwill.AllotDao.prType['01']}</th>
                    <th>${iwill.AllotDao.prType['02']}</th>
                    <th>${iwill.AllotDao.prType['03']}</th>
                    <th>${iwill.AllotDao.prType['04']}</th>
                    <th>${iwill.AllotDao.prType['05']}</th>
                    <th>${iwill.AllotDao.prType['06']}</th>
                    <th>其它</th>

                    <th>${iwill.AllotDao.prType['01']}</th>
                    <th>${iwill.AllotDao.prType['02']}</th>
                    <th>${iwill.AllotDao.prType['03']}</th>
                    <th>${iwill.AllotDao.prType['04']}</th>
                    <th>${iwill.AllotDao.prType['05']}</th>
                    <th>${iwill.AllotDao.prType['06']}</th>
                    <th>其它</th>

                    <th>${iwill.AllotDao.prType['01']}</th>
                    <th>${iwill.AllotDao.prType['02']}</th>
                    <th>${iwill.AllotDao.prType['03']}</th>
                    <th>${iwill.AllotDao.prType['04']}</th>
                    <th>${iwill.AllotDao.prType['05']}</th>
                    <th>${iwill.AllotDao.prType['06']}</th>
                    <th>其它</th>

                    <th>进货</th>
                    <th>充值</th>
                    <th>生产</th>
                    <th>拨入</th>
                    <th>拨出</th>
                    <th>退货</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${dateList}" status="i" var="it">
                    <tr>
                        <td>${iwill._.dateStringAddSlash(it)}</td> 

                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=01&data=ins1">${iwill._.numberFormat(insList1[it]['01'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=02&data=ins1">${iwill._.numberFormat(insList1[it]['02'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=03&data=ins1">${iwill._.numberFormat(insList1[it]['03'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=04&data=ins1">${iwill._.numberFormat(insList1[it]['04'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=05&data=ins1">${iwill._.numberFormat(insList1[it]['05'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=06&data=ins1">${iwill._.numberFormat(insList1[it]['06'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=others&data=ins1">${iwill._.numberFormat(insList1[it]['others'])}</a></td>
                        <g:each in="${spList}" var="sp">
                            <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=special&data=ins2&sp=${sp}">${iwill._.numberFormat(insList2[it][sp])}</a></td>
                        </g:each> 

                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=01&data=stor1">${iwill._.numberFormat(storList1[it]['01'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=02&data=stor1">${iwill._.numberFormat(storList1[it]['02'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=03&data=stor1">${iwill._.numberFormat(storList1[it]['03'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=04&data=stor1">${iwill._.numberFormat(storList1[it]['04'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=05&data=stor1">${iwill._.numberFormat(storList1[it]['05'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=06&data=stor1">${iwill._.numberFormat(storList1[it]['06'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=others&data=stor1">${iwill._.numberFormat(storList1[it]['others'])}</a></td>
                        <g:each in="${spList}" var="sp">
                            <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=special&data=stor2&sp=${sp}">${iwill._.numberFormat(storList2[it][sp])}</a></td>
                        </g:each> 

                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=01&data=trIn1">${iwill._.numberFormat(trInList1[it]['01'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=02&data=trIn1">${iwill._.numberFormat(trInList1[it]['02'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=03&data=trIn1">${iwill._.numberFormat(trInList1[it]['03'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=04&data=trIn1">${iwill._.numberFormat(trInList1[it]['04'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=05&data=trIn1">${iwill._.numberFormat(trInList1[it]['05'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=06&data=trIn1">${iwill._.numberFormat(trInList1[it]['06'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=others&data=trIn1">${iwill._.numberFormat(trInList1[it]['others'])}</a></td>
                        <g:each in="${spList}" var="sp">
                            <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=special&data=trIn2&sp=${sp}">${iwill._.numberFormat(trInList2[it][sp])}</a></td>
                        </g:each> 

                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=01&data=trOut1">${iwill._.numberFormat(trOutList1[it]['01'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=02&data=trOut1">${iwill._.numberFormat(trOutList1[it]['02'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=03&data=trOut1">${iwill._.numberFormat(trOutList1[it]['03'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=04&data=trOut1">${iwill._.numberFormat(trOutList1[it]['04'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=05&data=trOut1">${iwill._.numberFormat(trOutList1[it]['05'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=06&data=trOut1">${iwill._.numberFormat(trOutList1[it]['06'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=others&data=trOut1">${iwill._.numberFormat(trOutList1[it]['others'])}</a></td>
                        <g:each in="${spList}" var="sp">
                            <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=special&data=trOut2&sp=${sp}">${iwill._.numberFormat(trOutList2[it][sp])}</a></td>
                        </g:each> 

                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=01&data=back1">${iwill._.numberFormat(backList1[it]['01'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=02&data=back1">${iwill._.numberFormat(backList1[it]['02'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=03&data=back1">${iwill._.numberFormat(backList1[it]['03'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=04&data=back1">${iwill._.numberFormat(backList1[it]['04'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=05&data=back1">${iwill._.numberFormat(backList1[it]['05'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=06&data=back1">${iwill._.numberFormat(backList1[it]['06'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=others&data=back1">${iwill._.numberFormat(backList1[it]['others'])}</a></td>
                        <g:each in="${spList}" var="sp">
                            <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=special&data=back2&sp=${sp}">${iwill._.numberFormat(backList2[it][sp])}</a></td>
                        </g:each> 

                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=07&data=ins1">${iwill._.numberFormat(insList1[it]['07'])}</a></td>
                        <th>${iwill._.numberFormat(rechargeList[it])}</th>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=07&data=stor1">${iwill._.numberFormat(storList1[it]['07'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=07&data=trIn1">${iwill._.numberFormat(trInList1[it]['07'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=07&data=trOut1">${iwill._.numberFormat(trOutList1[it]['07'])}</a></td>
                        <td><a href="allotDetail?sno=${params.store_no}&date=${it}&catg=07&data=back1">${iwill._.numberFormat(backList1[it]['07'])}</a></td>

                    </tr>
                </g:each>             
                <g:if test="${insList1['total']}">
                    <tr>
                        <td>合计</td> 

                        <td>${iwill._.numberFormat(insList1['total']['01'])}</td>
                        <td>${iwill._.numberFormat(insList1['total']['02'])}</td>
                        <td>${iwill._.numberFormat(insList1['total']['03'])}</td>
                        <td>${iwill._.numberFormat(insList1['total']['04'])}</td>
                        <td>${iwill._.numberFormat(insList1['total']['05'])}</td>
                        <td>${iwill._.numberFormat(insList1['total']['06'])}</td>
                        <td>${iwill._.numberFormat(insList1['total']['others'])}</td>
                        <g:each in="${spList}" var="sp">
                            <td>${iwill._.numberFormat(insList2['total'][sp])}</td>
                        </g:each> 

                        <td>${iwill._.numberFormat(storList1['total']['01'])}</td>
                        <td>${iwill._.numberFormat(storList1['total']['02'])}</td>
                        <td>${iwill._.numberFormat(storList1['total']['03'])}</td>
                        <td>${iwill._.numberFormat(storList1['total']['04'])}</td>
                        <td>${iwill._.numberFormat(storList1['total']['05'])}</td>
                        <td>${iwill._.numberFormat(storList1['total']['06'])}</td>
                        <td>${iwill._.numberFormat(storList1['total']['others'])}</td>
                        <g:each in="${spList}" var="sp">
                            <td>${iwill._.numberFormat(storList2['total'][sp])}</td>
                        </g:each> 

                        <td>${iwill._.numberFormat(trInList1['total']['01'])}</td>
                        <td>${iwill._.numberFormat(trInList1['total']['02'])}</td>
                        <td>${iwill._.numberFormat(trInList1['total']['03'])}</td>
                        <td>${iwill._.numberFormat(trInList1['total']['04'])}</td>
                        <td>${iwill._.numberFormat(trInList1['total']['05'])}</td>
                        <td>${iwill._.numberFormat(trInList1['total']['06'])}</td>
                        <td>${iwill._.numberFormat(trInList1['total']['others'])}</td>
                        <g:each in="${spList}" var="sp">
                            <td>${iwill._.numberFormat(trInList2['total'][sp])}</td>
                        </g:each> 

                        <td>${iwill._.numberFormat(trOutList1['total']['01'])}</td>
                        <td>${iwill._.numberFormat(trOutList1['total']['02'])}</td>
                        <td>${iwill._.numberFormat(trOutList1['total']['03'])}</td>
                        <td>${iwill._.numberFormat(trOutList1['total']['04'])}</td>
                        <td>${iwill._.numberFormat(trOutList1['total']['05'])}</td>
                        <td>${iwill._.numberFormat(trOutList1['total']['06'])}</td>
                        <td>${iwill._.numberFormat(trOutList1['total']['others'])}</td>
                        <g:each in="${spList}" var="sp">
                            <td>${iwill._.numberFormat(trOutList2['total'][sp])}</td>
                        </g:each> 

                        <td>${iwill._.numberFormat(backList1['total']['01'])}</td>
                        <td>${iwill._.numberFormat(backList1['total']['02'])}</td>
                        <td>${iwill._.numberFormat(backList1['total']['03'])}</td>
                        <td>${iwill._.numberFormat(backList1['total']['04'])}</td>
                        <td>${iwill._.numberFormat(backList1['total']['05'])}</td>
                        <td>${iwill._.numberFormat(backList1['total']['06'])}</td>
                        <td>${iwill._.numberFormat(backList1['total']['others'])}</td>
                        <g:each in="${spList}" var="sp">
                            <td>${iwill._.numberFormat(backList2['total'][sp])}</td>
                        </g:each> 

                        <td>${iwill._.numberFormat(insList1['total']['07'])}</td>
                        <th>${iwill._.numberFormat(rechargeTotal)}</th>
                        <td>${iwill._.numberFormat(storList1['total']['07'])}</td>
                        <td>${iwill._.numberFormat(trInList1['total']['07'])}</td>
                        <td>${iwill._.numberFormat(trOutList1['total']['07'])}</td>
                        <td>${iwill._.numberFormat(backList1['total']['07'])}</td>

                    </tr>
                </g:if>
            </tbody>
        </table>
    </div>
</div>
    
</body>
</html>
