<!DOCTYPE html>
<html ng-app>
<head>
	<meta name="layout" content="w8x"/>
    <script type="text/javascrtipt" src=""></script>
	<script src="${resource(dir: 'bower_components/angular', file: 'angular.min.js')}"></script>
</head>
<content tag="title">标题</content>
<content tag="subtitle">副标题</content>
<body>


    Hello, World!!        

<div>
<label>Name:</label>
<input type="text" ng-model="yourName" placeholder="Enter a name here">
<br>
<h1>Hello, {{yourName || 'World'}}!</h1>
</div>

<div class="container" ng-init="books=[{'name': '1st', 'author': '111'}, {'name': '2nd', 'author': '222'}, {'name': '3rd', 'author': '333'}]">
    <input type="search" ng-model="criteria"/>
    <ul>
        <li ng-repeat="book in books | filter: criteria">
            {{book.name}} -- writed by {{book.author}}
        </li>
    </ul>
</div>

</div>

</body>
</html>
