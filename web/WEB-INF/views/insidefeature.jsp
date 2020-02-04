<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inside Feature</title>
    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
</head>
<body>
<script>
    var retId = -1; //ID с которым соединено
    var boolConnId1 = false; // GetBetweenById соединено не с connId1
    var trassaTableCableHtml = '';
    var arrData=[];
    var arrPropertyId = [];
    var countHalfThreads = 0;
    var arrBetweenInsideConnection = [];
    var service = 'http://localhost:8080/';

    $(document).ready(function(){
        var idFiber = decodeURIComponent(window.location.search.substring(1));
        console.log(' document ready, idFiber=' + idFiber);
        $('#propertyId').val(idFiber);
        // TrassaById();
        firstBetween(idFiber);
        firstInside(idFiber);
        makeTableConnections();

        console.log('arrBetweenInsideConnection:');
        for (var i in arrBetweenInsideConnection){
            console.log(arrBetweenInsideConnection[i]);
        }
    });

    function makeTableConnections() {
        trassaTableCableHtml = '';
        trassaTableCableHtml+= '<table class="table-row-cell" border="1">';
        trassaTableCableHtml+= '<tr>';
        trassaTableCableHtml+= '<th>ID первая сторона</'+'th>';
        trassaTableCableHtml+= '<th>цвет соединения</'+'th>';
        trassaTableCableHtml+= '<th>ID вторая сторона</'+'th>';
        trassaTableCableHtml+= '<th>propertyId</'+'th>';
        trassaTableCableHtml+= '<th>Строка соединения</'+'th>';
        /*trassaTableCableHtml+= '<th>propertyName или propertyId</'+'th>';
        trassaTableCableHtml+= '<th>цвет модуля</'+'th>';*/
        trassaTableCableHtml+= '</' +'tr>';
        for (var i in arrBetweenInsideConnection){
            if (arrBetweenInsideConnection[i].length >3){
                trassaTableCableHtml+= '<tr>';
                trassaTableCableHtml+= '<th>' + arrBetweenInsideConnection[i][0] + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + arrBetweenInsideConnection[i][1] + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + arrBetweenInsideConnection[i][2] + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + arrBetweenInsideConnection[i][5] + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + arrBetweenInsideConnection[i][6] + '</' + 'th>';
                /*trassaTableCableHtml+= '<th>' + Data.label + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + Data.reserved + '</' + 'th>';*/
                trassaTableCableHtml+= '</' +'tr>';
            } else {
                trassaTableCableHtml+= '<tr>';
                trassaTableCableHtml+= '<th>' + arrBetweenInsideConnection[i][1] + '</' + 'th>';
                trassaTableCableHtml+= '<th>'  + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + arrBetweenInsideConnection[i][2] + '</' + 'th>';
                trassaTableCableHtml+= '<th>'  + '</' + 'th>';
                trassaTableCableHtml+= '<th>'  + '</' + 'th>';
                /*trassaTableCableHtml+= '<th>' + Data.label + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + Data.reserved + '</' + 'th>';*/
                trassaTableCableHtml+= '</' +'tr>';
            }
        }
        trassaTableCableHtml+= '</' +'table>';
        trassaTableCableHtml+= '<button type="button" onclick="OpenMapTrassa()">Карта с трассировкой' + '</' +'button>';
        // trassaTableCableHtml+= '<button type="button" onclick="OpenMapSchema()">Карта со схемой' + '</' +'button>';
        $('#tableCable').html(trassaTableCableHtml);
    }

    function firstInside(idFiber) {
        var retResp;

        do {
            retResp = getInside(idFiber);
            arrBetweenInsideConnection.unshift(retResp);
            idFiber = retResp[2];
            if (idFiber == 0){
                break;
            }
            retResp = getBetween(idFiber);
            if (retResp != null){
                arrBetweenInsideConnection.unshift(retResp);
                if (idFiber == retResp[1]){
                    idFiber = retResp[2];
                } else {
                    idFiber = retResp[1];
                }
            } else {
                break;
            }
        } while (true);
        /*console.log('arrBetweenInsideConnection:');
        for (var i in arrBetweenInsideConnection){
            console.log(arrBetweenInsideConnection[i]);
        }*/
    }

    function firstBetween(idFiber) {
        var retResp;
        do {
            retResp = getBetween(idFiber);
            if (retResp != null){
                arrBetweenInsideConnection.push(retResp);
                if (idFiber == retResp[1]){
                    idFiber = retResp[2];
                } else {
                    idFiber = retResp[1];
                }
            } else {
                break;
            }
            retResp = getInside(idFiber);
            arrBetweenInsideConnection.push(retResp);
            idFiber = retResp[2];
            if (idFiber == 0){
                break;
            }
        } while (true);
        /*console.log('arrBetweenInsideConnection:');
        for (var i in arrBetweenInsideConnection){
            console.log(arrBetweenInsideConnection[i]);
        }*/
    }

    function getBetween(idFiber) {
        var response = [];
        $.ajax({
            type: 'GET',
            url: service + 'connbetweenfeature/getconnbetweenbyid/' + idFiber,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                arrData = JSON.parse(stringData);
                if (arrData.length >0) {
                    console.log('idFiber=' + idFiber);
                    console.log(arrData[0].id + ', ' + arrData[0].connId1 + ', ' + arrData[0].connId2 + ', ' + arrData[0].description + ', ' + arrData[0].reserved);
                    response.push(arrData[0].id);
                    response.push(arrData[0].connId1);
                    response.push(arrData[0].connId2);
                    // в массиве response три элемента
                } else {
                    console.log('Больше нет внешних соединений');
                    response =  null;
                }

            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Ошибка получения внешнего соединения');
            }
        });
        console.log('response='+response);
        return response;
    }

    function getInside(idFiber) {
        var response = [];
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/' + idFiber,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                var Data = JSON.parse(stringData);
                    response.push(Data.id);
                    response.push(Data.colorThread);
                    response.push(Data.connectedTo);
                    response.push(Data.description);
                    response.push(Data.label);
                    response.push(Data.propertyId);
                    response.push(Data.reserved);
                    arrPropertyId.push(Data.propertyId + ';' + Data.colorThread);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Ошибка получения внутреннего соединения');
            }
        });
        return response;
    }

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
                output+='<label>с ячейки:</label>';
                output+='<input id="beginCell" value="0"/>';
                output+='<label>по ячейку:</label>';
                output+='<input id="endCell" value="1"/>';
                output+='<button type="button" onclick="MultipleDescription()">Размножить Description</button>';
                output+='<button type="button" onclick="MultipleLabel()">Размножить Label</button>';
                output+='<button type="button" onclick="UpdateConnInsideFeature(arrData)">Update table</button>';
                $('#tableCable').html(output);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                $('#tableCable').html(JSON.stringify(jqXHR))
            }
        });
    };

    var MultipleDescription = function () {
        var begCelVal = 0;
         begCelVal = $('#beginCell').val();
        var endCelVal = 0;
         endCelVal = $('#endCell').val();
        var cellVal = $('#idDescription' + begCelVal).val();
        console.log('begCelVal=' + begCelVal + ', endCelVal=' + endCelVal + ', cellVal=' + cellVal);

        var i = 0;
        for (i = 0; i < arrData.length; i++){
            if(i >= begCelVal) {
                if (i <= endCelVal) {
                    $('#idDescription' + i).val(cellVal);
                }
            }
            console.log('#idDescription' + i + '=' + cellVal);
        }
    };

    var MultipleLabel = function () {
        var begCelVal = 0;
        begCelVal = $('#beginCell').val();
        var endCelVal = 0;
        endCelVal = $('#endCell').val();
        var cellVal = $('#idLabel' + begCelVal).val();
        console.log('begCelVal=' + begCelVal + ', endCelVal=' + endCelVal + ', cellVal=' + cellVal);

        var i = 0;
        for (i = 0; i < arrData.length; i++){
            if(i >= begCelVal) {
                if (i <= endCelVal) {
                    $('#idLabel' + i).val(cellVal);
                }
            }
            console.log('#idLabel' + i + '=' + cellVal);
        }


      /*console.log('idLabel0 value =' + $('#idLabel0').val());
        var cellVal = $('#idLabel' + 0).val();
        // var cellVal = $('#idLabel' + $('#beginCell').val()).val();
      for (i in arrData){
          // if(i >= $('#beginCell').val()) {
          //     if (i <= $('#endCell').val()) {
          $('#idLabel' + i).val(cellVal);
          //     }
          // }
      }*/
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
    var TrassaById = function () {
        arrPropertyId = [];
        retId = $("#propertyId").val();
        console.log('TrassaById='+$("#propertyId").val());
        trassaTableCableHtml = '';
        trassaTableCableHtml+= '<table class="table-row-cell" border="1">';
        trassaTableCableHtml+= '<tr>';
        trassaTableCableHtml+= '<th>id</'+'th>';
        trassaTableCableHtml+= '<th>подсоединенный ID</'+'th>';
        trassaTableCableHtml+= '<th>propertyId</'+'th>';
        trassaTableCableHtml+= '<th>colorThread</'+'th>';
        trassaTableCableHtml+= '<th>description</'+'th>';
        trassaTableCableHtml+= '<th>propertyName или propertyId</'+'th>';
        trassaTableCableHtml+= '<th>цвет модуля</'+'th>';
        trassaTableCableHtml+= '</' +'tr>';
        do {
            GetInsideById();
            if (retId < 0){
                break;
            }
            GetBetweenById();
            if (retId < 0){
                break;
            }
        } while (retId > 0);
        trassaTableCableHtml+= '</' +'table>';
        trassaTableCableHtml+= '<button type="button" onclick="OpenMapTrassa()">Карта с трассировкой' + '</' +'button>';
        trassaTableCableHtml+= '<button type="button" onclick="OpenMapSchema()">Карта со схемой' + '</' +'button>';

        $('#tableCable').html(trassaTableCableHtml);
    };
    var GetBetweenById = function () {
        $.ajax({
            type: 'GET',
            url: service + 'connbetweenfeature/getconnbetweenbyid/' + retId,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                arrData = JSON.parse(stringData);
                if (arrData.length >0) {
                    console.log('arrData=' + arrData);
                    trassaTableCableHtml += '<tr>';
                    trassaTableCableHtml += '<th>' + arrData[0].connId1 + '</' + 'th>';
                    trassaTableCableHtml += '<th>' + arrData[0].connId2 + '</' + 'th>';
                    trassaTableCableHtml += '<th>' + '' + '</' + 'th>';
                    trassaTableCableHtml += '<th>' + '' + '</' + 'th>';
                    trassaTableCableHtml += '<th>' + '' + '</' + 'th>';
                    trassaTableCableHtml += '<th>' + '' + '</' + 'th>';
                    trassaTableCableHtml += '<th>' + '' + '</' + 'th>';
                    trassaTableCableHtml += '</' + 'tr>';
                    if (arrData[0].connId1 == retId) {
                        retId = arrData[0].connId2;
                    } else {
                        retId = arrData[0].connId1;
                    }
                } else {
                    retId = -1;
                }
                //else {
                /*if (arrData[0].connId2 !== retId) {
                   retId = arrData[0].connId2;
                }*/
                //}
            },
            error: function (jqXHR, testStatus, errorThrown) {
                $('#tableCable').html(JSON.stringify(jqXHR))
            }
        });
        console.log('GetBetweenById: retId='+retId);
    };
    var GetInsideById = function () {
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/' + retId,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                var Data = JSON.parse(stringData);
                console.log('Data='+Data);
                // trassaTableCableHtml+= '<table class="table-row-cell" border="1">';
                trassaTableCableHtml+= '<tr>';
                trassaTableCableHtml+= '<th>' + Data.id + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + Data.connectedTo + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + Data.propertyId + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + Data.colorThread + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + Data.description + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + Data.label + '</' + 'th>';
                trassaTableCableHtml+= '<th>' + Data.reserved + '</' + 'th>';
                trassaTableCableHtml+= '</' +'tr>';
                retId = Data.connectedTo;
                arrPropertyId.push(Data.propertyId + ';' + Data.colorThread + ';' + Data.reserved);
                console.log('arrPropertyId[i]='+Data.propertyId + ';' + Data.colorThread + ';' + Data.reserved);
                /* trassaTableCableHtml+= '</' +'table>';
                 $('#tableCable').html(trassaTableCableHtml);*/
            },
            error: function (jqXHR, testStatus, errorThrown) {
                $('#tableCable').html(JSON.stringify(jqXHR))
            }
        });
        console.log('GetInsideById: retId='+retId);
    };

    var OpenMapTrassa = function () {
      console.log('OpenMapTrassa');
      var spisokParams = '';
      for (i in arrPropertyId){
          if (i == 0){
              spisokParams+='?param=' + arrPropertyId[i];
          } else {
              spisokParams+='&param=' + arrPropertyId[i];
          }
      }
      console.log('spisokParams=' + spisokParams);
        window.open(service + 'maptrassa' + spisokParams, '_blank');
        // window.open('http://localhost:8080/maptrassa?param=0&param=1&param=3', '_blank');

    };

    var OpenMapSchema = function () {
        console.log('OpenMapSchema');
        var spisokParams = '';
        for (i in arrPropertyId){
            if (i == 0){
                spisokParams+='?param=' + arrPropertyId[i];
            } else {
                spisokParams+='&param=' + arrPropertyId[i];
            }
        }
        window.open(service + 'mapschema' + spisokParams, '_blank');
    };
    
    /*function GetURLparameter() {
        var idFiber = decodeURIComponent(window.location.search.substring(1));
        $('#propertyId').val(idFiber);
    }*/

    // GetURLparameter();
</script>
<div class="panel panel-default">
    <div class="panel-heading">
        <strong>Feature типа "кабель" или "муфта"</strong>
    </div>
    <div class="panel-body">
        <form class="form-inline">
            <label>propertyId feature:</label>
            <input id="propertyId" placeholder="propertyId"/>
            <label>число волокон:</label>
            <input id="threadCount" placeholder="число волокон"/>
            <button type="button" onclick="AddCableFeature()">Добавить feature</button>
            <button type="button" onclick="DelCableFeatureByPropertyId()">Удалить feature по propertyId</button>
            <button type="button" onclick="GetHalfThreadsByPropertyId()">Редактировать feature по propertyId</button>
            <button type="button" onclick="ShowAllHalfThreads()">Показать все feature</button>
            <button type="button" onclick="TrassaById()">Трассировка по ID</button>
        </form>
    </div>
    <div class="panel-body" id="tableCable"></div>
</div>
</body>
</html>