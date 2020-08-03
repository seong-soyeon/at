package com.sbs.jhs.at.service;

import java.util.List;

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
}



