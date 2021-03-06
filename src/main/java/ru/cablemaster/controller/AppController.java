package ru.cablemaster.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AppController {
    @RequestMapping("/")
    public String helloPage(){
        return "index";
    }

    @RequestMapping("/insidefeature")
    public String insidefeaturePage(){
        return "insidefeature";
    }

    @RequestMapping("/betweenfeature")
    public String betweenfeaturePage(){
        return "betweenfeature";
    }

    @RequestMapping("/maptrassa")
    public String maptrassaPage(){
        return "maptrassa";
    }

    @RequestMapping("/mapschema")
    public String mapschemaPage(){
        return "mapschema";
    }

    @RequestMapping("/createfeature")
    public String createfeaturePage(){
        return "createfeature";
    }

    @RequestMapping("/help")
    public String helpPage(){
        return "help";
    }
}
