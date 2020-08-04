package com.sbs.jhs.at.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;

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
}



