<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create new content</title>
    <link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>
</head>
<body>
<div id="map" class="map">
    <div id="popup"></div>
</div>
<form class="form-inline">
    <%--<label>Geometry type &nbsp;</label>--%>
    <select id="type">
        <option value="LineString">LineString</option>
        <option value="Point">Point</option>
        <%--<option value="Polygon">Polygon</option>
        <option value="Circle">Circle</option>--%>
    </select>

    <button type="button" onclick="SaveArrCoordsIntoBase()">Save feature</button>
    <button type="button" onclick="AddLineStringFromBase()">Add LineString</button>
    <input type="text" id="propertyname" size="30">
    <button type="button" onclick="AddPropertyNameIntoBase()">Добавить propertyName</button>
    <label>Показывать только</label>
    <input type="checkbox" name="cb2" id="check2" value="0"/>
    <label>propertyName:</label>
    <select id="propName"></select>
    <%--<label id="labelNextId">nextid=0</label>--%>
    <label>Удалить по propertyId:</label>
    <input type="text" id="nextidid" size="10">
    <button type="button" onclick="DelFeatureByPropertyId()">Delete</button>
    <label>Показывать propertyName:</label>
    <input type="checkbox" name="cb1" id="check1" value="1" checked />
</form>
<form class="form-inline">
    <%--<button type="button" onclick="window.location = 'http://localhost:8080/insidefeature';">ConnInsideFeature</button>--%>
    <li>
        <a href="http://10.152.46.71:8080/insidefeature">insidefeature</a>
    </li>
    <li>
        <a href="http://10.152.46.71:8080/betweenfeature">betweenfeature</a>
    </li>
        <li>
            <a href="http://10.152.46.71:8080/help">help</a>
        </li>

</form>

