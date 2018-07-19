<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inside Feature</title>
    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
</head>
<body>
<script>
    var AddCableFeature = function () {
        //alert('hey')
        console.log('propertyId=' + $("#propertyId").val() + ', threadCount=' + $("#threadCount").val());
    };
</script>
<div class="panel panel-default">
    <div class="panel-heading">
        <strong>Feature типа "кабель"</strong>
    </div>
    <div class="panel-body">
        <form class="form-inline">
            <label>propertyId кабеля:</label>
            <input id="propertyId" value="propertyId"/>
            <label>число волокон:</label>
            <input id="threadCount" value="число волокон"/>
            <button type="button" onclick="AddCableFeature()">Добавить кабель</button>
        </form>
    </div>
    <div class="panel-body" id="tableCable"></div>
</div>
</body>
</html>
