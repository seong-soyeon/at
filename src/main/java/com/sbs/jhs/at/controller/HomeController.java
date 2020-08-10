package com.sbs.jhs.at.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
	@RequestMapping("/")
	public String showMain() {
		return "home/main";
	}
	
	@RequestMapping("/home/main")
	public String showMain2() {
		return "home/main";
	}
	
	@RequestMapping("/home/testAjax1")
	public String showTestAjax1() {
		return "home/testAjax1";
	}
	
}
