package com.sbs.jhs.at.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.ArticleReply;

@Mapper // 이렇게 해주면 ArticleDao의 구현체를 마이바티스가 대신 구현해준다.
public interface ArticleDao {
	public List<Article> getForPrintArticles();

	public Article getForPrintArticleById(@Param("id") int id);

	public int write(Map<String, Object> param);

	public int modify(Map<String, Object> param);

	public int delete(int id);

	public int getTotalCount();

	public Integer getForPrevArticle(int id);

	public Integer getForNextArticle(int id);

	public void writeReply(Map<String, Object> param);

	public List<ArticleReply> getForPrintArticleReplies(@Param("articleId") int articleId);

	public void modifyArticleReply(Map<String, Object> param);

	public ArticleReply getForPrintArticleReply(@Param("id") int id);

	public void deleteArticleReply(@Param("id") int id);
}
	