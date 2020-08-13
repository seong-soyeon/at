package com.sbs.jhs.at.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.Reply;
import com.sbs.jhs.at.util.Util;

@Service
public class ArticleService {
	@Autowired
	private ArticleDao articleDao;
		
	public List<Article> getForPrintArticles() {
		return articleDao.getForPrintArticles();
	}

	public Article getForPrintArticleById(int id) {
		return articleDao.getForPrintArticleById(id);
	}

	public int write(Map<String, Object> param) {
		articleDao.write(param);
		
		return  Util.getAsInt(param.get("id"));
	}

	public int modify(Map<String, Object> param) {
		return articleDao.modify(param);
	}

	public Map<String, Object> deleteArticle(int id) {
		articleDao.deleteArticle(id);
		Map<String, Object> rs = new HashMap<>();

		rs.put("resultCode", "S-1");
		rs.put("msg", String.format("%d번 게시물이 삭제되었습니다.", id));

		return rs;
	}

	public int getTotalCount() {
		return articleDao.getTotalCount();
	}

	public Integer getForPrevArticle(int id) {
		return articleDao.getForPrevArticle(id);
	}

	public Integer getForNextArticle(int id) {
		return articleDao.getForNextArticle(id);
	}

	public Map<String, Object> writeReply(Map<String, Object> param) {
		articleDao.writeReply(param);
		int id = Util.getAsInt(param.get("id"));
		Map<String, Object> rs = new HashMap<>();
		
		rs.put("resultCode", "S-1");
		rs.put("msg", String.format("%d번 게시물 댓글이 생성되었습니다.", id));
		return rs;
	}
	
	/*
	 * public List<Reply> getForPrintReplies(int id) { return
	 * articleDao.getForPrintReplies(id); }
	 */
	
	public List<Reply> getForPrintReplies(@RequestParam Map<String, Object> param, int from) {
		return articleDao.getForPrintRepliesFrom(param, from);
	}

	public Reply getForPrintReply(int id) {
		Reply reply = articleDao.getForPrintReply(id);

		return reply;
	}

	public Map<String, Object> modifyReply(Map<String, Object> param) {
		int id = Util.getAsInt(param.get("id"));
		articleDao.modifyReply(param);
		Map<String, Object> rs = new HashMap<>();

		rs.put("resultCode", "S-1");
		rs.put("msg", String.format("%d번 게시물 댓글이 수정되었습니다.", id));

		return rs;
	}

	public Map<String, Object> deleteReply(int id) {
		articleDao.deleteReply(id);
		Map<String, Object> rs = new HashMap<>();

		rs.put("resultCode", "S-1");
		rs.put("msg", String.format("%d번 게시물 댓글이 삭제되었습니다.", id));

		return rs;
	}

	public Reply getReply(int id) {
		return articleDao.getReply(id);
	}
}