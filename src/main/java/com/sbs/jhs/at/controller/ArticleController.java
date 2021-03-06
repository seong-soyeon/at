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
import com.sbs.jhs.at.dto.Reply;
import com.sbs.jhs.at.service.ArticleService;
import com.sbs.jhs.at.util.Util;

@Controller
public class ArticleController {
	@Autowired	//알아서 객체생성//service.java에서 @component나@service 붙어있는것에서 힌트받아 사용
	private ArticleService articleService;
	
	@RequestMapping("/usr/article/list")
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

	@RequestMapping("/usr/article/detail")
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
		
		//List<Reply> replies = articleService.getForPrintReplies(article.getId());

		//model.addAttribute("replies", replies);
		
		return "article/detail";
	}

	@RequestMapping("/usr/article/write")
	public String showWrite() {
		return "article/write";
	}

	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	public String doWrite(@RequestParam Map<String, Object> param) {
		int newArticleId = articleService.write(param);
		
		String redirectUrl = (String) param.get("redirectUrl");
		redirectUrl = redirectUrl.replace("#id", newArticleId + "");
		
		//return "redirect:" + redirectUrl;//이걸로도 되는지 확인
		return "html:<script> alert('" + newArticleId + "번 게시물이 생성되었습니다.'); location.replace('list'); </script>";
	}

	@RequestMapping("/usr/article/modify")
	public String showModify(Model model, int id) {
		Article article = articleService.getForPrintArticleById(id);

		model.addAttribute("article", article);
		
		return "article/modify";
	}
	
	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public String doModify(@RequestParam Map<String, Object> param) {
		int id = Integer.parseInt((String)param.get("id"));
		articleService.modify(param);
		
		return "html:<script> alert('" + id + "번 게시물이 수정되었습니다.'); location.replace('list'); </script>";
	}
	
	@RequestMapping("/usr/article/doDelete")
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
	
	/*
	 * @RequestMapping("/usr/article/doWriteReply")
	 * 
	 * @ResponseBody public String doWriteReply(Model model, @RequestParam
	 * Map<String, Object> param) { int id =
	 * Integer.parseInt((String)param.get("id"));//이거 Map<String, Object> rs =
	 * articleService.writeReply(param);
	 * 
	 * String msg = (String) rs.get("msg"); String redirectUrl = (String)
	 * param.get("redirectUrl");
	 * 
	 * Reply reply = getReply(id);//이거 int articleId = reply.getArticleId();//이거
	 * 
	 * model.addAttribute("alertMsg", msg); model.addAttribute("locationReplace",
	 * "detail?id=' + articleId + '");//이거 필요없어지면 수정&삭제하기
	 * 
	 * return "common/redirect"; }
	 */
	
	//Rs = Map을 리턴 한다는뜻
	@RequestMapping("/usr/article/getForPrintRepliesRs")
	@ResponseBody
	public Map<String, Object> getForPrintRepliesRs(int id, @RequestParam Map<String, Object> param, int from) {
		param.put("relTypeCode", "article");
		Util.changeMapKey(param, "articleId", "relId");
		
		List<Reply> replies = articleService.getForPrintReplies(param, from);

		int relId = Integer.parseInt((String)param.get("relId"));
		System.out.println(from);
		System.out.println(relId);
		Map<String, Object> rs = new HashMap<>();
		
		rs.put("resultCode", "S-1");
		rs.put("msg", String.format("총 %d개의 댓글이 있습니다.", replies.size()));
		
		rs.put("replies", replies);
		
		return rs;
		
		/*쌤
		Map<String, Object> rsDataBody = new HashMap<>();

		param.put("relTypeCode", "article");
		Util.changeMapKey(param, "articleId", "relId");

		List<Reply> replies = articleService.getForPrintReplies(param);
		rsDataBody.put("replies", replies);

		return new ResultData("S-1", String.format("%d개의 댓글을 불러왔습니다.", replies.size()), rsDataBody);
		 */
		
		/*나
		 List<ArticleReply> articleReplies = articleService.getForPrintArticleReplies(id, from);

		Map<String, Object> rs = new HashMap<>();
		rs.put("resultCode", "S-1");
		rs.put("msg", String.format("총 %d개의 댓글이 있습니다.", articleReplies.size()));
		rs.put("articleReplies", articleReplies);

		return rs;
		 * */
	}
	
	@RequestMapping("/usr/article/doWriteReplyAjax")
	@ResponseBody
	public Map<String, Object> doWriteReplyAjax(@RequestParam Map<String, Object> param, HttpServletRequest  request ) {
		
		param.put("relTypeCode", "article");
		Util.changeMapKey(param, "articleId", "relId");
		
		Map<String, Object> rs = articleService.writeReply(param);
		int relId = Integer.parseInt((String)param.get("relId"));
		String relTypeCode = (String)param.get("relTypeCode");
		System.out.println(relTypeCode);
		System.out.println(relId);
		return rs;
	}

	@RequestMapping("article/modifyReply")
	public String showModifyReply(Model model, int id, HttpServletRequest request) {

		Reply reply = articleService.getForPrintReply(id);

		model.addAttribute("reply", reply);

		return "article/modifyReply";
	}

	/*
	 * @RequestMapping("article/doModifyReply") public String doModifyReply(Model
	 * model, @RequestParam Map<String, Object> param, HttpServletRequest request) {
	 * int id = Integer.parseInt((String)param.get("id")); Map<String, Object> rs =
	 * articleService.modifyReply(param);
	 * 
	 * String msg = (String) rs.get("msg"); String redirectUrl = (String)
	 * param.get("redirectUrl");
	 * 
	 * Reply reply = getReply(id); int articleId = reply.getArticleId();
	 * 
	 * model.addAttribute("alertMsg", msg); model.addAttribute("locationReplace",
	 * "detail?id=" + articleId + "");
	 * 
	 * return "common/redirect"; }
	 */

	private Reply getReply(int id) {
		return articleService.getReply(id);
	}

	/*
	 * @RequestMapping("article/doDeleteReply") public String doDeleteReply(Model
	 * model, int id, String redirectUrl, HttpServletRequest request) { Reply reply
	 * = getReply(id); int articleId = reply.getArticleId();
	 * 
	 * Map<String, Object> rs = articleService.deleteReply(id);
	 * 
	 * String msg = (String) rs.get("msg");
	 * 
	 * 
	 * model.addAttribute("alertMsg", msg); model.addAttribute("locationReplace",
	 * "detail?id=" + articleId + "");
	 * 
	 * return "common/redirect"; }
	 */
	
	@RequestMapping("article/doDeleteReplyAjax")
	@ResponseBody
	public Map<String, Object> doDeleteReply(int id, String redirectUrl, HttpServletRequest request) {
		Map<String, Object> rs = articleService.deleteReply(id);
		
		return rs;
	}
	
	@RequestMapping("article/doModifyReplyAjax")
	@ResponseBody
	public Map<String, Object> doModifyReplyAjax(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		Map<String, Object> rs = articleService.modifyReply(param);

//		try {
//			Thread.sleep(3000);
//		} catch (InterruptedException e) {
//			e.printStackTrace();
//		}

		return rs;
	}
}
