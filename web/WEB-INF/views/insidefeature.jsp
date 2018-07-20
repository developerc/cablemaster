<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inside Feature</title>
    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
</head>
<body>
<script>
    var service = 'http://localhost:8080/';
    var AddCableFeature = function () {
        console.log('propertyId=' + $("#propertyId").val() + ', threadCount=' + $("#threadCount").val());
        var countHalfThread = $("#threadCount").val() * 2;
        console.log('countHalfThread=' + countHalfThread);
        for (var i = 0; i < countHalfThread; i++) {
            AddHalfThread();
        }
    };

    AddHalfThread = function () {
        var JSONObject = {
            'propertyId': $("#propertyId").val()
        };
        $.ajax({
            type: 'POST',
            url: service + "conninsidefeature/add",
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(JSONObject),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('добавлен conninsidefeature');
                return true;
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('ошибка добавления conninsidefeature');
            }
        });
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
