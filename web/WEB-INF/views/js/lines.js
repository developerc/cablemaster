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
            if (currTrInd == 0){
                cell1 = $(this).find('td').eq(0).text();
                console.log(currTableId + ", " + currTrInd + ", " + cell1);
            }
            if (currTrInd == 1){
                cell1 = $(this).find('th').eq(0).text();
                cell2 = $(this).find('th').eq(1).text();
                cell3 = $(this).find('th').eq(2).text();
                cell4 = $(this).find('th').eq(3).text();
                console.log(currTableId + ", " + currTrInd + ", " + cell1 + ", " + cell2 + ", " + cell3 + ", " + cell4);
            }
            if (currTrInd > 1){
                cell1 = $(this).find('td').eq(0).text();
                cell2 = $(this).find('td').eq(1).text();
                cell3 = $(this).find('td').eq(2).text();
                cell4 = $(this).find('td').eq(3).text();

                console.log(currTableId + ", " + currTrInd + ", " + cell1 + ", " + cell2 + ", " + cell3 + ", " + cell4);
            }

        });
        //сохраняем соединения между строками
        for (var i in connTabs){
            console.log(connTabs[i][0] + ','+ connTabs[i][1] + ','+connTabs[i][2] + ','+connTabs[i][3] + ','+connTabs[i][4] );
        }
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
});

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



