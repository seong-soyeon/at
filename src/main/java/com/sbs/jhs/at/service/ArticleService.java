package com.sbs.jhs.at.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;
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
		return articleDao.write(param);
	}

	public int modify(Map<String, Object> param) {
		return articleDao.modify(param);
		  
	}

	public int delete(int id) {
		int delid = articleDao.delete(id);
		return delid;
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
}