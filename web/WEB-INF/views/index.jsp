<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <title>jQuery Dialog</title>
    <%--<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>--%>
    <script src="js/jquery.js"></script>
    <%--<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">--%>
    <link rel="stylesheet" href="css/jquery-ui.css">
    <link rel="stylesheet" href="/resources/demos/style.css">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <%--<script src="ui/jquery-ui.js"></script>--%>

    <link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>
</head>

<body>
<div id="dialog" title="Данные для нового таксофона">
    <form>
        <p><input type="text" name="tlfnum" id="tlfnum" value="41256" class="text ui-widget-content ui-corner-all"><label for="tlfnum">Тлф номер</label></p>
        <p><input type="text" name="krdid" id="krdid" value="253" class="text ui-widget-content ui-corner-all"><label for="krdid">ID таксофона</label></p>
        <p><input type="text" name="lon" id="lon" value="45.568" class="text ui-widget-content ui-corner-all"><label for="lon">Longitude</label></p>
        <p><input type="text" name="lat" id="lat" value="23.432" class="text ui-widget-content ui-corner-all"><label for="lat">Latitude</label></p>
        <p><input type="text" name="numsam" id="numsam" value="2435" class="text ui-widget-content ui-corner-all"><label for="numsam">Номер SAM модуля</label></p>
        <p><input type="text" name="type" id="typetax" value="УТЭК" class="text ui-widget-content ui-corner-all"><label for="type">Модель</label></p>
        <p><input type="text" name="adres" id="adres" value="Адрес установки" class="text ui-widget-content ui-corner-all"><label for="adres">Адрес</label></p>
        <p><input type="text" name="version" id="version" value="Версия" class="text ui-widget-content ui-corner-all"><label for="version">Версия</label></p>
        <p><button type="button" onclick="RestAddTaxofon($('#tlfnum').val(), $('#krdid').val(), $('#lon').val(), $('#lat').val(), $('#numsam').val(), $('#type').val(), $('#adres').val(), $('#version').val())">OK</button>
            <button type="button" onclick="CloseModalForm()">CANCEL</button>
        </p>
    </form>
</div>

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

<script>
    var nextid = 16;             //счетчик уникального ID для карты (propertyId)
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

    var OpenModalForm = function () {
        $("#dialog").dialog('open');
    };

    var CloseModalForm = function () {
        $("#dialog").dialog('close');
    };

    //------
    $( function() {
        $( "#dialog" ).dialog({
            autoOpen: false,
            height: 400,
            width: 400,
            modal: true
        });
    } );


</script>
<%--<body>
<div id="dialog" title="Данные для нового таксофона">
    <form>
        <p><input type="text" name="tlfnum" id="tlfnum" value="41256" class="text ui-widget-content ui-corner-all"><label for="tlfnum">Тлф номер</label></p>
        <p><input type="text" name="krdid" id="krdid" value="253" class="text ui-widget-content ui-corner-all"><label for="krdid">ID таксофона</label></p>
        <p><input type="text" name="lon" id="lon" value="45.568" class="text ui-widget-content ui-corner-all"><label for="lon">Longitude</label></p>
        <p><input type="text" name="lat" id="lat" value="23.432" class="text ui-widget-content ui-corner-all"><label for="lat">Latitude</label></p>
        <p><input type="text" name="numsam" id="numsam" value="2435" class="text ui-widget-content ui-corner-all"><label for="numsam">Номер SAM модуля</label></p>
        <p><input type="text" name="type" id="type" value="УТЭК" class="text ui-widget-content ui-corner-all"><label for="type">Модель</label></p>
        <p><input type="text" name="adres" id="adres" value="Адрес установки" class="text ui-widget-content ui-corner-all"><label for="adres">Адрес</label></p>
        <p><input type="text" name="version" id="version" value="Версия" class="text ui-widget-content ui-corner-all"><label for="version">Версия</label></p>
        <p><button type="button" onclick="RestAddTaxofon($('#tlfnum').val(), $('#krdid').val(), $('#lon').val(), $('#lat').val(), $('#numsam').val(), $('#type').val(), $('#adres').val(), $('#version').val())">OK</button>
            <button type="button" onclick="CloseModalForm()">CANCEL</button>
        </p>
    </form>
</div>

<div id="map" class="map">
    <div id="popup"></div>
</div>--%>

<%--<div class="container">
    <div class="panel">
        <div class="panel-heading"><strong>Неисправности Таксофонов</strong></div>
        <div class="panel-body">
            <table class="table-row-cell">
                <tr>
                    <th>Открыть заявку</th>
                    <th> <input id="idDamagedTaxofon" value="ID"> </th>
                    <th id="selectTypeDamage"></th>
                    <th>Дата: <input type="text" id="datepicker" size="30"></th>
                    <th>Время: <input id="timecurrent" type="text"></th>
                    <th><button type="button" onclick="OpenModalForm()">OK</button></th>
                    &lt;%&ndash;<th><button type="button" onclick="GetTaxofonById($('#idDamagedTaxofon').val())">OK</button></th>&ndash;%&gt;
                </tr>

               </table>
        </div>
    </div>
</div>--%>


</body>
</html>