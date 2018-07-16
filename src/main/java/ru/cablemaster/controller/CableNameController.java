package ru.cablemaster.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import ru.cablemaster.entity.CableName;
import ru.cablemaster.service.CableNameService;

import java.util.List;

@Controller
@RequestMapping("/cablename")
public class CableNameController {
    @Autowired
    private CableNameService cableNameService;

    @RequestMapping(value = "/add", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public CableName addCableName(@RequestBody CableName cableName){
        return cableNameService.addCableName(cableName);
    }

    @RequestMapping(value = "/all", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public List<CableName> getCableNames(){
        return cableNameService.getAllCableNames();
    }

    @RequestMapping(value = "/get/{id}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public CableName getCableNameById(@PathVariable(value = "id") String id){
        // exception
        return cableNameService.getCableNameById(Long.parseLong(id));
    }

    // localhost:8080/cat/delete?id=5&name=Jack
    @RequestMapping(value = "/delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
    @ResponseBody
    public CableName deleteCableName(@RequestParam(value = "id") String id) {
        return cableNameService.deleteCableName(Long.parseLong(id));
    }

    @RequestMapping(value = "/upd", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
    @ResponseBody
    public CableName updCableName(@RequestBody CableName cableName){
        return cableNameService.updCableName(cableName);
    }
}
