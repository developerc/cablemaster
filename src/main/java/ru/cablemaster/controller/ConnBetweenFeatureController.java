package ru.cablemaster.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import ru.cablemaster.entity.ConnBetweenFeature;
import ru.cablemaster.service.ConnBetweenFeatureService;

import java.util.List;

@Controller
@RequestMapping("/connbetweenfeature")
public class ConnBetweenFeatureController {
    @Autowired
    private ConnBetweenFeatureService connBetweenFeatureService;

    @RequestMapping(value = "/add", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ConnBetweenFeature addConnBetweenFeature(@RequestBody ConnBetweenFeature connBetweenFeature){
        return connBetweenFeatureService.addConnBetweenFeature(connBetweenFeature);
    }

    @RequestMapping(value = "/all", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public List<ConnBetweenFeature> getConnBetweenFeatures(){
        return connBetweenFeatureService.getConnBetweenFeatures();
    }

    @RequestMapping(value = "/getconnbetweenbyid/{id}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public List<ConnBetweenFeature> getConnBetweenById(@PathVariable(value = "id") long id){
        return connBetweenFeatureService.getConnBetweenById(id);
    }

    @RequestMapping(value = "/get/{id}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ConnBetweenFeature getConnBetweenFeatureById(@PathVariable(value = "id") String id){
        // exception
        return connBetweenFeatureService.getConnBetweenFeatureById(Long.parseLong(id));
    }

    // localhost:8080/cat/delete?id=5&name=Jack
    @RequestMapping(value = "/delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ConnBetweenFeature deleteConnBetweenFeature(@RequestParam(value = "id") String id) {
        return connBetweenFeatureService.deleteConnBetweenFeature(Long.parseLong(id));
    }

    @RequestMapping(value = "/upd", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ConnBetweenFeature updConnBetweenFeature(@RequestBody ConnBetweenFeature connBetweenFeature){
        return connBetweenFeatureService.updConnBetweenFeature(connBetweenFeature);
    }
}
