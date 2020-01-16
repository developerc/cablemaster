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
    var service = 'http://10.152.46.71:8080/';
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
    var heightNewRect = 50;
    var arrTabs = [];
    var arrConnInsideFeature = []; //массив строк таблиц соединений
    var arrString = []; //Массив строки полей. В нем 0-id, 1-colorThread, 2-connectedTo, 3-description, 4-label, 5-propertyId, 6-reserved

    $(document).ready(function(){
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
            console.log("удаляем строку " + connTabsMarked);
            connTabs.splice(connTabsMarked,1);
            connTabsMarked = -1;
            /*for (var i in connTabs) {
                console.log(connTabs[i][0] + ','+ connTabs[i][1] + ','+connTabs[i][2] + ','+connTabs[i][3] + ','+connTabs[i][4] + ',');
            }*/



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
            console.log("сохраняем соединения");
            //сохраняем строки таблиц
            $('table tr').each(function () {
                currTableId = $(this).closest('table').attr('id');
                currTrInd = $(this).index();
                arrString = [];
                if (currTrInd == 0){
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
                if (currTrInd == 1){
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
                if (currTrInd > 1){
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
            console.log(arrConnInsideFeature);
            //сохраняем соединения между строками
            var firstConn = [];
            var secondConn = [];
            var colorConn = [];
            //обрабатываем первую половину соединения
            for (var i in connTabs){
                console.log(connTabs[i][0] + ','+ connTabs[i][1] + ','+connTabs[i][2] + ','+connTabs[i][3] + ','+connTabs[i][4] );
                for (var n in arrConnInsideFeature){
                    var arrTableId = arrConnInsideFeature[n][3].split(';');
                    var toConnTabs = Number(arrTableId[1]) + 1;
                    // console.log(toConnTabs);
                    if ((arrTableId[0] == connTabs[i][0]) && (toConnTabs  == connTabs[i][1]) ) {
                        console.log(arrConnInsideFeature[n][3] + ', id=' + arrConnInsideFeature[n][0]);
                        firstConn.push(arrConnInsideFeature[n][0]);
                    }
                }
            }
            //обрабатываем вторую половину соединения
            for (var i in connTabs){
                console.log(connTabs[i][0] + ','+ connTabs[i][1] + ','+connTabs[i][2] + ','+connTabs[i][3] + ','+connTabs[i][4] );
                for (var n in arrConnInsideFeature){
                    var arrTableId = arrConnInsideFeature[n][3].split(';');
                    var toConnTabs = Number(arrTableId[1]) + 1;
                    // console.log(toConnTabs);
                    if ((arrTableId[0] == connTabs[i][2]) && (toConnTabs  == connTabs[i][3]) ) {
                        console.log(arrConnInsideFeature[n][3] + ', id=' + arrConnInsideFeature[n][0]);
                        secondConn.push(arrConnInsideFeature[n][0]);
                        colorConn.push(connTabs[i][4]);
                    }
                }
            }
            //Делаем Update массиву соединений
            for (var i in firstConn){
                for (n in arrConnInsideFeature){
                    if (firstConn[i] == arrConnInsideFeature[n][0]){
                        arrConnInsideFeature[n][2] = secondConn[i];
                        arrConnInsideFeature[n][1] = colorConn[i];
                    }
                }
            }
            for (var i in secondConn){
                for (n in arrConnInsideFeature){
                    if (secondConn[i] == arrConnInsideFeature[n][0]){
                        arrConnInsideFeature[n][2] = firstConn[i];
                        arrConnInsideFeature[n][1] = colorConn[i];
                    }
                }
            }
            //Делаем Update базы
            updateConnInsideFeature();

            //просмотр массивов
            console.log('firstConn= ...');
            for (var i in firstConn){
                console.log(firstConn[i]);
            }
            console.log('secondConn= ...');
            for (var i in secondConn){
                console.log(secondConn[i]);
            }
            console.log('colorConn= ...');
            for (var i in colorConn){
                console.log(colorConn[i]);
            }
            console.log(arrConnInsideFeature);
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
    });

    function addConnBetweenFeature(propertyId) {
        // console.log(propertyId + ';' + $('#column5').val());
        var arrLTable = [];
        var arrRTable = [];
        var arrLRSide = []
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
                        arrRow.push(arrData[i].label);
                        arrRow.push(arrData[i].propertyId);
                        arrRow.push(arrData[i].reserved);
                        arrLTable.push(arrRow);
                    } else {
                        arrRow = [];
                        arrRow.push(arrData[i].id);
                        arrRow.push(arrData[i].colorThread);
                        arrRow.push(arrData[i].connectedTo);
                        arrRow.push(arrData[i].description);
                        arrRow.push(arrData[i].label);
                        arrRow.push(arrData[i].propertyId);
                        arrRow.push(arrData[i].reserved);
                        arrRTable.push(arrRow);
                    }
                    // arrId.push(arrData[i].id);
                }
                console.log(arrLTable);
                console.log(arrRTable);
                //надо проверять подключена сторона кабеля к другой муфте
                console.log('количество подключений=' + countBetweenConnections(arrLTable));

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
                        var strTableTd = arrLRSide[i][6].split(';');
                        // console.log(strTableTd);
                        var idTable = "#" + nameTable;
                        $(idTable).append('<tr><td>' + strTableTd[0] + '</td><td>' + strTableTd[1] + '</td><td>' + strTableTd[2] + '</td><td>' + strTableTd[3] + '</td></tr>');
                    }
                } else {
                    arrLRSide = arrRTable;
                    arrTh = arrLRSide[1][6].split(';');
                    nameTable = 'rtable' + numTable;
                    $('#divright').append('<div class="table-wrapper">');
                    $('#divright').append('<table border="2" bgcolor="#fafad2" id="rtable' + numTable + '" align="left"><tr><td colspan="4">' + arrLRSide[0][6] + '</td></tr><tr><th>' + arrTh[0] + '</th><th>' + arrTh[1] + '</th><th>' + arrTh[2] + '</th><th>' + arrTh[3] + '</th></tr></table>');
                    $('#divright').append('</div>');

                    for (var i = 2; i < arrLRSide.length; i++) {
                        var strTableTd = arrLRSide[i][6].split(';');
                        // console.log(strTableTd);
                        var idTable = "#" + nameTable;
                        $(idTable).append('<tr><td>' + strTableTd[0] + '</td><td>' + strTableTd[1] + '</td><td>' + strTableTd[2] + '</td><td>' + strTableTd[3] + '</td></tr>');
                    }
                }
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
                var propertyId = arrData.propertyId;
                // console.log('propertyId='+propertyId);
                var propertyName = arrData.propertyName;
                // console.log('propertyName='+propertyName);
                $("h3").html("Обрабатываем idFeatureCoord=" + idFeatureCoord + ', geometryType='+geometryType + ', propertyId='+propertyId + ', propertyName='+propertyName);
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

    /*var GetURLparameter = function () {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        console.log('GetURLparameter:' + sPageURL);
        $("h3.head").html("Обрабатываем feature id=" + sPageURL);
    }*/


    // GetURLparameter();
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
            <li id="getfeature"><a href='#'><span>Получить данные</span></a></li>
            <li id="delfeature"><a href='#'><span>Удалить данные</span></a></li>
            <li id="saveAll"><a href='#'><span>Сохранить данные</span></a></li>
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
