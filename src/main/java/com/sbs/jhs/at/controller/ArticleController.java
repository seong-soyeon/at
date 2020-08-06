package com.sbs.jhs.at.controller;
//https://gist.github.com/jhs512/cd164d0acdf1d9b50936454d25e6146d/revisions
//게시물 리스팅, 검색52분, 페이징
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.ArticleReply;
import com.sbs.jhs.at.service.ArticleService;

@Controller
public class ArticleController {
	@Autowired	//알아서 객체생성//service.java에서 @component나@service 붙어있는것에서 힌트받아 사용
	private ArticleService articleService;
	
	@RequestMapping("/article/list")
	public String showList(Model model, @RequestParam Map<String, Object> param) {
		int page = 1;
		if (param.get("page") != null) {
			page = Integer.parseInt((String) param.get("page"));
		}
		String searchKeywordType = "";
		if (param.get("searchKeywordType") != null ) {
			searchKeywordType = (String)param.get("searchKeywordType"); 
		}
		String searchKeyword = "";
		if (param.get("searchKeyword") != null ) {
			searchKeyword = (String) param.get("searchKeyword");
		}
		
		int totalCount = articleService.getTotalCount();
		// 한페이지당 아티클 수		
		int itemsInAPage = 5;
		int limitFrom = (page - 1) * itemsInAPage;
		int totalPage = (int) Math.ceil(totalCount / (double) itemsInAPage);


		List<Article> articles = articleService.getForPrintArticles();
		
		model.addAttribute("articles", articles);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("searchKeywordType", searchKeywordType);
		model.addAttribute("searchKeyword", searchKeyword);
		
		return "article/list";
	}

	@RequestMapping("/article/detail")
	public String showDetail(Model model, @RequestParam Map<String, Object> param) {
		int id = Integer.parseInt((String)param.get("id"));
		Article article = articleService.getForPrintArticleById(id);

		int totalCount = articleService.getTotalCount();
		int prevId = id-1;
		int nextId = id+1;
		int lastId = totalCount;
		model.addAttribute("prevId", prevId);
		model.addAttribute("nextId", nextId);
		model.addAttribute("lastId", lastId);
		model.addAttribute("article", article);
		
		List<ArticleReply> articleReplies = articleService.getForPrintArticleReplies(article.getId());

		model.addAttribute("articleReplies", articleReplies);
		
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
	
	@RequestMapping("/article/doWriteReply")
	@ResponseBody
	public String doWriteReply(Model model, @RequestParam Map<String, Object> param) {
		Map<String, Object> rs = articleService.writeReply(param);
		
		String msg = (String) rs.get("msg");
		String redirectUrl = (String) param.get("redirectUrl");

		model.addAttribute("alertMsg", msg);
		model.addAttribute("locationReplace", redirectUrl);

		return "common/redirect";
	}

	@RequestMapping("article/modifyReply")
	public String showModifyReply(Model model, int id, HttpServletRequest request) {

		ArticleReply articleReply = articleService.getForPrintArticleReply(id);

		model.addAttribute("articleReply", articleReply);

		return "article/modifyReply";
	}

	@RequestMapping("article/doModifyReply")
	public String doModifyReply(Model model, @RequestParam Map<String, Object> param, HttpServletRequest request) {

		int id = Integer.parseInt((String)param.get("id"));
		Map<String, Object> rs = articleService.modifyReply(param);

		String msg = (String) rs.get("msg");
		String redirectUrl = (String) param.get("redirectUrl");

		model.addAttribute("alertMsg", msg);
		model.addAttribute("locationReplace", "detail?id=" + id + "");

		return "common/redirect";
	}

	@RequestMapping("article/doDeleteReply")
	public String doDeleteReply(Model model, int id, String redirectUrl, HttpServletRequest request) {

		Map<String, Object> rs = articleService.deleteArticleReply(id);

		String msg = (String) rs.get("msg");

		model.addAttribute("alertMsg", msg);
		model.addAttribute("locationReplace", redirectUrl);

		return "common/redirect";
	}
}
