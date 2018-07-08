package ru.cablemaster.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import ru.cablemaster.entity.FeatureLonLat;
import ru.cablemaster.service.FeatureLonLatService;

import java.util.List;

@Controller
@RequestMapping("/featurelonlat")
public class FeatureLonLatController {
    @Autowired
    private FeatureLonLatService featureLonLatService;

    @RequestMapping(value = "/add", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public FeatureLonLat addFeatureLonLat(@RequestBody FeatureLonLat featureLonLat){
        return featureLonLatService.addFeatureLonLat(featureLonLat);
    }

    @RequestMapping(value = "/all", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public List<FeatureLonLat> getFeatureLonLats(){
        return featureLonLatService.getAllFeatureLonLats();
    }

    @RequestMapping(value = "/get/{id}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public FeatureLonLat getFeatureLonLatById(@PathVariable(value = "id") String id){
        // exception
        return featureLonLatService.getFeatureLonLatById(Long.parseLong(id));
    }

    // localhost:8080/cat/delete?id=5&name=Jack
    @RequestMapping(value = "/delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
    @ResponseBody
    public FeatureLonLat deleteFeatureLonLat(@RequestParam(value = "id") String id) {
        return featureLonLatService.deleteFeatureLonLat(Long.parseLong(id));
    }

    @RequestMapping(value = "/upd", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
    @ResponseBody
    public FeatureLonLat updFeatureLonLat(@RequestBody FeatureLonLat featureLonLat){
        return featureLonLatService.updFeatureLonLat(featureLonLat);
    }
}

