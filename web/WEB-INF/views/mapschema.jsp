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
    <div id="popup"></div>
</div>
<script>
    var colorThread = '';
    var colorModule = '';
    var strokeColor = '';
    var featurePropertyName = '';
    var arrCenter =[];
    var arrCoordsFeature = [];
    var angleRad = 0;
    var radiusDependZoom = 0;
    var service = 'http://localhost:8080/';
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
            radiusDependZoom = 300;
            vectorSource.clear();
            GetURLparameter();
            DrawMuftaSchema();
        }
        /*vectorSource.clear();
        GetURLparameter();*/
    });

    //тренируюсь рисовать схему муфты
    var DrawMuftaSchema = function () {
        /*var xCoord = 4466692.398383205;
        var yCoord = 5756913.30739783;*/
        var xCoord = arrCenter[0] + 25;
        var yCoord = arrCenter[1] - 12;
        var arrPointCoord = [];
        var arrPolygonCoord = [];

        /*arrPointCoord = [];
        arrPointCoord.push(xCoord);
        arrPointCoord.push(yCoord);
        arrPolygonCoord.push(arrPointCoord);

        arrPointCoord = [];
        arrPointCoord.push(xCoord+1000);
        arrPointCoord.push(yCoord);
        arrPolygonCoord.push(arrPointCoord);

        arrPointCoord = [];
        arrPointCoord.push(xCoord+1000);
        arrPointCoord.push(yCoord+1000);
        arrPolygonCoord.push(arrPointCoord);

        arrPointCoord = [];
        arrPointCoord.push(xCoord);
        arrPointCoord.push(yCoord+1000);
        arrPolygonCoord.push(arrPointCoord);

        arrPointCoord = [];
        arrPointCoord.push(xCoord);
        arrPointCoord.push(yCoord);
        arrPolygonCoord.push(arrPointCoord);*/

        arrPointCoord[0] = xCoord;
        arrPointCoord[1] = yCoord;
        arrPolygonCoord.push(arrPointCoord);
        arrPointCoord = [];
        arrPointCoord[0] = xCoord+50;
        arrPointCoord[1] = yCoord;
        arrPolygonCoord.push(arrPointCoord);
        arrPointCoord = [];
        arrPointCoord[0] = xCoord+50;
        arrPointCoord[1] = yCoord+25;
        arrPolygonCoord.push(arrPointCoord);
        arrPointCoord = [];
        arrPointCoord[0] = xCoord;
        arrPointCoord[1] = yCoord+25;
        arrPolygonCoord.push(arrPointCoord);
        arrPointCoord = [];
        arrPointCoord[0] = xCoord;
        arrPointCoord[1] = yCoord;
        arrPolygonCoord.push(arrPointCoord);

        /*var polygon = new ol.geom.Polygon([ [ [xCoord,yCoord],
            [xCoord,yCoord+10000],[xCoord+10000,yCoord+10000],[xCoord+10000,yCoord],[xCoord,yCoord] ] ]);*/
        /*arrCenter[0] = 4466692.398383205;
        arrCenter[1] = 5756913.30739783;*/
        angleRad = Math.PI/4;
        arrCoordsFeature = [];
        arrCoordsFeature = arrPolygonCoord;
        RotatePolygon();
        var polygon_feature = new ol.Feature({
            geometry: new ol.geom.Polygon(
                //[ [ [xCoord,yCoord], [xCoord,yCoord+10000],[xCoord+10000,yCoord+10000],[xCoord+10000,yCoord],[xCoord,yCoord] ] ]
                [arrCoordsFeature]
            )
        });
        // polygon_feature.rotate(Math.PI / 2.0, ol.proj.transform([-16,-22], 'EPSG:4326', 'EPSG:3857'));
        vectorSource.addFeature(polygon_feature);

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
            colorModule = fullParameter[2];
            if (colorThread = 'red'){
                strokeColor = '#ff0705';
            } else {
                strokeColor = '#3428ff';
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
                    for (k in arrGeometryCoord){
                        var arrPointCoord = [];
                        var objGeomCoordItem = arrGeometryCoord[k];
                        arrPointCoord[0] = objGeomCoordItem.longitude;
                        arrPointCoord[1] = objGeomCoordItem.latitude;
                        arrLineCoord.push(arrPointCoord);
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
                        arrCenter = arrPointCoord;
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