<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script>
    var service = 'http://10.152.46.71:8080/';
    var arrCoords = [];
    var nextid = 0;             //счетчик уникального ID для карты (propertyId)
    var JSONmodifyCoord = {};   //обьект FeatureCoord после модификации его пользователем
    var featurePropertyName = '';
    var raster = new ol.layer.Tile({
        source: new ol.source.OSM()
    });
    var source = new ol.source.Vector();
    var vector = new ol.layer.Vector({
        id: 'vector',
        source: source,
        style: new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
                color: '#ffcc33',
                width: 2
            }),
            image: new ol.style.Circle({
                radius: 7,
                fill: new ol.style.Fill({
                    color: '#ffcc33'
                })
            })
        })
    });

    var vectorSource = new ol.source.Vector({});

    var styleFunction = function () {
        return[
            new ol.style.Style({
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
                }),
                text: new ol.style.Text({
                    font: '12px Calibri,sans-serif',
                    fill: new ol.style.Fill({ color: '#000' }),
                    stroke: new ol.style.Stroke({
                        color: '#fff', width: 2
                    }),
                    text: featurePropertyName
                })
            })
        ]
    };

    //добавим слой при загрузке. Редактировать его нельзя
    var map = new ol.Map({
        //layers: [raster, layer2, vector],
        layers: [raster,
            new ol.layer.Vector({
                source: vectorSource
            }),
            vector],
        target: 'map',
        view : new ol.View({
            // center: ol.proj.transform([40.151253, 45.838248], 'EPSG:4326', 'EPSG:3857'),
            center: [ 4466692.398383205, 5756913.30739783 ],
            zoom: 14
        })
    });
    var modify = new ol.interaction.Modify({source: source});
    map.addInteraction(modify);
    var typeSelect = document.getElementById('type');
    var draw; // global so we can remove it later
    function addInteraction() {
        //объявляем массив координат вершин мультилинии
        // var arrCoords = [];
        draw = new ol.interaction.Draw({
            source: source,
            type: typeSelect.value
        });
        map.addInteraction(draw);
        modify.on('modifyend',
            function (evt) {
                // console.log(evt.feature);
                var parser = new ol.format.GeoJSON();
                var features = source.getFeatures();
                var featuresGeoJSON = parser.writeFeatures(features);

                console.log('modifyend:');
                console.log(featuresGeoJSON);

                SaveModifIntoArrCoords(featuresGeoJSON);
                // saveModifyCoordLineStr(featuresGeoJSON);
                // console.log(evt.feature.getGeometry().getCoordinates(), evt.feature.getProperties());
                // console.log(evt.feature.getProperties());
            }, this);
        draw.on('drawend',
            function(evt) {
                evt.feature.setProperties({
                    'id' : nextid,
                    'name':featurePropertyName
                });

                // console.log(evt.feature);
                var parser = new ol.format.GeoJSON();
                var features = source.getFeatures();
                var featuresGeoJSON = parser.writeFeatures(features);
                console.log('drawend:');
                console.log(featuresGeoJSON);
                console.log(evt.feature.getGeometry().getCoordinates(), evt.feature.getProperties());

                //получаем массив координат вершин мультилинии
                arrCoords = evt.feature.getGeometry().getCoordinates();
                //сохраняем в базу линию и ее координаты
                // saveDrawCoordsLineStr(arrCoords, nextid);
                /*arrCoords = evt.feature.getGeometry().getCoordinates();
                var lengthCoords;
                //получаем массив координат мультилинии
                lengthCoords = arrCoords.length;
                console.log('lengthCoords='+lengthCoords);*/

                // nextid++;
            },
            this);
    }
    typeSelect.onchange = function(e) {
        map.removeInteraction(draw);
        addInteraction();
    };
    addInteraction();

    var saveDrawCoordsPoint = function (arrCoords, nextid) {
        //формируем JSON точки для отправки на сервер
        var arrGeometryCoord = [];
        // var vertexCoords = arrCoords[0];
        var objFeatureLonLat = {
            'longitude': arrCoords[0],
            'latitude': arrCoords[1],
            // 'propertyName': featurePropertyName,
            'propertyName': $("#propName option:selected").val(),
            'propertyId': nextid
        };
        //получили массив координат вершин
        arrGeometryCoord.push(objFeatureLonLat);

        var JSONfeatureCoord = {
            'geometryType':'Point',
            'propertyId':nextid,
            // 'propertyName': featurePropertyName,
            'propertyName': $("#propName option:selected").val(),
            'geometryCoord':arrGeometryCoord
        };

        JSONmodifyCoord = {
            'geometryType':'Point',
            'propertyId':nextid,
            // 'propertyName': featurePropertyName,
            'propertyName': $("#propName option:selected").val(),
            'geometryCoord':arrGeometryCoord
        };
        $.ajax({
            type: 'POST',
            url: service + "featurecoord/add",
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(JSONfeatureCoord),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('Success add FeatureCoord');
                //увеличиваем на 1 счетчик Features
                IncrFeatureNextId();
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Failed add FeatureCoord');
            }
        });
    };

    var saveDrawCoordsLineStr = function (arrCoords, nextid) {
        //формируем JSON для отправки на сервер
        //получаем массив координат вершин
        // var arrCoords = evt.feature.getGeometry().getCoordinates();
        console.log('saveDrawCoordsLineStr');
        var arrGeometryCoord = [];
        for (i in arrCoords) {
            var vertexCoords = arrCoords[i];
            if (i == 0) {
                var objFeatureLonLat = {
                    'longitude': vertexCoords[0],
                    'latitude': vertexCoords[1],
                    'propertyId': nextid,
                    // 'propertyName': featurePropertyName,
                    'propertyName': $("#propName option:selected").val(),
                    'featureBegin': true
                };
            } else {
                if (i == (arrCoords.length - 1)) {
                    var objFeatureLonLat = {
                        'longitude': vertexCoords[0],
                        'latitude': vertexCoords[1],
                        'propertyId': nextid,
                        // 'propertyName': featurePropertyName,
                        'propertyName': $("#propName option:selected").val(),
                        'featureEnd': true
                    };
                } else {
                    var objFeatureLonLat = {
                        'longitude': vertexCoords[0],
                        'latitude': vertexCoords[1],
                        // 'propertyName': featurePropertyName,
                        'propertyName': $("#propName option:selected").val(),
                        'propertyId': nextid
                    };
                }
            }
            //получили массив координат вершин
            arrGeometryCoord.push(objFeatureLonLat);
        }

        JSONmodifyCoord = {
            'geometryType':'LineString',
            'propertyId':nextid,
            // 'propertyName': featurePropertyName,
            'propertyName': $("#propName option:selected").val(),
            'geometryCoord':arrGeometryCoord
        };
        var JSONfeatureCoord = {
            'geometryType':'LineString',
            'propertyId':nextid,
            // 'propertyName': featurePropertyName,
            'propertyName': $("#propName option:selected").val(),
            'geometryCoord':arrGeometryCoord
        };
        $.ajax({
            type: 'POST',
            url: service + "featurecoord/add",
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(JSONfeatureCoord),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('Success add FeatureCoord');
                //увеличиваем на 1 счетчик Features
                IncrFeatureNextId();
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Failed add FeatureCoord');
            }
        });
    };


    var saveModifyCoordLineStr = function (featuresGeoJSON) {
        //разбираем GeoJSON
        var arrData = JSON.parse(featuresGeoJSON);
        console.log(arrData.type);
        var arrFeatures = arrData.features;
        // var objFeature = arrFeatures[0];
        var objGeometry = arrFeatures[0].geometry;
        var arrCoords = objGeometry.coordinates;
        var objProperties = arrFeatures[0].properties;

        console.log('idProperties='+objProperties.id + ', nameProperties='+objProperties.name);

        var arrGeometryCoord = [];
        for (i in arrCoords) {
            var vertexCoords = arrCoords[i];
            var objFeatureLonLat = {
                'longitude':vertexCoords[0],
                'latitude':vertexCoords[1],
                'propertyId':objProperties.id
            };
            console.log('longitude='+vertexCoords[0]+', latitude='+vertexCoords[1]);
            //получили массив координат вершин
            arrGeometryCoord.push(objFeatureLonLat);
        }
        JSONmodifyCoord = {
            'geometryType':'LineString',
            'propertyId':objProperties.id,
            'propertyName':featurePropertyName,
            'geometryCoord':arrGeometryCoord
        };
    };

    var SaveModifIntoBase = function () {
        //здесь будем удалять из базы старую мультилинию с nextid и добавлять вместо нее модифицированную
        console.log('propertyId='+JSONmodifyCoord.propertyId + ', propertyName' + JSONmodifyCoord.propertyName);
        //получаем ID FeatureCoord
        var idFeatureCoord;
        $.ajax({
            type: 'GET',
            url: 'http://localhost:8080/featurecoord/get/propertyid/' + JSONmodifyCoord.propertyId,
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                idFeatureCoord = arrData[0].id;
                console.log('idFeatureCoord='+idFeatureCoord);
                //нашли ID FeatureCoord
                //здесь будем удалять FeatureCoord по ID и добавлять модифицированный FeatureCoord
                DelFeatureCoordById(idFeatureCoord);

            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord by propertyId')
            }
        });
    };

    var DelFeatureCoordById = function (idFeatureCoord) {
        $.ajax({
            type: 'DELETE',
            url: 'http://localhost:8080/featurecoord/delete?id=' + idFeatureCoord,
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('success deleting featurecoord by Id');
                AddModifiedFeature(JSONmodifyCoord);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error deleting featurecoord by Id')
            }
        });
    };

    var AddModifiedFeature = function (JSONmodifyCoord) {
        $.ajax({
            type: 'POST',
            url: 'http://localhost:8080/featurecoord/add',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(JSONmodifyCoord),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('success add modified featurecoord');
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error add modified featurecoord');
            }
        });
    };

    //при нажатии на кнопку отображаем на карте все линии из базы
    var AddLineStringFromBase = function () {
        console.log('AddLineStringFromBase');
        var featureCoordShow = '';
        if($('#check2').prop('checked')) {
            featureCoordShow = 'featurecoord/get/propertyname/' + $("#propName option:selected").val();
        } else {
            featureCoordShow = 'featurecoord/all';
        }
        console.log('featureCoordShow='+featureCoordShow);
        $.ajax({
            type: 'GET',
            url: service + featureCoordShow,
            // url: 'http://localhost:8080/featurecoord/all',
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                //console.log(stringData);
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

                        if($('#check1').prop('checked')) {
                            featurePropertyName = objFeature.propertyId + '_' + objFeature.propertyName;
                        } else {
                            featurePropertyName = '';
                        }
                        linestring_feature.setStyle(styleFunction());
                        vectorSource.addFeature(linestring_feature);
                        console.log('это LineString');
                    }

                    if (geomType == 'Point'){
                        var point_feature = new ol.Feature({
                            geometry: new ol.geom.Point(
                                arrPointCoord
                            )
                        });
                        if($('#check1').prop('checked')) {
                            featurePropertyName = objFeature.propertyId + '_' + objFeature.propertyName;
                        } else {
                            featurePropertyName = '';
                        }
                        point_feature.setStyle(styleFunction());
                        vectorSource.addFeature(point_feature);
                        console.log('это Point');
                    }
                }

                /*for (i in arrData) {
                    console.log('next feature:');
                    console.log(arrData[i]);
                    var objFeature = arrData[i];

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
                    var linestring_feature = new ol.Feature({
                        geometry: new ol.geom.LineString(
                            arrLineCoord
                        )
                    });
                    vectorSource.addFeature( linestring_feature );
                }*/
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord');
            }
        });

    };

    var SaveArrCoordsIntoBase = function () {
        // if (emptyGeoJson > 0) {
        if (typeSelect.value == 'LineString') {
            saveDrawCoordsLineStr(arrCoords, nextid);
        }
        // }
        if (typeSelect.value == 'Point') {
            saveDrawCoordsPoint(arrCoords, nextid);
        }

        source.clear();
        AddLineStringFromBase();
    };

    var SaveModifIntoArrCoords = function (featuresGeoJSON) {
        //разбираем GeoJSON
        var arrData = JSON.parse(featuresGeoJSON);
        console.log(arrData.type);
        var arrFeatures = arrData.features;
        var objGeometry = arrFeatures[0].geometry;
        arrCoords = objGeometry.coordinates;
        var objProperties = arrFeatures[0].properties;

        console.log('idProperties='+objProperties.id + ', nameProperties='+objProperties.name + ', type=' + objGeometry.type);

    };

    var SetSelectOptions = function () {
        console.log('SetSelectOptions');
        $.ajax({
            type: 'GET',
            url: service + 'cablename/all',
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                for (i in arrData) {
                    var objCableName = {};
                    objCableName = arrData[i];
                    $("#propName").append($('<'+'option value'+'="'+objCableName.propertyName+'">'+objCableName.propertyName+'</option>'))
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting cablename');
            }
        });
        // $("#propName").append($('<option value="4">four</option>'));
    };
    SetSelectOptions();

    var AddPropertyNameIntoBase = function () {
        console.log('AddPropertyNameIntoBase='+$("#propertyname").val());
        var JSONpropName = {
            "propertyName":$("#propertyname").val()
        };
        $.ajax({
            type: 'POST',
            url: service + 'cablename/add',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(JSONpropName),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('success add PropertyName');
                $("#propName").append($('<'+'option value'+'="'+$("#propertyname").val()+'">'+$("#propertyname").val()+'</option>'))
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error add PropertyName');
            }
        });
    };

    var IncrFeatureNextId = function () {
        //увеличиваем на 1 nextid
        $.ajax({
            type: 'GET',
            url: service + 'featurenextid/all',
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                if(arrData.length > 1){
                    console.log('error FeatureNextId table row count');
                } else {
                    var objNextId = {};
                    objNextId = arrData[0];
                    UpdFeatureNextId(objNextId);
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Failed increment FeatureNextId');
            }
        });
    };

    var UpdFeatureNextId = function (objNextId) {
        var incrementNextId = objNextId.nextId + 1;
        objNextId.nextId = incrementNextId;
        console.log('incrementNextId=' + incrementNextId);
        $.ajax({
            type: 'PUT',
            url: service + "featurenextid/upd",
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(objNextId),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('Success update FeatureNextId');
                nextid = incrementNextId;
                //$("#labelNextId").text("nextid=" + incrementNextId);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Failed update FeatureNextId');
            }
        });
    };

    var AddFeatureNextId = function () {
        console.log('table FeatureNextId is empty')
        var JSONfeatureNextId = {
            'nextId':0
        };
        $.ajax({
            type: 'POST',
            url: service + "featurenextid/add",
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(JSONfeatureNextId),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('Success add FeatureNextId');
                nextid = 0;
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('Failed add FeatureNextId');
            }
        });
    };

    //устанавливаем переменную для номера следующей Feature
    var SetFeatureNextId = function () {
        console.log('SetFeatureNextId');
        $.ajax({
            type: 'GET',
            url: service + 'featurenextid/all',
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                if(arrData.length == 0){
                    AddFeatureNextId();
                } else {
                    // GetFeatureNextId();
                    console.log('table FeatureNextId is not empty');
                    if(arrData.length > 1){
                        console.log('error FeatureNextId table row count');
                    } else {
                        var objNextId = {};
                        objNextId = arrData[0];
                        nextid = objNextId.nextId;
                        console.log('nextid=' + nextid);
                    }
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurenextid');
            }
        });
    };
    SetFeatureNextId();

    var DelFeatureByPropertyId = function () {
        var idFeatureCoord;
        console.log('удаляем Feature по propertyId=' + $("#nextidid").val());
        $.ajax({
            type: 'GET',
            url: service + 'featurecoord/get/propertyid/' + $("#nextidid").val(),
            dataType: 'json',
            async: false,
            success: function (result) {
                var stringData = JSON.stringify(result);
                console.log(stringData);
                var arrData = JSON.parse(stringData);
                idFeatureCoord = arrData[0].id;
                DelFeatCoorById(idFeatureCoord);
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error deleting featurecoord by propertyId')
            }
        });
    };

    var DelFeatCoorById = function (idFeatureCoord) {
        $.ajax({
            type: 'DELETE',
            url: service + 'featurecoord/delete?id=' + idFeatureCoord,
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('success deleting featurecoord by Id');
                vectorSource.clear();
                AddLineStringFromBase();
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error deleting featurecoord by Id')
            }
        });
    };
</script>

</body>
</html>