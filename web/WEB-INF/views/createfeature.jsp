<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Feature</title>
    <%--<link rel="stylesheet" href="css/crfe2.css">--%>
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <%--<script src="js/lines.js"></script>--%>

    <style>
        table {
            border-collapse: collapse;
            border-spacing: 2px;
            border: black;
            border-width: 2px;
            padding-bottom: 2px;
            /*position: absolute;*/
        }

        .wrapper{
            width: 1200px;
            background-color: white;
            margin: 10px auto;
            justify-content: center;
        }

        .left{
            width: 400px;
            float: left;
            background:white;

        }
        .right{
            width: 400px;
            float: right;
            background:white;
            padding-top: 5px;
        }
        .center{
            /*background:green;*/
            width: 400px;
            margin:0 auto;
            display:inline-block;
        }
        .main{
            overflow: hidden;
        }
        .main-left{
            overflow: hidden;
            float: left;
            background: green;
        }

        #cssmenu {
            background: white;
            list-style: none;
            margin: 0;
            padding: 0;
            width: 16em;

            overflow: hidden;
            float: left;
        }
        #cssmenu li {
            font: 80% "Lucida Sans Unicode", "Bitstream Vera Sans", "Trebuchet Unicode MS", "Lucida Grande", Verdana, Helvetica, sans-serif;
            margin: 0;
            padding: 0;
            list-style: none;
        }
        #cssmenu a {
            background: #fafad2;
            border-bottom: 1px solid #f08c1c;
            color: black;
            display: block;
            margin: 0;
            padding: 8px 8px;
            text-decoration: none;
            font-weight: normal;
        }
        #cssmenu a:hover {
            background: #2580a2 url("images/hover.gif") left center no-repeat;
            color: #fff;
            padding-bottom: 8px;
        }

    </style>
