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
    <label>Geometry type &nbsp;</label>
    <select id="type">
        <option value="Point">Point</option>
        <option value="LineString">LineString</option>
        <option value="Polygon">Polygon</option>
        <option value="Circle">Circle</option>
    </select>

    <button type="button" onclick="SaveModifIntoBase()">Save Modified</button>
    <button type="button" onclick="AddLineStringFromBase()">Add LineString</button>
</form>

<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script>
    var nextid = 7;             //счетчик уникального ID для карты (propertyId)
    var JSONmodifyCoord = {};   //обьект FeatureCoord после модификации его пользователем
    var featurePropertyName = 'volsCable1';
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

    //--добавим слой с готовыми линиями
    /*var geojsonObject = {"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"LineString","coordinates":[[4466646.416733378,5756930.625162051],[4466801.679447082,5757077.527575786]]},"properties":{"id":1,"name":"myCable1"}}]};
    var source2 = new ol.source.Vector({
        features: (new ol.format.GeoJSON()).readFeatures(geojsonObject)
    });
    var layer2 = new ol.layer.Vector({
        source: source2
    });*/
    //добавим слой при загрузке. Редактировать его нельзя
    var map = new ol.Map({
        //layers: [raster, layer2, vector],
        layers: [raster,
            new ol.layer.Vector({
                source: vectorSource
            }),
            vector],
        target: 'map',
        /*view: new ol.View({
            center: [-11000000, 4600000],
            zoom: 4
        })*/
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
        var arrCoords = [];
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

                saveModifyCoordLineStr(featuresGeoJSON);
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
                saveDrawCoordsLineStr(arrCoords, nextid);
                /*arrCoords = evt.feature.getGeometry().getCoordinates();
                var lengthCoords;
                //получаем массив координат мультилинии
                lengthCoords = arrCoords.length;
                console.log('lengthCoords='+lengthCoords);*/

                nextid++;
            },
            this);
    }
    typeSelect.onchange = function(e) {
        map.removeInteraction(draw);
        addInteraction();
    };
    addInteraction();

    var saveDrawCoordsLineStr = function (arrCoords, nextid) {
        //формируем JSON для отправки на сервер
        //получаем массив координат вершин
        // var arrCoords = evt.feature.getGeometry().getCoordinates();
        var arrGeometryCoord = [];
        for (i in arrCoords) {
            var vertexCoords = arrCoords[i];
            var objFeatureLonLat = {
                'longitude':vertexCoords[0],
                'latitude':vertexCoords[1],
                'propertyId':nextid
            };
            //получили массив координат вершин
            arrGeometryCoord.push(objFeatureLonLat);
        }

        var JSONfeatureCoord = {
            'geometryType':'LineString',
            'propertyId':nextid,
            'propertyName':featurePropertyName,
            'geometryCoord':arrGeometryCoord
        };
        $.ajax({
            type: 'POST',
            url: "http://localhost:8080/featurecoord/add",
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(JSONfeatureCoord),
            dataType: 'json',
            async: false,
            success: function (result) {
                console.log('Success add FeatureCoord');
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
        $.ajax({
            type: 'GET',
            url: 'http://localhost:8080/featurecoord/all',
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
                }
            },
            error: function (jqXHR, testStatus, errorThrown) {
                console.log('error getting featurecoord');
            }
        });

        /*var arrStringCoords = [[4463583.262541277,5756721.0204985505],[4469306.48503413,5756931.222326335]];
        var linestring_feature = new ol.Feature({
            geometry: new ol.geom.LineString(
                // [[4463583.262541277,5756721.0204985505],[4469306.48503413,5756931.222326335]]
                arrStringCoords
            )
        });
          vectorSource.addFeature( linestring_feature );*/
        /*var myLinestr = new ol.geom.LineString();
        myLinestr.appendCoordinate(4463583.262541277,5756721.0204985505);
        myLinestr.appendCoordinate(4469306.48503413,5756931.222326335);
        vectorSource.addFeature( myLinestr );*/
        /*var linestring_feature = new ol.Feature({
            geometry: new ol.geom.LineString(
                [[4466646.416733378,5756930.625162051],[4466801.679447082,5757077.527575786]]
            )
        });
        vectorSource.addFeature( linestring_feature );
        linestring_feature = new ol.Feature({
            geometry: new ol.geom.LineString(
                [[4463583.262541277,5756721.0204985505],[4469306.48503413,5756931.222326335]]
            )
        });
        vectorSource.addFeature( linestring_feature );*/
        // var geojsonObject = {"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"LineString","coordinates":[[4466646.416733378,5756930.625162051],[4466801.679447082,5757077.527575786]]},"properties":{"id":1,"name":"myCable1"}}]};
        // vectorSource.addFeature((new ol.format.GeoJSON()).readFeatures(geojsonObject));
        /*var source2 = new ol.source.Vector({
            features: (new ol.format.GeoJSON()).readFeatures(geojsonObject)
        });
        var layer2 = new ol.layer.Vector({
            source: source2
        });*/
    };
</script>

</body>
</html>