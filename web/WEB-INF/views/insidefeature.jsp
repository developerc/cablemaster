<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inside Feature</title>
    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
</head>
<body>
<script>
    var arrData=[];
    var countHalfThreads = 0;
    var service = 'http://localhost:8080/';

    var DelCableFeatureByPropertyId = function () {
        console.log('DelCableFeatureByPropertyId');
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/propertyid/' + $("#propertyId").val(),
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                for (i in arrData){
                    idConnInsideFeature = arrData[i].id;
                    DelConnInsideFeatureById(idConnInsideFeature);
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                $('#tableCable').html(JSON.stringify(jqXHR))
            }
        });
    };

    var DelConnInsideFeatureById = function (idConnInsideFeature) {
        $.ajax({
            type: 'DELETE',
            url: service + 'conninsidefeature/delete?id=' + idConnInsideFeature,
            dataType: 'json',
            async: false,
            success: function (result) {
                $('#tableCable').html(JSON.stringify('success deleting conninsidefeature'))
            },
            error: function (jqXHR, testStatus, errorThrown) {
                $('#tableCable').html(JSON.stringify(jqXHR))
            }
        });
    };

    var AddCableFeature = function () {
        console.log('propertyId=' + $("#propertyId").val() + ', threadCount=' + $("#threadCount").val());
        var countHalfThread = $("#threadCount").val() * 2;
        console.log('countHalfThread=' + countHalfThread);
        for (var i = 0; i < countHalfThread; i++) {
            AddHalfThread();
        }
        GetHalfThreadsByPropertyId();
    };

    var ShowAllHalfThreads = function () {
      $.ajax({
          type: 'GET',
          url: service + 'conninsidefeature/all',
          dataType: 'json',
          async: false,
          success: function (result) {
              var output = '';
              var stringData = JSON.stringify(result);
              arrData = JSON.parse(stringData);
              output+= '<table class="table-row-cell" border="1">';
              output+= '<tr>';
              output+= '<th>id</'+'th>';
              output+= '<th>connectedTo</'+'th>';
              output+= '<th>propertyId</'+'th>';
              output+= '<th>colorThread</'+'th>';
              output+= '<th>description</'+'th>';
              output+= '<th>label</'+'th>';
              output+= '<th>reserved</'+'th>';
              output+= '</' +'tr>';

              for (i in arrData) {
                  output += '<tr>';
                  output += '<th>' + arrData[i].id + '</' + 'th>';
                  output += '<th>' + arrData[i].connectedTo + '</' + 'th>';
                  output += '<th>' + arrData[i].propertyId + '</' + 'th>';
                  output += '<th>' + arrData[i].colorThread + '</' + 'th>';
                  output += '<th>' + arrData[i].description + '</' + 'th>';
                  output += '<th>' + arrData[i].label + '</' + 'th>';
                  output += '<th>' + arrData[i].reserved + '</' + 'th>';
                  output += '</' + 'tr>';
              }

              output+= '</' +'table>';
              $('#tableCable').html(output);
          },
          error: function (jqXHR, testStatus, errorThrown) {
              $('#tableCable').html(JSON.stringify(jqXHR))
          }
      });
    };

    var GetHalfThreadsByPropertyId = function () {
        countHalfThreads = 0;
        /*var arrData;*/
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/propertyid/' + $("#propertyId").val(),
            dataType: 'json',
            async: false,
            success: function (result) {
                var output = '';
                var stringData = JSON.stringify(result);
                /*var */arrData = JSON.parse(stringData);
                output+= '<table class="table-row-cell" border="1">';
                output+= '<tr>';
                output+= '<th>id</'+'th>';
                output+= '<th>connectedTo</'+'th>';
                output+= '<th>propertyId</'+'th>';
                output+= '<th>colorThread</'+'th>';
                output+= '<th>description</'+'th>';
                output+= '<th>label</'+'th>';
                output+= '<th>reserved</'+'th>';
                output+= '</' +'tr>';

                for (i in arrData) {
                    output += '<tr>';
                    output += '<th>' + arrData[i].id + '</' + 'th>';
                    output += '<th>' +'<input id="idConnectedTo'+i+'"'+' " value="'+ arrData[i].connectedTo+'"/>' + '</' + 'th>';
                    output += '<th>' + arrData[i].propertyId + '</' + 'th>';
                    output += '<th>' +'<input id="idColorThread'+i+'"'+' " value="' + arrData[i].colorThread+'"/>' + '</' + 'th>';
                    output += '<th>' +'<input id="idDescription'+i+'"'+' " value="' + arrData[i].description+'"/>' + '</' + 'th>';
                    output += '<th>' +'<input id="idLabel'+i+'"'+' " value="' + arrData[i].label+'"/>' + '</' + 'th>';
                    output += '<th>' +'<input id="idReserved'+i+'"'+' " value="' + arrData[i].reserved+'"/>' + '</' + 'th>';
                    output += '</' + 'tr>';
                    countHalfThreads++;
                }

                output+= '</' +'table>';
                output+='<button type="button" onclick="UpdateConnInsideFeature(arrData)">Update table</button>';
                $('#tableCable').html(output);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                $('#tableCable').html(JSON.stringify(jqXHR))
            }
        });
    };

    var UpdateConnInsideFeature = function () {
      console.log('UpdateConnInsideFeature, '+'countHalfThreads='+countHalfThreads);
      console.log('arrData[0].id='+arrData[0].id+'connectedTo0='+$('#idConnectedTo0').val()+'arrData[0].propertyId='+arrData[0].propertyId+'ColorThread0='+$('#idColorThread0').val()+'Description0='+$('#idDescription0').val()+'Label0='+$('#idLabel0').val()+'Reserved0='+$('#idReserved0').val());
        for (i in arrData) {
            var JSONObject = {
                'id': arrData[i].id,
                'connectedTo': $('#idConnectedTo'+i).val(),
                'propertyId': arrData[i].propertyId,
                'colorThread': $('#idColorThread'+i).val(),
                'description': $('#idDescription'+i).val(),
                'label': $('#idLabel'+i).val(),
                'reserved': $('#idReserved'+i).val()
            };
            $.ajax({
                type: 'PUT',
                url: service + "conninsidefeature/upd",
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
        }
    };

    var AddHalfThread = function () {
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
        <strong>Feature типа "кабель" или "муфта"</strong>
    </div>
    <div class="panel-body">
        <form class="form-inline">
            <label>propertyId feature:</label>
            <input id="propertyId" value="propertyId"/>
            <label>число волокон:</label>
            <input id="threadCount" value="число волокон"/>
            <button type="button" onclick="AddCableFeature()">Добавить feature</button>
            <button type="button" onclick="DelCableFeatureByPropertyId()">Удалить feature по propertyId</button>
            <button type="button" onclick="GetHalfThreadsByPropertyId()">Редактировать feature по propertyId</button>
            <button type="button" onclick="ShowAllHalfThreads()">Показать все feature</button>
        </form>
    </div>
    <div class="panel-body" id="tableCable"></div>
</div>
</body>
</html>
