<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Between Feature</title>
    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
</head>
<body>
<script>
    var service = 'http://localhost:8080/';
    var Data = {};

    var AddConnectionBetweenFeature = function () {
      console.log('connId1='+$("#connId1").val());
        var JSONObject = {
            'connId1': $("#connId1").val()
        };
        $.ajax({
            type: 'POST',
            url: service + "connbetweenfeature/add",
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(JSONObject),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('success add connbetweenfeature');

                var output = '';
                var stringData = JSON.stringify(result);
                Data = JSON.parse(stringData);
                console.log(Data);
                output+= '<table class="table-row-cell" border="1">';
                output+= '<tr>';
                output+= '<th>id</'+'th>';
                output+= '<th>connId1</'+'th>';
                output+= '<th>connId2</'+'th>';
                output+= '<th>description</'+'th>';
                output+= '<th>reserved</'+'th>';
                output+= '</' +'tr>';

                output += '<tr>';
                output += '<th>' + Data.id + '</' + 'th>';
                output += '<th>' +'<input id="inputConnId1"'+' " value="'+ Data.connId1+'"/>' + '</' + 'th>';
                output += '<th>' +'<input id="inputConnId2"'+' " value="'+ Data.connId2+'"/>' + '</' + 'th>';
                output += '<th>' +'<input id="idDescription"'+' " value="' + Data.description+'"/>' + '</' + 'th>';
                output += '<th>' +'<input id="idReserved"'+' " value="' + Data.reserved+'"/>' + '</' + 'th>';
                output += '</' + 'tr>';

                output+= '</' +'table>';
                output+='<button type="button" onclick="UpdateConnBetweenFeature()">Update соединение</button>';
                $('#tableConnections').html(output);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('ошибка добавления connbetweenfeature');
            }
        });
    };

    var UpdateConnBetweenFeature = function () {
        var JSONObject = {
            'id': Data.id,
            'connId1': $('#inputConnId1').val(),
            'connId2': $('#inputConnId2').val(),
            'description': $('#idDescription').val(),
            'reserved': $('#idReserved').val()
        };
        $.ajax({
            type: 'PUT',
            url: service + "connbetweenfeature/upd",
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(JSONObject),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('Success updating table');
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Error updating table');
            }
        });
    };

    var DelConnectionById = function () {
      console.log('DelConnectionById='+$("#connId1").val());
        $.ajax({
            type: 'DELETE',
            url: service + 'connbetweenfeature/delete?id=' + $("#connId1").val(),
            dataType: 'json',
            async: false,
            success: function (result) {
                $('#tableConnections').html(JSON.stringify('success deleting connbetweenfeature'))
            },
            error: function (jqXHR, testStatus, errorThrown) {
                $('#tableConnections').html(JSON.stringify(jqXHR))
            }
        });
    };

    var EditConnectionById = function () {
    $.ajax({
        type: 'GET',
        url: service + 'connbetweenfeature/get/'+$("#connId1").val(),
        dataType: 'json',
        async: false,
        success: function (result) {
            var output = '';
            var stringData = JSON.stringify(result);
            Data = JSON.parse(stringData);
            console.log(Data);
            output+= '<table class="table-row-cell" border="1">';
            output+= '<tr>';
            output+= '<th>id</'+'th>';
            output+= '<th>connId1</'+'th>';
            output+= '<th>connId2</'+'th>';
            output+= '<th>description</'+'th>';
            output+= '<th>reserved</'+'th>';
            output+= '</' +'tr>';

            output += '<tr>';
            output += '<th>' + Data.id + '</' + 'th>';
            output += '<th>' +'<input id="inputConnId1"'+' " value="'+ Data.connId1+'"/>' + '</' + 'th>';
            output += '<th>' +'<input id="inputConnId2"'+' " value="'+ Data.connId2+'"/>' + '</' + 'th>';
            output += '<th>' +'<input id="idDescription"'+' " value="' + Data.description+'"/>' + '</' + 'th>';
            output += '<th>' +'<input id="idReserved"'+' " value="' + Data.reserved+'"/>' + '</' + 'th>';
            output += '</' + 'tr>';

            output+= '</' +'table>';
            output+='<button type="button" onclick="UpdateConnBetweenFeature()">Update соединение</button>';
            $('#tableConnections').html(output);
        },
        error: function (jqXHR, testStatus, errorThrown) {
            $('#tableConnections').html(JSON.stringify(jqXHR))
        }
    });
    };

    var ShowAllConnections = function () {
        console.log('ShowAllConnections')
      $.ajax({
          type: 'GET',
          url: service + 'connbetweenfeature/all',
          dataType: 'json',
          async: false,
          success: function (result) {
              var output = '';
              var stringData = JSON.stringify(result);
              var arrData = JSON.parse(stringData);
              console.log(Data);
              output+= '<table class="table-row-cell" border="1">';
              output+= '<tr>';
              output+= '<th>id</'+'th>';
              output+= '<th>connId1</'+'th>';
              output+= '<th>connId2</'+'th>';
              output+= '<th>description</'+'th>';
              output+= '<th>reserved</'+'th>';
              output+= '</' +'tr>';

              for (i in arrData) {
                  output += '<tr>';
                  output += '<th>' + arrData[i].id + '</' + 'th>';
                  output += '<th>' + arrData[i].connId1  + '</' + 'th>';
                  output += '<th>' + arrData[i].connId2  + '</' + 'th>';
                  output += '<th>' + arrData[i].description + '</' + 'th>';
                  output += '<th>' + arrData[i].reserved + '</' + 'th>';
                  output += '</' + 'tr>';
              }

              output+= '</' +'table>';
              $('#tableConnections').html(output);
          },
          error: function (jqXHR, testStatus, errorThrown) {
              $('#tableConnections').html(JSON.stringify(jqXHR))
          }
      });
    };
</script>
<div class="panel panel-default">
    <div class="panel-heading">
        <strong>Таблица соединений между кабелями и муфтами</strong>
    </div>
    <div class="panel-body">
        <form class="form-inline">
            <label>Id:</label>
            <input id="connId1" value="connId1"/>
            <%--<label>число волокон:</label>
            <input id="threadCount" value="число волокон"/>--%>
            <button type="button" onclick="AddConnectionBetweenFeature()">Добавить соединение</button>
            <button type="button" onclick="DelConnectionById()">Удалить соединение по Id</button>
            <button type="button" onclick="EditConnectionById()">Редактировать соединение по Id</button>
            <button type="button" onclick="ShowAllConnections()">Показать все соединения</button>
        </form>
    </div>
    <div class="panel-body" id="tableConnections"></div>
</div>
</body>
</html>