</head>
<body>
<script>
    var service = 'http://localhost:8080/';
    var tables ={};  //объявляем объект таблицы
    var connTabs=[]; //обьявляем массив соединений
    var connTabsMarked; //отмеченная строка массива соединений
    var xCoord;
    var lrSelect;
    var curTableNum;
    var idClickedTable1;
    var idClickedTable2;
    var indexClickedRow1;
    var indexClickedRow2;
    var trassaTableId;
    var trassaRowIndex;
    var heightNewRect = 50;
    var arrTabs = [];
    var arrConnInsideFeature = []; //массив строк таблиц соединений
    var arrString = []; //Массив строки полей. В нем 0-id, 1-colorThread, 2-connectedTo, 3-description, 4-label, 5-propertyId, 6-reserved
    var arrAddInsideFeature = [];  //массив присоединенных таблиц
    var arrUpdateInsideFeature = []; //массив строк таблиц (муфты), которые редактируем

    $(document).ready(function(){
        trassaTableId = 'null';
        trassaRowIndex = 'null';
        idClickedTable1 = 'null';
        idClickedTable2 = 'null';
        indexClickedRow1 = 'null';
        indexClickedRow2 = 'null';
        curTableNum = 0;
        xCoord = 380;

        //рисуем соединительную линию
        $("#btn1").click(function(){
            // добавляем соединение в массив
            var clrSelect = $('#colorSelect').val();
            var row = [];
            row.push(idClickedTable1.substr(1));
            row.push(indexClickedRow1);
            row.push(idClickedTable2.substr(1));
            row.push(indexClickedRow2);
            row.push(clrSelect);
            connTabs.push(row);

            var cntRowsTable1 = $(idClickedTable1 + ' tr').length;  //получаем количество строк в таблице 1
            var cntRowsTable2 = $(idClickedTable2 + ' tr').length;  //получаем количество строк в таблице 2

            var toptab1 = $(idClickedTable1).position().top;        //получаем расстояние до таблицы 1 от верха
            var toptab2 = $(idClickedTable2).position().top;        //получаем расстояние до таблицы 2 от верха

            var heigtab1 = $(idClickedTable1).height();             //получаем высоту таблицы 1
            var heigtab2 = $(idClickedTable2).height();             //получаем высоту таблицы 2

            var distdivtab1 = toptab1 - $(".center").position().top;//получаем начальную координату для рисования
            var distdivtab2 = toptab2 - $(".center").position().top;//получаем начальную координату для рисования

            var y1 = distdivtab1 + (heigtab1/cntRowsTable1)*indexClickedRow1 - (heigtab1/cntRowsTable1)/2;  //вычисляем координату Y для начала линии таблицы 1
            var y2 = distdivtab2 + (heigtab2/cntRowsTable2)*indexClickedRow2 - (heigtab2/cntRowsTable2)/2;  //вычисляем координату Y для конца линии таблицы 2

            var x1;
            var x2;
            if(idClickedTable1.charAt(1) == 'l'){
                x1 = 0;
            } else {
                x1 = 400;
            }
            if(idClickedTable2.charAt(1) == 'l'){
                x2 = 0;
            } else {
                x2 = 400;
            }

            var newLine = document.createElementNS('http://www.w3.org/2000/svg','polyline');
            newLine.setAttribute('points', x1 + ',' + y1 + ' ' + xCoord + ',' + y1 + ' ' + xCoord + ',' + y2 + ' ' + x2 + ',' + y2 );
            newLine.setAttribute("stroke", clrSelect);
            newLine.setAttribute("fill", "white");
            newLine.setAttribute("fill-opacity", "0");
            newLine.setAttribute("stroke-width", "2px");
            $("#map").append(newLine);

            idClickedTable1 = 'null';
            idClickedTable2 = 'null';
            indexClickedRow1 = 'null';
            indexClickedRow2 = 'null';
            xCoord = xCoord - 6;
            // console.log("done!");
        });

        //Добавляем таблицу
        $("#btnAddTable").click(function(){
            {
                var nametable;
                var colArr = [];
                var rowArr = [];
                curTableNum = 0;
                $('table').each(function () {
                    console.log($(this).attr("id"));
                    curTableNum++;
                });
               // numTable++;  //номер таблицы - следующий
                curTableNum++;  //перед созданием новой таблицы увеличим номер
                lrSelect = $('#leftRight').val();
                // $("#mytext").html(lrSelect);
                if (lrSelect == 'слева') {

                    $('#divleft').append('<div class="table-wrapper">');
                    $('#divleft').append('<table border="2" bgcolor="#fafad2" id="ltable' + curTableNum + '" align="right"><tr><td colspan="4">' + $('#column5').val() + '</td></tr><tr><th>' + $('#column1').val() + '</th><th>' + $('#column2').val() + '</th><th>' + $('#column3').val() + '</th><th>' + $('#column4').val() + '</th></tr></table>');
                    $('#divleft').append('</div>');

                    //если высота таблиц больше SVG-поля, увеличим его
                    var idAddTable = '#ltable' + curTableNum;
                    var bottomTableLeft = $(idAddTable).position().top + $(idAddTable).height();
                    // $("#mytext").html(bottomTableLeft);
                    var bottomMap = $('#map').position().top + $('#map').height();
                    if (bottomMap < bottomTableLeft) {
                        var heightMap = bottomTableLeft - $(".center").position().top;
                        $('#map').css("height", heightMap);
                        // heightNewRect = heightMap;
                        // console.log("heightNewRect=" + heightNewRect + "heightMap=" + heightMap);
                    }
                    //добавим в класс свойства
                    nametable = "ltable" + curTableNum;

                } else {
                    $('#divright').append('<div class="table-wrapper">');
                    $('#divright').append('<table border="2" bgcolor="#fafad2" id="rtable' + curTableNum + '" align="left"><tr><td colspan="4">' + $('#column5').val() + '</td></tr><tr><th>' + $('#column1').val() + '</th><th>' + $('#column2').val() + '</th><th>' + $('#column3').val() + '</th><th>' + $('#column4').val() + '</th></tr></table>');
                    $('#divright').append('</div>');

                    //если высота таблиц больше SVG-поля, увеличим его
                    var idAddTable = '#rtable' + curTableNum;
                    var bottomTableRight = $(idAddTable).position().top + $(idAddTable).height();
                    // $("#mytext").html(bottomTableRight);
                    var bottomMap = $('#map').position().top + $('#map').height();
                    if (bottomMap < bottomTableRight) {
                        var heightMap = bottomTableRight - $(".center").position().top;
                        $('#map').css("height", heightMap);
                        // heightNewRect = heightMap;
                        // console.log("heightNewRect=" + heightNewRect + "heightMap=" + heightMap);
                    }
                    //добавим в класс свойства
                    nametable = "rtable" + curTableNum;
                }
                //добавим в класс tables новую таблицу
                colArr.push($('#column5').val());
                rowArr.push(colArr);
                colArr = [];
                colArr.push($('#column1').val());
                colArr.push($('#column2').val());
                colArr.push($('#column3').val());
                colArr.push($('#column4').val());
                rowArr.push(colArr);
                tables [nametable] = rowArr;
            }
            // console.log(tables);
        });
        //Добавляем строку к таблице
        $("#btnAppend").click(function(){
            // appTrToTab();
            {
                var nametable;
                var colArr = [];
                var rowArr = [];
                var idTable;
                if (lrSelect == 'слева') {
                    idTable = "#ltable" + curTableNum;
                    $(idTable).append('<tr><td>' + $('#column1').val() + '</td><td>' + $('#column2').val() + '</td><td>' + $('#column3').val() + '</td><td>' + $('#column4').val() + '</td></tr>');
                    //добавим в класс свойства
                    nametable = "ltable" + curTableNum;
                } else {
                    idTable = "#rtable" + curTableNum;
                    $(idTable).append('<tr><td>' + $('#column1').val() + '</td><td>' + $('#column2').val() + '</td><td>' + $('#column3').val() + '</td><td>' + $('#column4').val() + '</td></tr>');
                    //добавим в класс свойства
                    nametable = "rtable" + curTableNum;
                }
                //если высота таблиц больше SVG-поля, увеличим его
                var bottomTable = $(idTable).position().top + $(idTable).height();
                // $("#mytext").html(bottomTable);
                var bottomMap = $('#map').position().top + $('#map').height();
                if (bottomMap < bottomTable) {
                    var heightMap = bottomTable - $(".center").position().top;
                    $('#map').css("height", heightMap);
                    heightNewRect = heightMap;
                    // console.log("heightNewRect=" + heightNewRect + "heightMap=" + heightMap);
                }
            }
            colArr.push($('#column1').val());
            colArr.push($('#column2').val());
            colArr.push($('#column3').val());
            colArr.push($('#column4').val());
            // rowArr.push(colArr);
            tables[nametable].push(colArr);
        });

        //выделяем строку таблицы
        $("body").on("click", "table tr", function () {  //получаем доступ к строке таблицы во время клика
            // $(this).css("background-color", "#2FF0A9");
            // alert($(this).text());
            // alert($(this).find("td").eq(1).html());   //получаем значение ячейки
            //alert($(this).closest('table').attr('id'));  //получаем ID таблицы
            // alert($(this).index() + 1);  //получаем индекс строки таблицы
            var repeatedClick1 = 0;
            var repeatedClick2 = 0;

            var clickTableId = $(this).closest('table').attr('id');
            var clickRowIndex = $(this).index() + 1;

            trassaTableId = clickTableId;
            trassaRowIndex = clickRowIndex;

            //проверим может нажимаем на первую или вторую уже нажатую строку
            if ((clickTableId == idClickedTable1.substr(1)) && (clickRowIndex == indexClickedRow1)) {
                // console.log("повторное нажатие 1!");
                repeatedClick1 = 1;
            }if ((clickTableId == idClickedTable2.substr(1)) && (clickRowIndex == indexClickedRow2)) {
                // console.log("повторное нажатие 2!");
                repeatedClick2 = 1;
            }

            //----------------------------------------------------


            if(idClickedTable1 == 'null') {
                var rowBusy = 0;
                for (var i in connTabs){
                    if (((connTabs[i][0] == clickTableId) && (connTabs[i][1] == clickRowIndex)) || ((connTabs[i][2] == clickTableId) && (connTabs[i][3] == clickRowIndex))) {
                        rowBusy = 1;
                    }
                }
                if (rowBusy == 0) {
                    idClickedTable1 = "#" + $(this).closest('table').attr('id');  //получаем ID таблицы 1
                    indexClickedRow1 = $(this).index() + 1;                       //получаем номер строки
                }

            } else {
                if(idClickedTable2 == 'null') {
                    var rowBusy = 0;
                    for (var i in connTabs){
                        if (((connTabs[i][0] == clickTableId) && (connTabs[i][1] == clickRowIndex)) || ((connTabs[i][2] == clickTableId) && (connTabs[i][3] == clickRowIndex))) {
                            rowBusy = 1;
                        }
                    }
                    if (rowBusy == 0) {
                        idClickedTable2 = "#" + $(this).closest('table').attr('id');  //получаем ID таблицы 2
                        indexClickedRow2 = $(this).index() + 1;                       //получаем номер строки
                    }

                }
            }
            // console.log("repeatedClick1=" + repeatedClick1 + ", repeatedClick2=" +repeatedClick2);
            if (repeatedClick1 == 1){
                idClickedTable1 = 'null';
                indexClickedRow1 = 'null';
            }
            if (repeatedClick2 == 1){
                idClickedTable2 = 'null';
                indexClickedRow2 = 'null';
            }


            $('table tr').each(function () {
                $(this).css("background-color", "#fafad2"); //красим в стандартный цвет
                var currTableId = $(this).closest('table').attr('id');
                var currTrInd = $(this).index() + 1;
                if (((currTableId == idClickedTable1.substr(1)) && (currTrInd == indexClickedRow1)) || ((currTableId == idClickedTable2.substr(1)) && (currTrInd == indexClickedRow2))) {
                    $(this).css("background-color", "#2FF0A9");
                }
            });


            connTabsMarked = -1;
            for (var i in connTabs) {
                if (((clickTableId == connTabs[i][0]) && (clickRowIndex == connTabs[i][1])) || ((clickTableId == connTabs[i][2]) && (clickRowIndex == connTabs[i][3]))) {
                    $('#' + connTabs[i][0] + ' tr:eq( ' + (connTabs[i][1] - 1) + ' )').css("background-color", "#f08c1c");
                    $('#' + connTabs[i][2] + ' tr:eq( ' + (connTabs[i][3] - 1) + ' )').css("background-color", "#f08c1c");
                    connTabsMarked = i;
                }
            }
        });
        //разрываем выделенное соединение
        $("#breakConn").click(function(){
            console.log("connTabsMarked=" + connTabsMarked);
            for (var i in connTabs) {
                console.log(connTabs[i][0] + ','+ connTabs[i][1] + ','+connTabs[i][2] + ','+connTabs[i][3] + ','+connTabs[i][4] + ',');
            }
            console.log("удаляем строку:" + connTabsMarked);
            connTabs.splice(connTabsMarked,1);
            connTabsMarked = -1;

            getHeightNewRect();


            repaintConnections();
        });
        //перерисовываем соединения
        var repaintConnections = function () {
            //очищаем поле, зарисовываем белым прямоугольником
            xCoord = 380;
            console.log("heightNewRect=" + heightNewRect);
            var newRect = document. createElementNS("http://www.w3.org/2000/svg", "rect");
            newRect.setAttribute("x",0);
            newRect.setAttribute("y", 0);
            newRect.setAttribute("width", 400);
            newRect.setAttribute("height", heightNewRect);
            newRect.setAttribute("fill", "white");
            $("#map").append(newRect);
            //отрисовываем линии из массива
            for (var i in connTabs) {
                console.log(connTabs[i][0] + ','+ connTabs[i][1] + ','+connTabs[i][2] + ','+connTabs[i][3] + ','+connTabs[i][4] );
                var cntRowsTable1 = $("#" + connTabs[i][0] + ' tr').length;  //получаем количество строк в таблице 1
                var cntRowsTable2 = $("#" + connTabs[i][2] + ' tr').length;  //получаем количество строк в таблице 2

                var toptab1 = $("#" + connTabs[i][0]).position().top;        //получаем расстояние до таблицы 1 от верха
                var toptab2 = $("#" + connTabs[i][2]).position().top;        //получаем расстояние до таблицы 2 от верха

                var heigtab1 = $("#" + connTabs[i][0]).height();             //получаем высоту таблицы 1
                var heigtab2 = $("#" + connTabs[i][2]).height();             //получаем высоту таблицы 2

                var distdivtab1 = toptab1 - $(".center").position().top;//получаем начальную координату для рисования
                var distdivtab2 = toptab2 - $(".center").position().top;//получаем начальную координату для рисования

                var y1 = distdivtab1 + (heigtab1/cntRowsTable1)*connTabs[i][1] - (heigtab1/cntRowsTable1)/2;  //вычисляем координату Y для начала линии таблицы 1
                var y2 = distdivtab2 + (heigtab2/cntRowsTable2)*connTabs[i][3] - (heigtab2/cntRowsTable2)/2;  //вычисляем координату Y для конца линии таблицы 2

                var x1;
                var x2;
                if(connTabs[i][0].charAt(0) == 'l'){
                    x1 = 0;
                } else {
                    x1 = 400;
                }
                if(connTabs[i][2].charAt(0) == 'l'){
                    x2 = 0;
                } else {
                    x2 = 400;
                }

                var newLine = document.createElementNS('http://www.w3.org/2000/svg','polyline');
                newLine.setAttribute('points', x1 + ',' + y1 + ' ' + xCoord + ',' + y1 + ' ' + xCoord + ',' + y2 + ' ' + x2 + ',' + y2 );
                newLine.setAttribute("stroke", connTabs[i][4]);
                newLine.setAttribute("fill", "white");
                newLine.setAttribute("fill-opacity", "0");
                newLine.setAttribute("stroke-width", "2px");
                $("#map").append(newLine);

                xCoord = xCoord - 6;
                console.log("cntRowsTable1=" + cntRowsTable1 + ", cntRowsTable2=" + cntRowsTable2 + ", toptab1=" + toptab1 + ", toptab2= " + toptab2);
            }
        }
        //сохраняем соединение
        $("#saveAll").click(function(){
            var propertyId = decodeURIComponent(window.location.search.substring(1));
            var currTableId;
            var currTrInd;
            var cell1;
            var cell2;
            var cell3;
            var cell4;
            if (getCountInsideRows(propertyId) > 0){
                updateConnInsideIfExist(propertyId);
            } else {
                console.log("сохраняем соединения");
                //сохраняем строки таблиц
                $('table tr').each(function () {
                    currTableId = $(this).closest('table').attr('id');
                    currTrInd = $(this).index();
                    arrString = [];
                    if (currTrInd == 0) {
                        arrString.push('null'); //поле 0: id
                        arrString.push('null'); //поле 1: colorThread
                        arrString.push('null'); //поле 2: connectedTo
                        arrString.push(currTableId + ';' + currTrInd); //поле 3: description
                        arrString.push('null'); //поле 4: label
                        arrString.push(propertyId); //поле 5: propertyId
                        cell1 = $(this).find('td').eq(0).text();
                        arrString.push(cell1); //поле 6: reserved
                        // console.log(arrString);
                    }
                    if (currTrInd == 1) {
                        arrString.push('null'); //поле 0: id
                        arrString.push('null'); //поле 1: colorThread
                        arrString.push('null'); //поле 2: connectedTo
                        arrString.push(currTableId + ';' + currTrInd); //поле 3: description
                        arrString.push('null'); //поле 4: label
                        arrString.push(propertyId); //поле 5: propertyId
                        cell1 = $(this).find('th').eq(0).text();
                        cell2 = $(this).find('th').eq(1).text();
                        cell3 = $(this).find('th').eq(2).text();
                        cell4 = $(this).find('th').eq(3).text();
                        arrString.push(cell1 + "; " + cell2 + "; " + cell3 + "; " + cell4); //поле 6: reserved
                        // console.log(arrString);
                    }
                    if (currTrInd > 1) {
                        arrString.push('null'); //поле 0: id
                        arrString.push('null'); //поле 1: colorThread
                        arrString.push('null'); //поле 2: connectedTo
                        arrString.push(currTableId + ';' + currTrInd); //поле 3: description
                        arrString.push('null'); //поле 4: label
                        arrString.push(propertyId); //поле 5: propertyId
                        cell1 = $(this).find('td').eq(0).text();
                        cell2 = $(this).find('td').eq(1).text();
                        cell3 = $(this).find('td').eq(2).text();
                        cell4 = $(this).find('td').eq(3).text();
                        arrString.push(cell1 + "; " + cell2 + "; " + cell3 + "; " + cell4); //поле 6: reserved
                        // console.log(arrString);
                    }
                    var JSONObject = {
                        'description': arrString[3],
                        'propertyId': arrString[5],
                        'reserved': arrString[6]

                    };
                    $.ajax({
                        type: 'POST',
                        url: service + "conninsidefeature/add",
                        contentType: 'application/json;charset=utf-8',
                        data: JSON.stringify(JSONObject),
                        dataType: 'json',
                        async: false,
                        success: function (result) {
                            var stringData = JSON.stringify(result);
                            arrData = JSON.parse(stringData);
                            // console.log(result);
                            arrString[0] = arrData.id;
                            // console.log(arrString);
                            arrConnInsideFeature.push(arrString);
                        },
                        error: function (jqXHR, testStatus, errorThrown) {
                            console.log('ошибка добавления conninsidefeature');
                        }
                    });
                });
                console.log('arrConnInsideFeature=' + arrConnInsideFeature);
                //сохраняем соединения между строками
                var firstConn = [];
                var secondConn = [];
                var colorConn = [];
                //обрабатываем первую половину соединения
                for (var i in connTabs) {
                    console.log(connTabs[i][0] + ',' + connTabs[i][1] + ',' + connTabs[i][2] + ',' + connTabs[i][3] + ',' + connTabs[i][4]);
                    for (var n in arrConnInsideFeature) {
                        var arrTableId = arrConnInsideFeature[n][3].split(';');
                        var toConnTabs = Number(arrTableId[1]) + 1;
                        // console.log(toConnTabs);
                        if ((arrTableId[0] == connTabs[i][0]) && (toConnTabs == connTabs[i][1])) {
                            console.log(arrConnInsideFeature[n][3] + ', id=' + arrConnInsideFeature[n][0]);
                            firstConn.push(arrConnInsideFeature[n][0]);
                        }
                    }
                }
                //обрабатываем вторую половину соединения
                for (var i in connTabs) {
                    console.log(connTabs[i][0] + ',' + connTabs[i][1] + ',' + connTabs[i][2] + ',' + connTabs[i][3] + ',' + connTabs[i][4]);
                    for (var n in arrConnInsideFeature) {
                        var arrTableId = arrConnInsideFeature[n][3].split(';');
                        var toConnTabs = Number(arrTableId[1]) + 1;
                        // console.log(toConnTabs);
                        if ((arrTableId[0] == connTabs[i][2]) && (toConnTabs == connTabs[i][3])) {
                            console.log(arrConnInsideFeature[n][3] + ', id=' + arrConnInsideFeature[n][0]);
                            secondConn.push(arrConnInsideFeature[n][0]);
                            colorConn.push(connTabs[i][4]);
                        }
                    }
                }
                //Делаем Update массиву соединений
                for (var i in firstConn) {
                    for (n in arrConnInsideFeature) {
                        if (firstConn[i] == arrConnInsideFeature[n][0]) {
                            arrConnInsideFeature[n][2] = secondConn[i];
                            arrConnInsideFeature[n][1] = colorConn[i];
                        }
                    }
                }
                for (var i in secondConn) {
                    for (n in arrConnInsideFeature) {
                        if (secondConn[i] == arrConnInsideFeature[n][0]) {
                            arrConnInsideFeature[n][2] = firstConn[i];
                            arrConnInsideFeature[n][1] = colorConn[i];
                        }
                    }
                }
                //Делаем Update базы
                updateConnInsideFeature();

                //просмотр массивов
                console.log('firstConn= ...');
                for (var i in firstConn) {
                    console.log(firstConn[i]);
                }
                console.log('secondConn= ...');
                for (var i in secondConn) {
                    console.log(secondConn[i]);
                }
                console.log('colorConn= ...');
                for (var i in colorConn) {
                    console.log(colorConn[i]);
                }
                // изменяем в заголовке количество записей
                changeHeaderCountRows(propertyId);

                //если это муфта будем сохранять внешние соединения
                saveBetweenConnIfPoint(propertyId);
            }
        });

        //Сохраняем кабель как из шаблона
        $('#saveAsFromTemplate').click(function () {
            console.log('column4=' + $('#column4').val());
            console.log('column5=' + $('#column5').val());
            arrConnInsideFeature = [];
            var propertyId = $('#column4').val();
            var currTableId;
            var currTrInd;
            var cell1;
            var cell2;
            var cell3;
            var cell4;
            $('table tr').each(function () {
                currTableId = $(this).closest('table').attr('id');
                currTrInd = $(this).index();
                arrString = [];
                if (currTrInd == 0) {
                    arrString.push('null'); //поле 0: id
                    arrString.push('null'); //поле 1: colorThread
                    arrString.push('null'); //поле 2: connectedTo
                    arrString.push(currTableId + ';' + currTrInd); //поле 3: description
                    arrString.push('null'); //поле 4: label
                    arrString.push(propertyId); //поле 5: propertyId
                    cell1 = $('#column5').val(); //новый заголовок
                    arrString.push(cell1); //поле 6: reserved
                    // console.log(arrString);
                }
                if (currTrInd == 1) {
                    arrString.push('null'); //поле 0: id
                    arrString.push('null'); //поле 1: colorThread
                    arrString.push('null'); //поле 2: connectedTo
                    arrString.push(currTableId + ';' + currTrInd); //поле 3: description
                    arrString.push('null'); //поле 4: label
                    arrString.push(propertyId); //поле 5: propertyId
                    cell1 = $(this).find('th').eq(0).text();
                    cell2 = $(this).find('th').eq(1).text();
                    cell3 = $(this).find('th').eq(2).text();
                    cell4 = $(this).find('th').eq(3).text();
                    arrString.push(cell1 + "; " + cell2 + "; " + cell3 + "; " + cell4); //поле 6: reserved
                    // console.log(arrString);
                }
                if (currTrInd > 1) {
                    arrString.push('null'); //поле 0: id
                    arrString.push('null'); //поле 1: colorThread
                    arrString.push('null'); //поле 2: connectedTo
                    arrString.push(currTableId + ';' + currTrInd); //поле 3: description
                    arrString.push('null'); //поле 4: label
                    arrString.push(propertyId); //поле 5: propertyId
                    cell1 = $(this).find('td').eq(0).text();
                    cell2 = $(this).find('td').eq(1).text();
                    cell3 = $(this).find('td').eq(2).text();
                    cell4 = $(this).find('td').eq(3).text();
                    arrString.push(cell1 + "; " + cell2 + "; " + cell3 + "; " + cell4); //поле 6: reserved
                    // console.log(arrString);
                }
                var JSONObject = {
                    'description': arrString[3],
                    'propertyId': arrString[5],
                    'reserved': arrString[6]

                };
                $.ajax({
                    type: 'POST',
                    url: service + "conninsidefeature/add",
                    contentType: 'application/json;charset=utf-8',
                    data: JSON.stringify(JSONObject),
                    dataType: 'json',
                    async: false,
                    success: function (result) {
                        var stringData = JSON.stringify(result);
                        arrData = JSON.parse(stringData);
                        // console.log(result);
                        arrString[0] = arrData.id;
                        // console.log(arrString);
                        arrConnInsideFeature.push(arrString);
                    },
                    error: function (jqXHR, testStatus, errorThrown) {
                        console.log('ошибка добавления conninsidefeature');
                    }
                });
            });
            console.log('arrConnInsideFeature=' + arrConnInsideFeature);
            //сохраняем соединения между строками
            var firstConn = [];
            var secondConn = [];
            var colorConn = [];
            //обрабатываем первую половину соединения
            for (var i in connTabs) {
                console.log(connTabs[i][0] + ',' + connTabs[i][1] + ',' + connTabs[i][2] + ',' + connTabs[i][3] + ',' + connTabs[i][4]);
                for (var n in arrConnInsideFeature) {
                    var arrTableId = arrConnInsideFeature[n][3].split(';');
                    var toConnTabs = Number(arrTableId[1]) + 1;
                    // console.log(toConnTabs);
                    if ((arrTableId[0] == connTabs[i][0]) && (toConnTabs == connTabs[i][1])) {
                        console.log(arrConnInsideFeature[n][3] + ', id=' + arrConnInsideFeature[n][0]);
                        firstConn.push(arrConnInsideFeature[n][0]);
                    }
                }
            }
            //обрабатываем вторую половину соединения
            for (var i in connTabs) {
                console.log(connTabs[i][0] + ',' + connTabs[i][1] + ',' + connTabs[i][2] + ',' + connTabs[i][3] + ',' + connTabs[i][4]);
                for (var n in arrConnInsideFeature) {
                    var arrTableId = arrConnInsideFeature[n][3].split(';');
                    var toConnTabs = Number(arrTableId[1]) + 1;
                    // console.log(toConnTabs);
                    if ((arrTableId[0] == connTabs[i][2]) && (toConnTabs == connTabs[i][3])) {
                        console.log(arrConnInsideFeature[n][3] + ', id=' + arrConnInsideFeature[n][0]);
                        secondConn.push(arrConnInsideFeature[n][0]);
                        colorConn.push(connTabs[i][4]);
                    }
                }
            }
            //Делаем Update массиву соединений
            for (var i in firstConn) {
                for (n in arrConnInsideFeature) {
                    if (firstConn[i] == arrConnInsideFeature[n][0]) {
                        arrConnInsideFeature[n][2] = secondConn[i];
                        arrConnInsideFeature[n][1] = colorConn[i];
                    }
                }
            }
            for (var i in secondConn) {
                for (n in arrConnInsideFeature) {
                    if (secondConn[i] == arrConnInsideFeature[n][0]) {
                        arrConnInsideFeature[n][2] = firstConn[i];
                        arrConnInsideFeature[n][1] = colorConn[i];
                    }
                }
            }
            //Делаем Update базы
            updateConnInsideFeature();
            $("h3").html("Сохранили кабель как из шаблона, propertyId=" + propertyId);
        });
        //делаем кабель
        $('#makeCable').click(function () {
            console.log("Делаем кабель");
            var arrTr = [];
            var cellMain;
            var cell1;
            var cell2;
            var cell3;
            var cell4;
            getAllTabs();
            arrTr = arrTabs[0].split(';');
            cellMain = arrTr[2];
            arrTr = arrTabs[1].split(';');
            cell1 = arrTr[2];
            cell2 = arrTr[3];
            cell3 = arrTr[4];
            cell4 = arrTr[5];
            $('#divright').append('<div class="table-wrapper">');
            $('#divright').append('<table border="2" bgcolor="#fafad2" id="rtable2'  + '" align="left"><tr><td colspan="4">' + cellMain + '</td></tr><tr><th>' + cell4 + '</th><th>' + cell3 + '</th><th>' + cell2 + '</th><th>' + cell1 + '</th></tr></table>');
            $('#divright').append('</div>');
            for (var i = 2; i < arrTabs.length; i ++){
                arrTr = arrTabs[i].split(';');
                cell1 = arrTr[2];
                cell2 = arrTr[3];
                cell3 = arrTr[4];
                cell4 = arrTr[5];
                $('#rtable2').append('<tr><td>' + cell4 + '</td><td>' + cell3 + '</td><td>' + cell2 + '</td><td>' + cell1 + '</td></tr>');
            }
            //добавляем соединения
            var cntRowsTable1 = $('#ltable1 tr').length;  //получаем количество строк в таблице 1
            connTabs = [];
            for (var i = 3; i <= cntRowsTable1; i++) {
                var row = [];
                row.push('ltable1');
                row.push(i);
                row.push('rtable2');
                row.push(i);
                row.push('black');
                connTabs.push(row);
            }

            repaintConnections();
        });

        //функция получения всех строк из таблиц
        var getAllTabs = function(){
            arrTabs = [];
            var currTableId;
            var currTrInd;
            var cell1;
            var cell2;
            var cell3;
            var cell4;
            $('table tr').each(function () {
                currTableId = $(this).closest('table').attr('id');
                currTrInd = $(this).index();
                if (currTrInd == 0){
                    cell1 = $(this).find('td').eq(0).text();
                    arrTabs.push(currTableId + ";" + currTrInd + ";" + cell1);
                }
                if (currTrInd == 1){
                    cell1 = $(this).find('th').eq(0).text();
                    cell2 = $(this).find('th').eq(1).text();
                    cell3 = $(this).find('th').eq(2).text();
                    cell4 = $(this).find('th').eq(3).text();
                    arrTabs.push(currTableId + ";" + currTrInd + ";" + cell1 + ";" + cell2 + ";" + cell3 + ";" + cell4);
                }
                if (currTrInd > 1){
                    cell1 = $(this).find('td').eq(0).text();
                    cell2 = $(this).find('td').eq(1).text();
                    cell3 = $(this).find('td').eq(2).text();
                    cell4 = $(this).find('td').eq(3).text();
                    arrTabs.push(currTableId + ";" + currTrInd + ";" + cell1 + ";" + cell2 + ";" + cell3 + ";" + cell4);
                }
            });
        }

        //Обрабатываем нажатие на меню Получить данные
        //Получаем данные Feature и отображаем их
        $('#getfeature').click(function () {
            var sPageURL = decodeURIComponent(window.location.search.substring(1));
            //получаем FeatureCoord by id
            getFeatureCoordById(sPageURL);
        });

        //Обрабатываем нажатие на меню Удалить данные
        $('#delfeature').click(function () {
            var sPageURL = decodeURIComponent(window.location.search.substring(1));
            delFeatureByPropertyId(sPageURL);
        });
        //подключаем таблицу
        $('#connTable').click(function () {
            // console.log('подключаем таблицу');
            var sPageURL = decodeURIComponent(window.location.search.substring(1));
            addConnBetweenFeature(sPageURL);
        });
        //строим трассу для волокна
        $('#makeTrassa').click(function () {
            console.log('строим трассу');
            if (trassaTableId != 'null'){
                console.log('trassaTableId=' + trassaTableId);
                console.log('trassaRowIndex=' + trassaRowIndex);
                console.log(arrConnInsideFeature);
                for (var i in arrConnInsideFeature){
                    var arrStr = arrConnInsideFeature[i];
                    for (var k in arrStr){
                        var tableIndex = arrStr[4].split(';');
                        // console.log(tableIndex[0] + '__' + tableIndex[1]);
                        var indFromZero = +trassaRowIndex - 1;
                        if ((trassaTableId == tableIndex[0]) && (indFromZero == tableIndex[1])){
                            console.log(arrStr[0] + '__' + tableIndex[0] + '__' + tableIndex[1]);
                            window.open(service + 'insidefeature?' + arrStr[0], '_blank');
                            break;
                        }
                    }
                }
            } else {
                console.log('Не выбрана строка таблицы!');
            }
        });
        $('#addSplitter').click(function () {
            curTableNum = 0;
            $('table').each(function () {
                console.log($(this).attr("id"));
                curTableNum++;
            });
            // numTable++;  //номер таблицы - следующий
            curTableNum++;  //перед созданием новой таблицы увеличим номер
            lrSelect = $('#leftRight').val();
            // $("#mytext").html(lrSelect);
            if (lrSelect == 'слева') {
                var idTable = '#ltable' + curTableNum;
                $('#divleft').append('<div class="table-wrapper">');
                $('#divleft').append('<table border="2" bgcolor="#fafad2" id="ltable' + curTableNum + '" align="right"><tr><td colspan="4">' + $('#column5').val() + '</td></tr><tr><th>' + 'Пусто' + '</th><th>' + 'Пусто' + '</th><th>' + 'Назначение' + '</th><th>' + '№' + '</th></tr></table>');
                $(idTable).append('<tr><td>' + 'Пусто' + '</td><td>' + 'Пусто' + '</td><td>' + 'Вход' + '</td><td>' + '0' + '</td></tr>');
                for (var i = 1; i < 9; i++) {
                    $(idTable).append('<tr><td>' + 'Пусто' + '</td><td>' + 'Пусто' + '</td><td>' + 'Выход' + '</td><td>' + i + '</td></tr>');
                }
                $('#divleft').append('</div>');

                //если высота таблиц больше SVG-поля, увеличим его
                var idAddTable = '#ltable' + curTableNum;
                var bottomTableLeft = $(idAddTable).position().top + $(idAddTable).height();
                // $("#mytext").html(bottomTableLeft);
                var bottomMap = $('#map').position().top + $('#map').height();
                if (bottomMap < bottomTableLeft) {
                    var heightMap = bottomTableLeft - $(".center").position().top;
                    $('#map').css("height", heightMap);
                    // heightNewRect = heightMap;
                    // console.log("heightNewRect=" + heightNewRect + "heightMap=" + heightMap);
                }

            } else {
                var idTable = '#rtable' + curTableNum;
                $('#divright').append('<div class="table-wrapper">');
                $('#divright').append('<table border="2" bgcolor="#fafad2" id="rtable' + curTableNum + '" align="left"><tr><td colspan="4">' + $('#column5').val() + '</td></tr><tr><th>' + '№' + '</th><th>' + 'Назначение' + '</th><th>' + 'Пусто' + '</th><th>' + 'Пусто' + '</th></tr></table>');
                $(idTable).append('<tr><td>' + '0' + '</td><td>' + 'Вход' + '</td><td>' + 'Пусто' + '</td><td>' + 'Пусто' + '</td></tr>');
                for (var i = 1; i < 9; i++) {
                    $(idTable).append('<tr><td>' + i + '</td><td>' + 'Вход' + '</td><td>' + 'Пусто' + '</td><td>' + 'Пусто' + '</td></tr>');
                }
                $('#divright').append('</div>');

                //если высота таблиц больше SVG-поля, увеличим его
                var idAddTable = '#rtable' + curTableNum;
                var bottomTableRight = $(idAddTable).position().top + $(idAddTable).height();
                // $("#mytext").html(bottomTableRight);
                var bottomMap = $('#map').position().top + $('#map').height();
                if (bottomMap < bottomTableRight) {
                    var heightMap = bottomTableRight - $(".center").position().top;
                    $('#map').css("height", heightMap);
                    // heightNewRect = heightMap;
                    // console.log("heightNewRect=" + heightNewRect + "heightMap=" + heightMap);
                }
            }
        });
    });

    function addConnBetweenFeature(propertyId) {
        // console.log(propertyId + ';' + $('#column5').val());
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var arrLTable = [];
        var arrRTable = [];
        var arrLRSide = [];
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/propertyid/' + $('#column5').val(),
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                // console.log(stringData);
                var arrData = JSON.parse(stringData);
                var arrId = [];
                console.log('количество записей=' + arrData.length);

                for (var i in arrData){
                    if (arrData[i].description.startsWith('l')) {
                        arrRow = [];
                        arrRow.push(arrData[i].id);
                        arrRow.push(arrData[i].colorThread);
                        arrRow.push(arrData[i].connectedTo);
                        arrRow.push(arrData[i].description);
                        // arrRow.push(arrData[i].label);
                        arrRow.push(sPageURL);
                        arrRow.push(arrData[i].propertyId);
                        arrRow.push(arrData[i].reserved);
                        arrLTable.push(arrRow);
                    } else {
                        arrRow = [];
                        arrRow.push(arrData[i].id);
                        arrRow.push(arrData[i].colorThread);
                        arrRow.push(arrData[i].connectedTo);
                        arrRow.push(arrData[i].description);
                        // arrRow.push(arrData[i].label);
                        arrRow.push(sPageURL);
                        arrRow.push(arrData[i].propertyId);
                        arrRow.push(arrData[i].reserved);
                        arrRTable.push(arrRow);
                    }
                    // arrId.push(arrData[i].id);
                }
                // console.log(arrLTable);
                // console.log(arrRTable);
                //надо проверять подключена сторона кабеля к другой муфте
                // console.log('количество подключений=' + countBetweenConnections(arrLTable));
                var flagLRTable = 'null';
                if (countBetweenConnections(arrLTable) == 0){
                    // arrAddInsideFeature.push(arrLTable);
                    flagLRTable = 'lTable';
                } else {
                    if (countBetweenConnections(arrRTable) == 0){
                        // arrAddInsideFeature.push(arrRTable);
                        flagLRTable = 'rTable';
                    }
                }
                console.log('flagLRTable=' + flagLRTable);
                if (flagLRTable != 'null') {  // если не подсоединена хотя бы одна сторона кабеля то подсоединяем и визуализируем
                    //сейчас будем подсоединять первую сторону кабеля и визуализировать
                    var numTable = 0;
                    $('table').each(function () {
                        console.log($(this).attr("id"));
                        numTable++;
                    });
                    numTable++;  //номер таблицы - следующий
                    console.log('numTable=' + numTable);
                    lrSelect = $('#leftRight').val();
                    //arrLRSide = arrLTable;  // если левая сторона не подключена
                    var arrTh;
                    var nameTable;
                    if (lrSelect == 'слева') {
                        arrLRSide = arrLTable;
                        arrTh = arrLRSide[1][6].split(';');
                        nameTable = 'ltable' + numTable;
                        $('#divleft').append('<div class="table-wrapper">');
                        $('#divleft').append('<table border="2" bgcolor="#fafad2" id="ltable' + numTable + '" align="right"><tr><td colspan="4">' + arrLRSide[0][6] + '</td></tr><tr><th>' + arrTh[0] + '</th><th>' + arrTh[1] + '</th><th>' + arrTh[2] + '</th><th>' + arrTh[3] + '</th></tr></table>');
                        $('#divleft').append('</div>');

                        for (var i = 2; i < arrLRSide.length; i++) {
                            if (flagLRTable == 'lTable') {
                                arrLTable[i][4] = arrLTable[i][4] + ';' + nameTable;
                            } else {
                                arrRTable[i][4] = arrRTable[i][4] + ';' + nameTable;
                            }

                            var strTableTd = arrLRSide[i][6].split(';');
                            // console.log(strTableTd);
                            var idTable = "#" + nameTable;
                            $(idTable).append('<tr><td>' + strTableTd[0] + '</td><td>' + strTableTd[1] + '</td><td>' + strTableTd[2] + '</td><td>' + strTableTd[3] + '</td></tr>');
                        }
                        // arrLTable[4] = arrLTable[4] + ';' + nameTable;
                        if (flagLRTable == 'lTable') {
                            arrAddInsideFeature.push(arrLTable);
                        } else {
                            arrAddInsideFeature.push(arrRTable);
                        }
                    } else {
                        arrLRSide = arrRTable;
                        arrTh = arrLRSide[1][6].split(';');
                        nameTable = 'rtable' + numTable;
                        $('#divright').append('<div class="table-wrapper">');
                        $('#divright').append('<table border="2" bgcolor="#fafad2" id="rtable' + numTable + '" align="left"><tr><td colspan="4">' + arrLRSide[0][6] + '</td></tr><tr><th>' + arrTh[0] + '</th><th>' + arrTh[1] + '</th><th>' + arrTh[2] + '</th><th>' + arrTh[3] + '</th></tr></table>');
                        $('#divright').append('</div>');

                        for (var i = 2; i < arrLRSide.length; i++) {
                            if (flagLRTable == 'lTable') {
                                arrLTable[i][4] = arrLTable[i][4] + ';' + nameTable;
                            } else {
                                arrRTable[i][4] = arrRTable[i][4] + ';' + nameTable;
                            }
                            var strTableTd = arrLRSide[i][6].split(';');
                            // console.log(strTableTd);
                            var idTable = "#" + nameTable;
                            $(idTable).append('<tr><td>' + strTableTd[0] + '</td><td>' + strTableTd[1] + '</td><td>' + strTableTd[2] + '</td><td>' + strTableTd[3] + '</td></tr>');
                        }
                        // arrRTable[4] = arrRTable[4] + ';' + nameTable;
                        if (flagLRTable == 'lTable') {
                            arrAddInsideFeature.push(arrLTable);
                        } else {
                            arrAddInsideFeature.push(arrRTable);
                        }
                    }
                    //если высота таблиц больше SVG-поля, увеличим его
                    $('table').each(function () {
                        console.log($(this).attr("id"));
                        var idAddTable = '#' + $(this).attr("id");
                        var bottomTableLeft = $(idAddTable).position().top + $(idAddTable).height();
                        var bottomMap = $('#map').position().top + $('#map').height();
                        if (bottomMap < bottomTableLeft) {
                            var heightMap = bottomTableLeft - $(".center").position().top;
                            $('#map').css("height", heightMap);
                        }
                    });

                    console.log(arrAddInsideFeature);
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord by propertyId')
            }
        });
    }

    function updateConnInsideFeature() {
        //делаем update соединениям в таблице ConnInsideFeature
        for (var i in arrConnInsideFeature){
            var JSONObject = {
                'id': arrConnInsideFeature[i][0],
                'colorThread': arrConnInsideFeature[i][1],
                'connectedTo': arrConnInsideFeature[i][2],
                'description': arrConnInsideFeature[i][3],
                'label': arrConnInsideFeature[i][4],
                'propertyId': arrConnInsideFeature[i][5],
                'reserved': arrConnInsideFeature[i][6]
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
    }

    //Удаляем соединения внутри Feature по PropertyId
    function delFeatureByPropertyId(propertyId) {
        console.log(propertyId);

        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/propertyid/' + propertyId,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                // console.log(stringData);
                var arrData = JSON.parse(stringData);
                var arrId = [];
                console.log('количество записей=' + arrData.length);
                for (var i in arrData){
                    arrId.push(arrData[i].id);
                }
                console.log(arrId);
                for (var i in arrId){
                    delFeatureById(arrId[i]);
                }
                delConnBetweenFeatureById(propertyId);
                getFeatureCoordById(propertyId);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord by propertyId')
            }
        });
    }

    function delFeatureById(idFeature) {
        //удаляем соединения внутри Feature по Id
        $.ajax({
            type: 'DELETE',
            url: service + 'conninsidefeature/delete?id=' + idFeature,
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('id=' + idFeature + ' удалена успешно');
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('id=' + idFeature + ' не удалена');
            }
        });
    }

    function getFeatureCoordById(sPageURL) {
        //получаем FeatureCoord by id
        // console.log('ID of FeatureCoord:' + sPageURL);
        $.ajax({
            type: 'GET',
            url: service + 'featurecoord/get/' + sPageURL,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                // console.log(stringData);
                var arrData = JSON.parse(stringData);
                var idFeatureCoord = arrData.id;
                // console.log('idFeatureCoord='+idFeatureCoord);
                var geometryType = arrData.geometryType;
                // console.log('geometryType='+geometryType);
                // var propertyId = arrData.propertyId;
                var label = arrData.label;
                // console.log('propertyId='+propertyId);
                var propertyName = arrData.propertyName;
                // console.log('propertyName='+propertyName);
                $("h3").html("Обрабатываем idFeatureCoord=" + idFeatureCoord + ', geometryType='+geometryType + ', label='+label + ', propertyName='+propertyName);
                //получим данные по этой Feature
                getConnInsideFeature(sPageURL);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord by propertyId')
            }
        });
    }
    
    function getConnInsideFeature(propertyId) {
        //отображаем соединения в муфте или кабеле
        console.log('getConnInsideFeature ID of FeatureCoord:' + propertyId);
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/propertyid/' + propertyId,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                console.log('количество записей=' + arrData.length);
                var headString = $('#h3_main').html();
                headString = headString + ', количество записей=' + arrData.length;
                $("h3").html(headString);
                console.log('headString=' + headString);
                //здесь будем визуализировать соединение в муфте или кабеле
                arrConnInsideFeature = [];
                for (var i in arrData){
                    var arrString = [];
                    arrString.push(arrData[i].id); //id
                    arrString.push(arrData[i].connectedTo); //connectedTo
                    arrString.push(arrData[i].propertyId); //properyId
                    arrString.push(arrData[i].colorThread); //colorThread
                    arrString.push(arrData[i].description); //description
                    arrString.push(arrData[i].label); //label
                    arrString.push(arrData[i].reserved); //reserved
                    arrConnInsideFeature.push(arrString);
                }
                console.log('arrConnInsideFeature.length= ' + arrConnInsideFeature.length);
                var nameTable = '';
                for (var i = 0; i < arrConnInsideFeature.length; i++) {  //обходим строки массива
                     // console.log(arrConnInsideFeature[i]);
                    var arrNameTable = arrConnInsideFeature[i][4].split(';');
                    console.log(arrNameTable);
                    if (arrNameTable[0] != nameTable){
                        nameTable = arrNameTable[0]; //добавляем таблицу
                        // console.log(nameTable);
                       if (Number(arrNameTable[1]) == 0) {  //если это заголовочная строка
                           if (nameTable.startsWith('l')) {  //если это таблица слева
                               var strTableTh = arrConnInsideFeature[i+1][6];
                                var arrTableTh = strTableTh.split(';');
                               // console.log(arrTableTh);
                                $('#divleft').append('<div class="table-wrapper">');
                                $('#divleft').append('<table border="2" bgcolor="#fafad2" id="' + nameTable + '" align="right"><tr><td colspan="4">' + arrConnInsideFeature[i][6] + '</td></tr><tr><th>' + arrTableTh[0] + '</th><th>' + arrTableTh[1] + '</th><th>' + arrTableTh[2] + '</th><th>' + arrTableTh[3] + '</th></tr></table>');
                                $('#divleft').append('</div>');
                            } else {  //если это таблица справа
                               var strTableTh = arrConnInsideFeature[i+1][6];
                               var arrTableTh = strTableTh.split(';');
                               // console.log(arrTableTh);
                               $('#divright').append('<div class="table-wrapper">');
                               $('#divright').append('<table border="2" bgcolor="#fafad2" id="' + nameTable + '" align="left"><tr><td colspan="4">' + arrConnInsideFeature[i][6] + '</td></tr><tr><th>' + arrTableTh[0] + '</th><th>' + arrTableTh[1] + '</th><th>' + arrTableTh[2] + '</th><th>' + arrTableTh[3] + '</th></tr></table>');
                               $('#divright').append('</div>');
                           }
                       }
                    } else {
                       if (Number(arrNameTable[1]) > 1) {  //если это не заголовочная строка
                           if (nameTable.startsWith('l')) {  //если это таблица слева
                                var strTableTd = arrConnInsideFeature[i][6].split(';');
                                console.log(strTableTd);
                                var idTable = "#" + nameTable;
                               $(idTable).append('<tr><td>' + strTableTd[0] + '</td><td>' + strTableTd[1] + '</td><td>' + strTableTd[2] + '</td><td>' + strTableTd[3] + '</td></tr>');
                           } else {  //если это таблица справа
                               var strTableTd = arrConnInsideFeature[i][6].split(';');
                               console.log(strTableTd);
                               var idTable = "#" + nameTable;
                               $(idTable).append('<tr><td>' + strTableTd[0] + '</td><td>' + strTableTd[1] + '</td><td>' + strTableTd[2] + '</td><td>' + strTableTd[3] + '</td></tr>');
                           }
                       }
                    }
                }
                //если высота таблиц больше SVG-поля, увеличим его
                $('table').each(function () {
                    console.log($(this).attr("id"));
                    var idAddTable = '#' + $(this).attr("id");
                    var bottomTableLeft = $(idAddTable).position().top + $(idAddTable).height();
                    var bottomMap = $('#map').position().top + $('#map').height();
                    if (bottomMap < bottomTableLeft) {
                        var heightMap = bottomTableLeft - $(".center").position().top;
                        $('#map').css("height", heightMap);
                    }
                });
                //отрисуем соединения//
                  //получим массив соединений
                connTabs = [];
                var row = [];
                for (var i = 0; i < arrConnInsideFeature.length; i++) {  //обходим строки массива
                    if (arrConnInsideFeature[i][1] > 0){  //если с кем-то соединен
                        var descriptionStr1 = arrConnInsideFeature[i][4];
                        var connectedToId = arrConnInsideFeature[i][1];
                        var colorThreadStr = arrConnInsideFeature[i][3];
                        var descriptionStr2 = '';
                        for (var n = i; n < arrConnInsideFeature.length; n++){  //обходим оставшуюся часть массива
                            if (arrConnInsideFeature[n][0] == connectedToId){
                                descriptionStr2 = arrConnInsideFeature[n][4];
                            }
                        }
                        if (descriptionStr2.length > 1){  //если нашлась вторая половина
                            var arrTable1 = descriptionStr1.split(';');
                            row.push(arrTable1[0]);
                            row.push(Number(arrTable1[1])+1);
                            var arrTable2 = descriptionStr2.split(';');
                            row.push(arrTable2[0]);
                            row.push(Number(arrTable2[1])+1);
                            row.push(colorThreadStr);
                            connTabs.push(row);
                        }
                        row = [];
                    }
                }
                console.log(connTabs);
                //визуализируем массив соединений
                for (var i in connTabs){
                    var cntRowsTable1 = $('#' + connTabs[i][0] + ' tr').length;  //получаем количество строк в таблице 1
                    var cntRowsTable2 = $('#' + connTabs[i][2] + ' tr').length;  //получаем количество строк в таблице 2
                    // console.log('cntRowsTable1=' + cntRowsTable1 + ' cntRowsTable2=' + cntRowsTable2);

                    var toptab1 = $('#' + connTabs[i][0]).position().top;        //получаем расстояние до таблицы 1 от верха
                    var toptab2 = $('#' + connTabs[i][2]).position().top;        //получаем расстояние до таблицы 2 от верха

                    var heigtab1 = $('#' + connTabs[i][0]).height();             //получаем высоту таблицы 1
                    var heigtab2 = $('#' + connTabs[i][2]).height();             //получаем высоту таблицы 2

                    var distdivtab1 = toptab1 - $(".center").position().top;//получаем начальную координату для рисования
                    var distdivtab2 = toptab2 - $(".center").position().top;//получаем начальную координату для рисования

                    var y1 = distdivtab1 + (heigtab1/cntRowsTable1)* connTabs[i][1] - (heigtab1/cntRowsTable1)/2;  //вычисляем координату Y для начала линии таблицы 1
                    var y2 = distdivtab2 + (heigtab2/cntRowsTable2)*connTabs[i][3] - (heigtab2/cntRowsTable2)/2;  //вычисляем координату Y для конца линии таблицы 2

                    var x1;
                    var x2;
                    if(connTabs[i][0].startsWith('l')){
                        x1 = 0;
                    } else {
                        x1 = 400;
                    }
                    if(connTabs[i][2].startsWith('l')){
                        x2 = 0;
                    } else {
                        x2 = 400;
                    }
                    console.log('cntRowsTable1=' + cntRowsTable1 + ' cntRowsTable2=' + cntRowsTable2 + ' x1=' + x1 + ' x2=' + x2 + ' y1=' + y1 + ' y2=' + y2 + ' xCoord=' + xCoord);
                    var newLine = document.createElementNS('http://www.w3.org/2000/svg','polyline');
                    newLine.setAttribute('points', x1 + ',' + y1 + ' ' + xCoord + ',' + y1 + ' ' + xCoord + ',' + y2 + ' ' + x2 + ',' + y2 );
                    newLine.setAttribute("stroke", connTabs[i][4]);
                    newLine.setAttribute("fill", "white");
                    newLine.setAttribute("fill-opacity", "0");
                    newLine.setAttribute("stroke-width", "2px");
                    $("#map").append(newLine);
                    xCoord = xCoord - 6;
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord by propertyId')
            }
        });
    }

    function checkEnter(key) {
        console.log("checkEnter" + key);
        if (key == 'Enter'){
            appTrToTab();
            $('#column3').focus();
            $('#column3').select();
        }
    }

    function appTrToTab() {
        {
            var nametable;
            var colArr = [];
            var rowArr = [];
            var idTable;
            if (lrSelect == 'слева') {
                idTable = "#ltable" + curTableNum;
                $(idTable).append('<tr><td>' + $('#column1').val() + '</td><td>' + $('#column2').val() + '</td><td>' + $('#column3').val() + '</td><td>' + $('#column4').val() + '</td></tr>');
                //добавим в класс свойства
                nametable = "ltable" + curTableNum;
            } else {
                idTable = "#rtable" + curTableNum;
                $(idTable).append('<tr><td>' + $('#column1').val() + '</td><td>' + $('#column2').val() + '</td><td>' + $('#column3').val() + '</td><td>' + $('#column4').val() + '</td></tr>');
                //добавим в класс свойства
                nametable = "rtable" + curTableNum;
            }
            //если высота таблиц больше SVG-поля, увеличим его
            var bottomTable = $(idTable).position().top + $(idTable).height();
            // $("#mytext").html(bottomTable);
            var bottomMap = $('#map').position().top + $('#map').height();
            if (bottomMap < bottomTable) {
                var heightMap = bottomTable - $(".center").position().top;
                $('#map').css("height", heightMap);
                heightNewRect = heightMap;
                // console.log("heightNewRect=" + heightNewRect + "heightMap=" + heightMap);
            }
        }
        colArr.push($('#column1').val());
        colArr.push($('#column2').val());
        colArr.push($('#column3').val());
        colArr.push($('#column4').val());
        // rowArr.push(colArr);
        tables[nametable].push(colArr);
    }

    function countBetweenConnections(arrTable) {
        console.log('countBetweenConnections: ищем количество подключений');
        // console.log(arrTable);
        var countConnections = 0;
        for (var i in arrTable) {
            $.ajax({
                type: 'GET',
                url: service + 'connbetweenfeature/getconnbetweenbyid/' + arrTable[i][0],
                dataType: 'json',
                async: false,
                success: function (result) {
                    var stringData = JSON.stringify(result);
                    arrData = JSON.parse(stringData);
                    countConnections = countConnections + arrData.length;
                },
                error: function (jqXHR, testStatus, errorThrown) {
                    // $('#tableCable').html(JSON.stringify(jqXHR))
                    console.log(JSON.stringify(jqXHR));
                }
            });
        }

        return countConnections;
    }

    //проверяем муфта это или кабель, если муфта сохраняем внешние соединения
    function saveBetweenConnIfPoint(propertyId) {
        $.ajax({
            type: 'GET',
            url: service + 'featurecoord/get/' + propertyId,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                // console.log(stringData);
                var arrData = JSON.parse(stringData);
                // var idFeatureCoord = arrData.id;
                // console.log('idFeatureCoord='+idFeatureCoord);
                var geometryType = arrData.geometryType;
                console.log('geometryType='+geometryType);
                if (geometryType == 'Point'){
                    console.log('Обрабатываем как муфту, сохраняем внешние соединения');
                    console.log('arrConnInsideFeature:');
                    console.log(arrConnInsideFeature);
                    console.log('arrAddInsideFeature:');
                    console.log(arrAddInsideFeature);
                    for (var i in arrAddInsideFeature){
                        var tableInArrInsideFeature = arrAddInsideFeature[i];
                        // console.log(tableInArrInsideFeature);
                        for (var n in tableInArrInsideFeature){
                            var strInArrInsideFeature = tableInArrInsideFeature[n];
                            var labelInStr = strInArrInsideFeature[4];
                            var descrInStr = strInArrInsideFeature[3];
                            var arrlabel = labelInStr.split(';');
                            var arrdescr = descrInStr.split(';');
                            if (arrlabel.length > 1) {
                                console.log(strInArrInsideFeature);
                                for (var k in arrConnInsideFeature){
                                    arrDesPageTable = (arrConnInsideFeature[k][3]).split(';');
                                    if ((arrDesPageTable[0] == arrlabel[1]) && (arrDesPageTable[1] == arrdescr[1])){
                                        var connId1 = arrConnInsideFeature[k][0];
                                        var connId2 = strInArrInsideFeature[0];
                                        // var idOneTwo = arrlabel[0] + ';'  + strInArrInsideFeature[5];
                                        var arrIdOneTwo = [];
                                        arrIdOneTwo.push(connId1);
                                        arrIdOneTwo.push(connId2);
                                        arrIdOneTwo.push(arrlabel[0]);  //propertyId нашей муфты
                                        arrIdOneTwo.push(strInArrInsideFeature[5]);  //propertyId подсоединенного кабеля
                                        addBaseConnBetweenFeature(arrIdOneTwo);
                                        // console.log('arrConnInsideFeature[k][0]=' + arrConnInsideFeature[k][0] + ', strInArrInsideFeature[0]=' + strInArrInsideFeature[0] +', id1;id2=' + idOneTwo);
                                        // console.log('connId1=' + connId1 + ', connId2=' + connId2 +', propId1;propId2=' + idOneTwo);
                                    }
                                }
                            }
                        }
                    }
                } else {
                    console.log('Обрабатываем как кабель, не сохраняем внешние соединения');
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord by propertyId')
            }
        });
    }

    //заносим в базу внешнее соединение
    function addBaseConnBetweenFeature(arrIdOneTwo) {
        console.log('arrIdOneTwo[0]=' + arrIdOneTwo[0] + ', arrIdOneTwo[1]=' + arrIdOneTwo[1] + ', arrIdOneTwo[2]=' + arrIdOneTwo[2]);
        var Data = {};
        var JSONObject = {
            'connId1': arrIdOneTwo[0],
            'connId2': arrIdOneTwo[1],
            'description': arrIdOneTwo[2],
            'reserved' : arrIdOneTwo[3]
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
                var stringData = JSON.stringify(result);
                Data = JSON.parse(stringData);
                console.log(Data);

            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('ошибка добавления connbetweenfeature');
            }
        });
    }

    //удаляем внешнее соединение по ID
    function delConnBetweenFeatureById(propertyId) {
    console.log('delConnBetweenFeatureById, propertyId=' + propertyId);
        $.ajax({
            type: 'DELETE',
            url: service + 'connbetweenfeature/delbydescription/' + propertyId,
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('Успешное удаление ConnBetweenFeature by ID=' + propertyId);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Ошибка удаления ConnBetweenFeature by ID=' + propertyId);
            }
        });
    }

    //изменяем в заголовке количество записей
    function changeHeaderCountRows(propertyId) {
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/propertyid/' + propertyId,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                console.log('количество записей=' + arrData.length);
                var headString = $('#h3_main').html();
                var arrHeadString = headString.split(',');
                arrHeadString[4] = ', количество записей=' + arrData.length;
                headString = '';
                for (var i in arrHeadString){
                    headString = headString + arrHeadString[i];
                }
                $("h3").html(headString);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Ошибка отображения заголовка по ID=' + propertyId);
            }
        });
    }

    //находим количество строк в таблицах муфты, здесь заполняем массив arrConnInsideFeature
    function getCountInsideRows(propertyId) {
        var countInsideRows;
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/propertyid/' + propertyId,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                countInsideRows = arrData.length;
                console.log('количество записей=' + arrData.length);
                arrConnInsideFeature = [];
                for (var i in arrData){
                    var arrString = [];
                    arrString.push(arrData[i].id); //id
                    arrString.push(arrData[i].connectedTo); //connectedTo
                    arrString.push(arrData[i].propertyId); //properyId
                    arrString.push(arrData[i].colorThread); //colorThread
                    arrString.push(arrData[i].description); //description
                    arrString.push(arrData[i].label); //label
                    arrString.push(arrData[i].reserved); //reserved
                    arrConnInsideFeature.push(arrString);
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord by propertyId')
            }
        });
        return countInsideRows;
    }

    //здесь делаем update муфте если уже существует
    function updateConnInsideIfExist(propertyId) {
        console.log('updateConnInsideIfExist если муфта уже существует, propertyId=' + propertyId);
        // var propertyId = decodeURIComponent(window.location.search.substring(1));
        var currTableId;
        var currTrInd;
        var cell1;
        var cell2;
        var cell3;
        var cell4;
        var arrDifferenceUpdateAndConn = [];
        arrUpdateInsideFeature = [];
        $('table tr').each(function () {
            currTableId = $(this).closest('table').attr('id');
            currTrInd = $(this).index();
            arrString = [];
            if (currTrInd == 0) {
                arrString.push('null'); //поле 0: id
                arrString.push('null'); //поле 1: colorThread
                arrString.push('null'); //поле 2: connectedTo
                arrString.push(currTableId + ';' + currTrInd); //поле 3: description
                arrString.push('null'); //поле 4: label
                arrString.push(propertyId); //поле 5: propertyId
                cell1 = $(this).find('td').eq(0).text();
                arrString.push(cell1); //поле 6: reserved
                // console.log(arrString);
            }
            if (currTrInd == 1) {
                arrString.push('null'); //поле 0: id
                arrString.push('null'); //поле 1: colorThread
                arrString.push('null'); //поле 2: connectedTo
                arrString.push(currTableId + ';' + currTrInd); //поле 3: description
                arrString.push('null'); //поле 4: label
                arrString.push(propertyId); //поле 5: propertyId
                cell1 = $(this).find('th').eq(0).text();
                cell2 = $(this).find('th').eq(1).text();
                cell3 = $(this).find('th').eq(2).text();
                cell4 = $(this).find('th').eq(3).text();
                arrString.push(cell1 + "; " + cell2 + "; " + cell3 + "; " + cell4); //поле 6: reserved
                // console.log(arrString);
            }
            if (currTrInd > 1) {
                arrString.push('null'); //поле 0: id
                arrString.push('null'); //поле 1: colorThread
                arrString.push('null'); //поле 2: connectedTo
                arrString.push(currTableId + ';' + currTrInd); //поле 3: description
                arrString.push('null'); //поле 4: label
                arrString.push(propertyId); //поле 5: propertyId
                cell1 = $(this).find('td').eq(0).text();
                cell2 = $(this).find('td').eq(1).text();
                cell3 = $(this).find('td').eq(2).text();
                cell4 = $(this).find('td').eq(3).text();
                arrString.push(cell1 + "; " + cell2 + "; " + cell3 + "; " + cell4); //поле 6: reserved
                // console.log(arrString);
            }
            arrUpdateInsideFeature.push(arrString);
        });
        //создаем массив differenceUpdateAndConn - разницу между arrUpdateInsideFeature и arrConnInsideFeature
        for (var i in arrUpdateInsideFeature){
            var flagDiff = true;
            for (var k in arrConnInsideFeature){
                if (arrUpdateInsideFeature[i][3] == arrConnInsideFeature[k][4]){  //label
                    flagDiff = false;
                    break;
                }
            }
            if (flagDiff == true){
                arrDifferenceUpdateAndConn.push(arrUpdateInsideFeature[i]);
            }
        }
        //
        console.log('arrUpdateInsideFeature:');
        for (var i in arrUpdateInsideFeature) {
            console.log(arrUpdateInsideFeature[i]);
        }
        //
        arrUpdateInsideFeature = [];
        for (var i in arrDifferenceUpdateAndConn){
            var JSONObject = {
                'description': arrDifferenceUpdateAndConn[i][3],
                'propertyId': arrDifferenceUpdateAndConn[i][5],
                'reserved': arrDifferenceUpdateAndConn[i][6]

            };
            $.ajax({
                type: 'POST',
                url: service + "conninsidefeature/add",
                contentType: 'application/json;charset=utf-8',
                data: JSON.stringify(JSONObject),
                dataType: 'json',
                async: false,
                success: function (result) {
                    var arrString = [];
                    var stringData = JSON.stringify(result);
                    var objData = JSON.parse(stringData);
                    arrString[0] = objData.id;
                    arrString[1] = objData.colorThread;
                    arrString[2] = objData.connectedTo;
                    arrString[3] = objData.description;
                    arrString[4] = objData.label;
                    arrString[5] = objData.propertyId;
                    arrString[6] = objData.reserved;
                    // console.log(arrString);
                    arrUpdateInsideFeature.push(arrString);
                },
                error: function (jqXHR, testStatus, errorThrown) {
                    console.log('ошибка добавления conninsidefeature');
                }
            });
        }
        //сохраняем соединения между строками
        //сначала получим arrConnInsideFeature здесь массив в формате arrUpdateInsideFeature (согласен, говнокод, но ничего не поделаешь)
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/propertyid/' + propertyId,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                // console.log(stringData);
                var arrData = JSON.parse(stringData);
                // console.log('количество записей=' + arrData.length);
                arrConnInsideFeature = [];
                for (var i in arrData){
                    var arrString = [];
                    arrString.push(arrData[i].id); //id
                    arrString.push(arrData[i].colorThread); //colorThread
                    arrString.push(arrData[i].connectedTo); //connectedTo
                    arrString.push(arrData[i].description); //description
                    arrString.push(arrData[i].label); //label
                    arrString.push(arrData[i].propertyId); //properyId
                    arrString.push(arrData[i].reserved); //reserved
                    arrConnInsideFeature.push(arrString);
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord by propertyId')
            }
        });
        console.log('arrConnInsideFeature:');
        for (var i in arrConnInsideFeature) {
            console.log(arrConnInsideFeature[i]);
        }
        var firstConn = [];
        var secondConn = [];
        var colorConn = [];
        //обрабатываем первую половину соединения
        for (var i in connTabs) {
            console.log(connTabs[i][0] + ',' + connTabs[i][1] + ',' + connTabs[i][2] + ',' + connTabs[i][3] + ',' + connTabs[i][4]);
            for (var n in arrConnInsideFeature) {
                var arrTableId = arrConnInsideFeature[n][3].split(';');
                var toConnTabs = Number(arrTableId[1]) + 1;
                // console.log(toConnTabs);
                if ((arrTableId[0] == connTabs[i][0]) && (toConnTabs == connTabs[i][1])) {
                    console.log(arrConnInsideFeature[n][3] + ', id=' + arrConnInsideFeature[n][0]);
                    firstConn.push(arrConnInsideFeature[n][0]);
                }
            }
        }
        //обрабатываем вторую половину соединения
        for (var i in connTabs) {
            console.log(connTabs[i][0] + ',' + connTabs[i][1] + ',' + connTabs[i][2] + ',' + connTabs[i][3] + ',' + connTabs[i][4]);
            for (var n in arrConnInsideFeature) {
                var arrTableId = arrConnInsideFeature[n][3].split(';');
                var toConnTabs = Number(arrTableId[1]) + 1;
                // console.log(toConnTabs);
                if ((arrTableId[0] == connTabs[i][2]) && (toConnTabs == connTabs[i][3])) {
                    console.log(arrConnInsideFeature[n][3] + ', id=' + arrConnInsideFeature[n][0]);
                    secondConn.push(arrConnInsideFeature[n][0]);
                    colorConn.push(connTabs[i][4]);
                }
            }
        }
        //удалим все соединения из arrConnInsideFeature
        for (var i in arrConnInsideFeature){
            arrConnInsideFeature[i][1] = 'null';
            arrConnInsideFeature[i][2] = 0;
        }

        //Делаем Update массиву соединений
        for (var i in firstConn) {
            for (n in arrConnInsideFeature) {
                if (firstConn[i] == arrConnInsideFeature[n][0]) {
                    arrConnInsideFeature[n][2] = secondConn[i];
                    arrConnInsideFeature[n][1] = colorConn[i];
                }
            }
        }
        for (var i in secondConn) {
            for (n in arrConnInsideFeature) {
                if (secondConn[i] == arrConnInsideFeature[n][0]) {
                    arrConnInsideFeature[n][2] = firstConn[i];
                    arrConnInsideFeature[n][1] = colorConn[i];
                }
            }
        }
        //Делаем Update базы
        updateConnInsideFeature();

        // изменяем в заголовке количество записей
        changeHeaderCountRows(propertyId);

        //если это муфта будем сохранять внешние соединения
        saveBetweenConnIfPoint(propertyId);

        console.log('connTabs:');
        for (var i in connTabs) {
            console.log(connTabs[i]);
        }
        console.log('firstConn:');
        for (var i in firstConn) {
            console.log(firstConn[i]);
        }
        console.log('secondConn:');
        for (var i in secondConn) {
            console.log(secondConn[i]);
        }
        console.log('colorConn:');
        for (var i in colorConn) {
            console.log(colorConn[i]);
        }

        console.log('arrConnInsideFeature:');
        for (var i in arrConnInsideFeature) {
            console.log(arrConnInsideFeature[i]);
        }
        /*console.log('arrDifferenceUpdateAndConn:');
        for (var i in arrDifferenceUpdateAndConn) {
            console.log(arrDifferenceUpdateAndConn[i]);
        }*/
        /*console.log('arrUpdateInsideFeature:');
        for (var i in arrUpdateInsideFeature) {
            console.log(arrUpdateInsideFeature[i]);
        }*/

        /*console.log('arrAddInsideFeature:');
        for (var i in arrAddInsideFeature) {
            console.log(arrAddInsideFeature[i]);
        }*/
    }

    //получаем высоту белого квадрата между таблицами
    function getHeightNewRect() {
        $('table').each(function () {
            console.log('Имеется таблица:' + $(this).attr("id"));
        var idTable = '#' + $(this).attr("id");

        var bottomTable = $(idTable).position().top + $(idTable).height();
        var bottomMap = $('#map').position().top + $('#map').height();
        if (bottomMap < bottomTable) {
            var heightMap = bottomTable - $(".center").position().top;
            $('#map').css("height", heightMap);
            heightNewRect = heightMap;
        } else {
            heightNewRect = bottomMap;

        }
            console.log("heightNewRect=" + heightNewRect + ", heightMap=" + heightMap + ', bottomTable=' + bottomTable);
    });
    }

