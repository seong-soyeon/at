package com.sbs.jhs.at.controller;
import java.util.HashMap;
//https://gist.github.com/jhs512/cd164d0acdf1d9b50936454d25e6146d/revisions
//게시물 리스팅, 검색52분, 페이징//아젝스 댓글작성 오류남 url 문제인듯(interceptor>BdforeActionInteceptor 먼저!)
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
		Map<String, Object> rs = articleService.deleteArticle(id);

		String msg = (String)rs.get("msg");
		String redirectUrl = "/article/list";

		model.addAttribute("alertMsg", msg);
		model.addAttribute("locationReplace", redirectUrl);
		System.out.println(redirectUrl);

		return "common/redirect";
	}
	
	@RequestMapping("/article/doWriteReply")
	@ResponseBody
	public String doWriteReply(Model model, @RequestParam Map<String, Object> param) {
		int id = Integer.parseInt((String)param.get("id"));//이거
		Map<String, Object> rs = articleService.writeReply(param);
		
		String msg = (String) rs.get("msg");
		String redirectUrl = (String) param.get("redirectUrl");

		ArticleReply articleReply = getArticleReply(id);//이거
		int articleId = articleReply.getArticleId();//이거
		
		model.addAttribute("alertMsg", msg);
		model.addAttribute("locationReplace", "detail?id=' + articleId + '");//이거 필요없어지면 수정&삭제하기

		return "common/redirect";
	}
	
	@RequestMapping("/article/getForPrintArticleRepliesRs")
	@ResponseBody
	public Map<String, Object> getForPrintArticleRepliesRs(int id) {
		List<ArticleReply> articleReplies = articleService.getForPrintArticleReplies(id);
		

		Map<String, Object> rs = new HashMap<>();
		rs.put("resultCode", "S-1");
		rs.put("msg", String.format("총 %d개의 댓글이 있습니다.", articleReplies.size()));
		rs.put("articleReplies", articleReplies);
		
		return rs;
	}
	
	@RequestMapping("/article/doWriteReplyAjax")
	@ResponseBody
	public Map<String, Object> doWriteReplyAjax(Model model, @RequestParam Map<String, Object> param, HttpServletRequest  request ) {
		Map<String, Object> rs = articleService.writeReply(param);
		
		return rs;
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

		ArticleReply articleReply = getArticleReply(id);
		int articleId = articleReply.getArticleId();
		
		model.addAttribute("alertMsg", msg);
		model.addAttribute("locationReplace", "detail?id=" + articleId + "");

		return "common/redirect";
	}

	private ArticleReply getArticleReply(int id) {
		return articleService.getArticleReply(id);
	}

	@RequestMapping("article/doDeleteReply")
	public String doDeleteReply(Model model, int id, String redirectUrl, HttpServletRequest request) {
		ArticleReply articleReply = getArticleReply(id);
		int articleId = articleReply.getArticleId();
		
		Map<String, Object> rs = articleService.deleteArticleReply(id);

		String msg = (String) rs.get("msg");

		
		model.addAttribute("alertMsg", msg);
		model.addAttribute("locationReplace", "detail?id=" + articleId + "");

		return "common/redirect";
	}
}
