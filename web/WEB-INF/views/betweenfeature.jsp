<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Between Feature</title>
    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
</head>
<body>
<script>

    var AddConnectionBetweenFeature = function () {
      console.log('connInsideId='+$("#connInsideId").val());
    };
</script>
<div class="panel panel-default">
    <div class="panel-heading">
        <strong>Таблица соединений между кабелями и муфтами</strong>
    </div>
    <div class="panel-body">
        <form class="form-inline">
            <label>ConnInsideFeature:</label>
            <input id="connInsideId" value="connInsideId"/>
            <%--<label>число волокон:</label>
            <input id="threadCount" value="число волокон"/>--%>
            <button type="button" onclick="AddConnectionBetweenFeature()">Добавить соединение</button>
            <%--<button type="button" onclick="DelCableFeatureByPropertyId()">Удалить feature по propertyId</button>
            <button type="button" onclick="GetHalfThreadsByPropertyId()">Редактировать feature по propertyId</button>
            <button type="button" onclick="ShowAllHalfThreads()">Показать все feature</button>--%>
        </form>
    </div>
    <div class="panel-body" id="tableConnections"></div>
</div>
</body>
</html>