</script>
<div class=".head h3">
    <h3 id="h3_main">Настраиваем Feature</h3>
</div>
<div>
    <input id="column1" placeholder="поле 1"/>
    <input id="column2" placeholder="поле 2"/>
    <input id="column3" placeholder="поле 3"/>
    <input id="column4" placeholder="поле 4" onkeypress="checkEnter(event.key)"/>
    <input id="column5" placeholder="Заголовок"/>
    <!--<p id="mytext">any text</p>-->

</div>

<div class="main">
    <div id='cssmenu'>
        <div>
            <label>Добавить таблицу:</label>
            <select name="leftRight" id="leftRight">
                <option value="слева">слева</option>
                <option value="справа">справа</option>
            </select>
        </div>
        <div>
            <label>Цвет соединения:</label>
            <select name="colorSelect" id="colorSelect">
                <option value="black">черный</option>
                <option value="red" id="redopt">красный</option>
                <option value="green">зеленый</option>
                <option value="blue">синий</option>
            </select>
        </div>

        <ul>
            <li class='active' id="btnAddTable"><a href='#'><span>Добавить таблицу</span></a></li>
            <li id="btnAppend"><a href='#'><span>Увеличить таблицу</span></a></li>
            <li id="connTable"><a href='#'><span>Подключить таблицу</span></a></li>
            <li id="btn1"><a href='#'><span>Добавить соединение</span></a></li>
            <li id="breakConn"><a href='#'><span>Разорвать соединение</span></a></li>
            <li id="makeCable"><a href='#'><span>Создать кабель</span></a></li>
            <li id="makeTrassa"><a href='#'><span>Трассировка волокна</span></a></li>
            <li id="getfeature"><a href='#'><span>Получить данные</span></a></li>
            <li id="delfeature"><a href='#'><span>Удалить данные</span></a></li>
            <li id="saveAll"><a href='#'><span>Сохранить данные</span></a></li>
            <li id="saveAsFromTemplate"><a href='#'><span>Сохранить как из шаблона</span></a></li>
            <li id="addSplitter"><a href='#'><span>Добавить сплиттер</span></a></li>
        </ul>
    </div>
    <div class="wrapper">
        <div class="left" id="divleft">
        </div>
        <div class="center">
            <svg height="50" width="400" id="map">
                <!--<polyline points="0,40 40,40 40,80 80,80 80,120 120,120 300,160"
                          style="fill:white;stroke:red;stroke-width:4px" />-->
            </svg>
        </div>
        <div class="right" id="divright">
        </div>
    </div>
</div>
</body>
</html>
