package ru.cablemaster.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import ru.cablemaster.entity.FeatureNextId;
import ru.cablemaster.service.FeatureNextIdService;

import java.util.List;

@Controller
@RequestMapping("/featurenextid")
public class FeatureNextIdController {
    @Autowired
    private FeatureNextIdService featureNextIdService;

    @RequestMapping(value = "/add", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public FeatureNextId addFeatureNextId(@RequestBody FeatureNextId featureNextId){
        return featureNextIdService.addFeatureNextId(featureNextId);
    }

    @RequestMapping(value = "/all", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public List<FeatureNextId> getFeatureNextIds(){
        return featureNextIdService.getAllFeatureNextIds();
    }

    @RequestMapping(value = "/get/{id}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public FeatureNextId getFeatureNextIdById(@PathVariable(value = "id") String id){
        // exception
        return featureNextIdService.getFeatureNextIdById(Long.parseLong(id));
    }

    // localhost:8080/cat/delete?id=5&name=Jack
    @RequestMapping(value = "/delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
    @ResponseBody
    public FeatureNextId deleteFeatureNextId(@RequestParam(value = "id") String id) {
        return featureNextIdService.deleteFeatureNextId(Long.parseLong(id));
    }

    @RequestMapping(value = "/upd", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
    @ResponseBody
    public FeatureNextId updFeatureNextId(@RequestBody FeatureNextId featureNextId){
        return featureNextIdService.updFeatureNextId(featureNextId);
    }
}
