<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Map schema</title>
    <link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>

    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
</head>
<body>
<div id="map" class="map">
</div>
<form class="form-inline">
    <input type="text" id="propertyId" value="propertyId" size="30">
    <input type="checkbox" name="cb1" id="check1" value="0"/>
</form>
<script>
    var arrData;
    var colorThread = '';
    var colorModule = '';
    var strokeColor = '';
    var strokeColorM = '';
    var idPropertyName = '';
    var singleRad = Math.PI/90;
    var featurePropertyName = '';
    var arrAngleRad = [];
    var arrNextAngle = [];
    var arrItemsPropertyId = [];
    var objNextAngle = {};
    var arrCenter =[];
    var arrCoordsFeature = [];
    var arrSingleLine = [];
    var angleRad = 0;
    var radiusDependZoom = 0;
    var service = 'http://10.152.46.71:8080/';
    var colorInside = '#000000';
    var raster = new ol.layer.Tile({
        source: new ol.source.OSM()
    });
    var vectorSource = new ol.source.Vector({});
    var layer2 = new ol.layer.Vector({
        source: vectorSource/*,
        style: new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
                color: '#3428ff',
                width: 2
            }),
            image: new ol.style.Circle({
                radius: 7,
                fill: new ol.style.Fill({
                    color: '#3428ff'
                })
            })
        })*/
    });

    var styleFunction = function () {
        return[
            new ol.style.Style({
                fill: new ol.style.Fill({
                    color: 'rgba(255, 255, 255, 0.2)'
                }),
                stroke: new ol.style.Stroke({
                    color: strokeColor,
                    width: 2
                }),
                image: new ol.style.Circle({
                    radius: radiusDependZoom,
                    // radius: 20,
                    fill: new ol.style.Fill({
                        color: '#befcff'
                    }),
                    stroke: new ol.style.Stroke({
                        // color: '#ff0705',
                        color: '#3428ff',
                        width: 2
                    })
                }),
                text: new ol.style.Text({
                    font: '12px Calibri,sans-serif',
                    fill: new ol.style.Fill({ color: '#000' }),
                    stroke: new ol.style.Stroke({
                        color: '#fff', width: 2
                    }),
                    text: colorThread + ' ' + colorModule
                })
            })
        ]
    };

    var styleMuftaFunction = function (angleTextRad) {
        return[
            new ol.style.Style({
                fill: new ol.style.Fill({
                    color: 'rgba(255, 255, 255, 0.2)'
                }),
                stroke: new ol.style.Stroke({
                    color: strokeColorM,
                    width: 2
                }),
                image: new ol.style.Circle({
                    radius: radiusDependZoom,
                    // radius: 20,
                    fill: new ol.style.Fill({
                        color: '#befcff'
                    }),
                    stroke: new ol.style.Stroke({
                        // color: '#ff0705',
                        color: '#3428ff',
                        width: 2
                    })
                }),
                text: new ol.style.Text({
                    font: '12px Calibri,sans-serif',
                    fill: new ol.style.Fill({ color: '#000' }),
                    stroke: new ol.style.Stroke({
                        color: '#fff', width: 2
                    }),
                    // text: 'proba',
                    text: colorThread + ' ' + colorModule + ' ' + idPropertyName,
                    rotation: angleTextRad
                })
            })
        ]
    };

    var styleInsideFunction = function () {
        return[
            new ol.style.Style({
                fill: new ol.style.Fill({
                    color: 'rgba(255, 255, 255, 0.2)'
                }),
                stroke: new ol.style.Stroke({
                    color: colorInside,
                    width: 2
                })/*,
                image: new ol.style.Circle({
                    radius: radiusDependZoom,
                    // radius: 20,
                    fill: new ol.style.Fill({
                        color: '#befcff'
                    }),
                    stroke: new ol.style.Stroke({
                        // color: '#ff0705',
                        color: '#3428ff',
                        width: 2
                    })
                }),
                text: new ol.style.Text({
                    font: '12px Calibri,sans-serif',
                    fill: new ol.style.Fill({ color: '#000' }),
                    stroke: new ol.style.Stroke({
                        color: '#fff', width: 2
                    }),
                    text: colorThread + ' ' + colorModule
                })*/
            })
        ]
    };

    var map = new ol.Map({
        layers: [raster,
            layer2],
        target: 'map',
        view : new ol.View({
            center: [ 4466692.398383205, 5756913.30739783 ],
            zoom: 14
        })
    });

    map.on("moveend", function () {
        var zoom = map.getView().getZoom();
        console.log('zoom='+zoom);
        if (zoom < 18) {
            radiusDependZoom = 5;
            vectorSource.clear();
            // DrawMuftaSchema();
            GetURLparameter();
        } else if (zoom < 19){
            radiusDependZoom = 15;
            vectorSource.clear();
            GetURLparameter();
        } else if (zoom < 20){
            radiusDependZoom = 30;
            vectorSource.clear();
            GetURLparameter();
        } else if (zoom < 21){
            radiusDependZoom = 50;
            vectorSource.clear();
            GetURLparameter();
        } else if (zoom < 22){
            radiusDependZoom = 3;
            vectorSource.clear();
            GetURLparameter();
            if($('#check1').prop('checked')) {
                DrawMuftaSchema();
            }
        }
        /*vectorSource.clear();
        GetURLparameter();*/
    });

    //тренируюсь рисовать схему муфты
    var DrawMuftaSchema = function () {
        $.ajax({
            type: 'GET',
            url: service + 'conninsidefeature/get/propertyid/' + $("#propertyId").val(),
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                arrData = JSON.parse(stringData);
                arrAngleRad = [];
                arrItemsPropertyId = [];
                arrNextAngle = [];
                objNextAngle = {};
                HandleArrData();
                ShowLines();
                ShowInsideConnections();
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting data for draw mufta')
            }
        });
            };

    var HandleArrData = function () {
        // var singleRad = Math.PI/90;
        var x1;
        var y1;
        var x2;
        var y2;
        arrCoordsFeature = []; //будем хранить координаты отрезков в схеме
       /* var arrPointCoord = [];
        var arrLineCoord = [];*/
        for (i in arrData) {
            console.log('arrData[i]=' + arrData[i].id + ', '+arrData[i].connectedTo+ ', '+arrData[i].propertyId+ ', '+ arrData[i].colorThread+ ', '+ arrData[i].description+ ', '+ arrData[i].label+ ', '+ arrData[i].reserved);
            console.log('arrCenter longitude='+arrCenter[0]+'arrCenter latitude='+arrCenter[1]);
            /*arrPointCoord = [];
            arrLineCoord = [];*/
            var arrPointCoord = [];
            var arrLineCoord = [];
                x1 = arrCenter[0] +25;
                y1 = arrCenter[1];
                arrPointCoord[0] = x1;
                arrPointCoord[1] = y1;
                arrLineCoord.push(arrPointCoord);
                x2 = x1 +50;
                y2 = y1;
                arrPointCoord = [];
            arrPointCoord[0] = x2;
            arrPointCoord[1] = y2;
                arrLineCoord.push(arrPointCoord);

                arrSingleLine = [];
                arrSingleLine = arrLineCoord;

              // angleRad = singleRad * i;  //угол поворота
               FindAngleRotate(arrData[i].label);

               RotateLine();
               arrAngleRad.push(angleRad);
               console.log('arrAngleRad.push(angleRad)='+angleRad);
            // arrAngleRad[i] = angleRad;
            // arrData[i].angleRad = angleRad;
            arrCoordsFeature.push(arrSingleLine);

        }
    };

    var ShowLines = function () {
        for (i in arrData) {
            if (arrData[i].colorThread == 'red') {
                strokeColorM = '#ff0705';
            } else if (arrData[i].colorThread == 'blue') {
                strokeColorM = '#3428ff';
            } else if (arrData[i].colorThread == 'green') {
                strokeColorM = '#10a83b';
            } else if (arrData[i].colorThread == 'yellow') {
                strokeColorM = '#f7f75f';
            } else if (arrData[i].colorThread == 'purple') {
                strokeColorM = '#c91697';
            } else if (arrData[i].colorThread == 'brown') {
                strokeColorM = '#b26010';
            } else if (arrData[i].colorThread == 'gray') {
                strokeColorM = '#636363';
            } else if (arrData[i].colorThread == 'white') {
                strokeColorM = '#fcfcfc';
            } else if (arrData[i].colorThread == 'orange') {
                strokeColorM = '#ffa500';
            } else if (arrData[i].colorThread == 'pink') {
                strokeColorM = '#f995a6';
            } else if (arrData[i].colorThread == 'lightgreen') {
                strokeColorM = '#a1ff1b';
            } else if (arrData[i].colorThread == 'hardyellow') {
                strokeColorM = '#f9dc1f';
            } else if (arrData[i].colorThread == 'lightbrown') {
                strokeColorM = '#f7bc82';
            } else {
                strokeColorM = '#78ffff';
            }

            colorThread = arrData[i].id + ' ' + arrData[i].colorThread;
            colorModule = arrData[i].reserved;
            // angleRad = arrData[i].angleRad;
            console.log('arrAngleRad[i]='+arrAngleRad[i]);
            idPropertyName = arrData[i].label;
            var linestring_feature = new ol.Feature({
                geometry: new ol.geom.LineString(
                    arrCoordsFeature[i]
                )
            });
            // linestring_feature.setStyle(styleFunction());
            var itemAngleRad = arrAngleRad[i];
            if (itemAngleRad < Math.PI/2){
                itemAngleRad = -1*itemAngleRad;
            } else {
                if (itemAngleRad < Math.PI*3/2){
                    itemAngleRad = Math.PI - itemAngleRad;
                } else {
                    itemAngleRad = -1*itemAngleRad;
                }
            }
            linestring_feature.setStyle(styleMuftaFunction(itemAngleRad));
            vectorSource.addFeature(linestring_feature);
        }
    };

    var ShowInsideConnections = function () {
        console.log('ShowInsideConnections --------------------------------------');
        var arrLineCoord = [];
        var arrFirstPoints = [];
        var firstPoint = [];
        var secondPoint = [];
        for (i in arrData) {
            arrFirstPoints.push(arrData[i].id); //создали массив первых точек
        }
        console.log(arrFirstPoints);
        for (i in arrData){
            arrLineCoord = [];
            firstPoint = [];
            secondPoint = [];
            firstPoint = arrCoordsFeature[i][0];
            var idSecondPoint = arrData[i].connectedTo;
            var indexSecondPoint = arrFirstPoints.indexOf(idSecondPoint);
            secondPoint = arrCoordsFeature[indexSecondPoint][0];
            arrLineCoord.push(firstPoint);
            arrLineCoord.push(secondPoint);
            console.log('i='+i+', firstPoint='+firstPoint+', idSecondPoint='+idSecondPoint+', indexSecondPoint='+indexSecondPoint+', secondPoint='+secondPoint+', arrLineCoord'+arrLineCoord)
            var linestring_feature = new ol.Feature({
                geometry: new ol.geom.LineString(
                    arrLineCoord
                )
            });
            switch (colorInside){
                case '#000000':
                    colorInside = '#606060';
                    break;
                case '#606060':
                    colorInside = '#969696';
                    break;
                case '#969696':
                    colorInside = '#000000';
                    break;
            }
            linestring_feature.setStyle(styleInsideFunction());
            vectorSource.addFeature(linestring_feature);
        }
    };

    var FindAngleRotate = function (itemArrDataLabel) {
        var nextAngleItem = [];
        console.log('for angle itemArrDataLabel=' + itemArrDataLabel);

        arrNextAngle.push(itemArrDataLabel);

        var  count = {};
        arrNextAngle.forEach(function(itemArrDataLabel) { count[itemArrDataLabel] = (count[itemArrDataLabel]||0) + 1;}); //подсчитываем число вхождений
        console.log(count);

        var flagThereIsItem = false;
        arrItemsPropertyId.forEach(function (value) {
           if (value == itemArrDataLabel){
               flagThereIsItem = true;
           }
        });
        if (flagThereIsItem == false){
            arrItemsPropertyId.push(itemArrDataLabel);
        }
        console.log('arrItemsPropertyId='+arrItemsPropertyId);
        var indOf = arrItemsPropertyId.indexOf(itemArrDataLabel);
        console.log('indexOf=' + indOf);
        console.log('count[itemArrDataLabel]='+count[itemArrDataLabel]);

        switch (indOf){
            case 0:
                angleRad = singleRad * count[itemArrDataLabel] + Math.PI;
                break;
            case 1:
                angleRad = -1 * singleRad * count[itemArrDataLabel];
                break;
            case 2:
                angleRad = -1 * singleRad * count[itemArrDataLabel] + (6/4)*Math.PI;
                break;
            case 3:
                angleRad = -1 * singleRad * count[itemArrDataLabel] + (1/2)*Math.PI;
                break;
            case 4:
                angleRad = -1 * singleRad * count[itemArrDataLabel] + (1/4)*Math.PI;
                break;
            case 5:
                angleRad = -1 * singleRad * count[itemArrDataLabel] + (5/4)*Math.PI;
                break;
            case 6:
                angleRad = -1 * singleRad * count[itemArrDataLabel] + (3/4)*Math.PI;
                break;
            case 7:
                angleRad = -1 * singleRad * count[itemArrDataLabel] + (7/4)*Math.PI;
                break;
        }
    };

    var RotateLine = function () {
        var arrLineCoord = [];
        var xCenter = arrCenter[0];
        var yCenter = arrCenter[1];
        for (i in arrSingleLine){
            var arrPointOfLine = arrSingleLine[i];
            var x = arrPointOfLine[0];
            var y = arrPointOfLine[1];
            console.log('x='+x + ', y='+y);
            // arrLineCoord = [];
            arrPointOfLine[0] = xCenter + (x - xCenter)*Math.cos(angleRad) - (y - yCenter)*Math.sin(angleRad);
            arrPointOfLine[1] = yCenter + (y - yCenter)*Math.cos(angleRad) + (x - xCenter)*Math.sin(angleRad);
            console.log('rotate x='+arrPointOfLine[0] + ', rotate y=' + arrPointOfLine[1]);
            arrLineCoord.push(arrPointOfLine);
        }
        arrSingleLine = [];
        arrSingleLine = arrLineCoord;
    };

    var RotatePolygon = function () {
        var arrPolygonCoord = [];
        var xCenter = arrCenter[0];
        var yCenter = arrCenter[1];
        for (i in arrCoordsFeature){
            var arrPointOfPolygon = arrCoordsFeature[i];
            var x = arrPointOfPolygon[0];
            var y = arrPointOfPolygon[1];
            console.log('x='+x + ', y='+y);
            arrPointOfPolygon = [];
            arrPointOfPolygon[0] = xCenter + (x - xCenter)*Math.cos(angleRad) - (y - yCenter)*Math.sin(angleRad);
            arrPointOfPolygon[1] = yCenter + (y - yCenter)*Math.cos(angleRad) + (x - xCenter)*Math.sin(angleRad);
            console.log(arrPointOfPolygon[0] + ', ' + arrPointOfPolygon[1]);
            arrPolygonCoord.push(arrPointOfPolygon);
        }
        arrCoordsFeature = [];
        arrCoordsFeature = arrPolygonCoord;
    };

    var GetURLparameter = function () {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        console.log('GetURLparameter:' + sPageURL);
        var sURLVariables = sPageURL.split('&');
        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('=');
            console.log(sParameterName[1]);
            var fullParameter = sParameterName[1].split(';');
            var propid = fullParameter[0];
            colorThread = fullParameter[1];
            colorModule = fullParameter[2] + ' ' + propid ;
            if (colorThread == 'red'){
                strokeColor = '#ff0705';
            } else if (colorThread == 'blue'){
                strokeColor = '#3428ff';
            } else if (colorThread == 'green'){
                strokeColor = '#09ff25';
            } else if (colorThread == 'yellow'){
                strokeColor = '#fff012';
            } else {
                strokeColor = '#78ffff';
            }
            console.log('propid='+propid);
            AddLineStringByPropertyId(propid);
        }
    };

    var AddLineStringByPropertyId = function (propid) {
        console.log('AddLineStringByPropertyId');
        var featureCoordShow = 'featurecoord/get/propertyid/' + propid;
        /*if($('#check2').prop('checked')) {
            featureCoordShow = 'featurecoord/get/propertyname/' + $("#propName option:selected").val();
        } else {
            featureCoordShow = 'featurecoord/all';
        }*/
        console.log('featureCoordShow='+featureCoordShow);
        $.ajax({
            type: 'GET',
            url: service + featureCoordShow,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                for (i in arrData) {
                    console.log('next feature:');
                    console.log(arrData[i]);
                    var objFeature = arrData[i];
                    var geomType = objFeature.geometryType;
                    var arrGeometryCoord = objFeature.geometryCoord;
                    var arrLineCoord = [];
                    var propFeatureId;
                    for (k in arrGeometryCoord){
                        var arrPointCoord = [];
                        var objGeomCoordItem = arrGeometryCoord[k];
                        arrPointCoord[0] = objGeomCoordItem.longitude;
                        arrPointCoord[1] = objGeomCoordItem.latitude;
                        arrLineCoord.push(arrPointCoord);
                        propFeatureId = objGeomCoordItem.propertyId;
                        console.log('lon=' + objGeomCoordItem.longitude + ', lat=' + objGeomCoordItem.latitude);
                    }

                    if (geomType == 'LineString') {
                        var linestring_feature = new ol.Feature({
                            geometry: new ol.geom.LineString(
                                arrLineCoord
                            )
                        });

                        /*if($('#check1').prop('checked')) {
                            featurePropertyName = objFeature.propertyId + '_' + objFeature.propertyName;
                        } else {
                            featurePropertyName = '';
                        }
                        linestring_feature.setStyle(styleFunction());*/
                       linestring_feature.setStyle(styleFunction());
                        vectorSource.addFeature(linestring_feature);
                        console.log('это LineString');
                    }

                    if (geomType == 'Point'){
                        if($('#check1').prop('checked')) {
                            if (propFeatureId == $("#propertyId").val()) {
                                arrCenter = arrPointCoord;
                            }
                        }

                        var point_feature = new ol.Feature({
                            geometry: new ol.geom.Point(
                                arrPointCoord
                            )
                        });
                        /*if($('#check1').prop('checked')) {
                            featurePropertyName = objFeature.propertyId + '_' + objFeature.propertyName;
                        } else {
                            featurePropertyName = '';
                        }
                        point_feature.setStyle(styleFunction());*/
                        /*colorThread = '';
                        colorModule = '';*/
                        point_feature.setStyle(styleFunction());
                        vectorSource.addFeature(point_feature);
                        console.log('это Point');
                    }
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord');
            }
        });

    };

    GetURLparameter();
</script>
</body>
</html>
