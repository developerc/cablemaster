package ru.cablemaster.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import ru.cablemaster.entity.ConnInsideFeature;
import ru.cablemaster.service.ConnInsideFeatureService;

import java.util.List;

@Controller
@RequestMapping("/conninsidefeature")
public class ConnInsideFeatureController {
    @Autowired
    private ConnInsideFeatureService connInsideFeatureService;

    @RequestMapping(value = "/add", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ConnInsideFeature addConnInsideFeature(@RequestBody ConnInsideFeature connInsideFeature){
        return connInsideFeatureService.addConnInsideFeature(connInsideFeature);
    }

    @RequestMapping(value = "/all", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public List<ConnInsideFeature> getConnInsideFeatures(){
        return connInsideFeatureService.getConnInsideFeatures();
    }

    @RequestMapping(value = "/get/{id}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ConnInsideFeature getConnInsideFeatureById(@PathVariable(value = "id") String id){
        // exception
        return connInsideFeatureService.getConnInsideFeatureById(Long.parseLong(id));
    }

    // localhost:8080/cat/delete?id=5&name=Jack
    @RequestMapping(value = "/delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ConnInsideFeature deleteConnInsideFeature(@RequestParam(value = "id") String id) {
        return connInsideFeatureService.deleteConnInsideFeature(Long.parseLong(id));
    }

    @RequestMapping(value = "/upd", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ConnInsideFeature updConnInsideFeature(@RequestBody ConnInsideFeature connInsideFeature){
        return connInsideFeatureService.updConnInsideFeature(connInsideFeature);
    }
}
