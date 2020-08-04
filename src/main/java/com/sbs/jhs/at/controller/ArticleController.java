package com.sbs.jhs.at.controller;
//https://gist.github.com/jhs512/cd164d0acdf1d9b50936454d25e6146d/revisions
//게시물 리스팅, 검색, 페이징, 이전글,다음글
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
		int totalCount = articleService.getTotalCount();
		
		model.addAttribute("articles", articles);
		model.addAttribute("totalCount", totalCount);
		
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
	public String showWrite(Model model) {
		return "article/write";
	}

	@RequestMapping("/article/doWrite")
	@ResponseBody
	public String doWrite(@RequestParam Map<String, Object> param) {
		int newId = articleService.write(param);
		
		return "html:<script> alert('" + newId + "번 게시물이 생성되었습니다.'); location.replace('list'); </script>";
	}

	@RequestMapping("/article/modify")
	public String showModify(Model model, int id) {
		Article article = articleService.getForPrintArticleById(id);

		model.addAttribute("article", article);
		
		return "article/modify";
	}
	
	@RequestMapping("/article/doModify")
	@ResponseBody
	public String doModify(@RequestParam Map<String, Object> param) {
		int id = Integer.parseInt((String)param.get("id"));
		articleService.modify(param);
		
		return "html:<script> alert('" + id + "번 게시물이 수정되었습니다.'); location.replace('list'); </script>";
	}
	
	@RequestMapping("/article/doDelete")
	@ResponseBody
	public String doDelete(Model model, int id) {
		articleService.delete(id);

		return "html:<script> alert('" + id + "번 게시물이 삭제되었습니다.'); location.replace('list'); </script>";
	}
}
