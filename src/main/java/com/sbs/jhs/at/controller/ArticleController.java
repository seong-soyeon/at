package com.sbs.jhs.at.controller;//https://gist.github.com/jhs512/cd164d0acdf1d9b50936454d25e6146d/revisions

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.service.ArticleService;

@Controller
public class ArticleController {
	@Autowired	//알아서 객체생성//service.java에서 @component나@service 붙어있는것에서 힌트받아 사용
	private ArticleService articleService;
	
	@RequestMapping("/article/list")
	public String showList(Model model) {
		List<Article> articles = articleService.getForPrintArticles();
		
		model.addAttribute("articles", articles);
		
		return "article/list";
	}

	@RequestMapping("/article/detail")
	public String showDetail(Model model, @RequestParam Map<String, Object> param) {
		int id = Integer.parseInt((String)param.get("id"));
		Article article = articleService.getForPrintArticleById(id);

		model.addAttribute("article", article);
		
		return "article/detail";
	}

	@RequestMapping("/article/write")
	public String showWrite() {
		return "article/write";
	}

	@RequestMapping("/article/doWrite")
	@ResponseBody
	public String doWrite() {
		
		return "article/write";
	}
}
