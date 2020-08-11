<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시물 상세보기" />
<%@ include file="../part/head.jspf" %>

<div class="table-box con detail-box">
	<table>
		<tbody>
			<tr>
				<th>번호</th>
				<td>${article.id}</td>
			</tr>
			<tr>
				<th>날짜</th>
				<td>${article.regDate}</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${article.title}</td>
			</tr>
			<tr class="body">
				<th>내용</th>
				<td>${article.body}</td>
			</tr>
		</tbody>
	</table>
	<div class="move-btn"><!-- eq = (==), ne = (!=), empty = list,map등의 객체가 값이 있다,없다를 구분(ex)empty, !empty)-->
		<c:choose>
			<c:when test="${prevId != 0 }">
				<a class="move-btn1" href="detail?id=${prevId}">< 이전글</a>
			</c:when>
			<c:otherwise>
				이전 게시글이 없습니다.
		   </c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${nextId != totalCount}">
				<a class="move-btn1" href="detail?id=${nextId}">다음글 ></a>
			</c:when>
			<c:otherwise>
				다음 게시글이 없습니다.
		   </c:otherwise>
		</c:choose>
	</div>
	<div class="con btnbtn">
		<button type="button" onclick="location.href='list'">뒤로가기</button>
		<button type="button" onclick="location.href='write'">게시물 추가</button>
		<button type="button" onclick="location.href='modify?id=${article.id}'">게시물 수정</button>
		<button type="button" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false; location.href='./doDelete?id=${article.id}'">게시물 삭제</button>
	</div>
</div>

<div class="con">
	<h2 class="con">댓글작성</h2>
	
	<script>
		function ArticleReply__submitWriteForm(form) {
			form.body.value = form.body.value.trim();
			if (form.body.value.length == 0) {
				alert('댓글을 입력해주세요.');
				form.body.focus();
				return;
			}
			$.post(
				'./doWriteReplyAjax', {
					articleId : param.id,
					body : form.body.value
				}, 
				function(data) {
			
				}, 'json'
			);
			form.body.value = '';
		}
	</script>
	<form class="form1" onsubmit="ArticleReply__submitWriteForm(this); return false;">
		<div class="table-box form-row replytable-box">
			<table>
				<colgroup>
					<col width="10%">
					<col width="80%">
					<col width="10%">
				</colgroup>
				<tbody>
					<tr>
						<th> 내용 </th>
						<td><textarea name="body" placeholder="댓글을 입력해 주세요" maxlength="1000"></textarea></td>
						<td>
							<input class="replybtn" type="submit" value="작성">
							<input class="replybtn" type="reset" value="취소" onclick="if ( confirm('취소하시겠습니까?(리스트로 이동합니다.)') == false ) return false; location.href='list'">
						</td>
					</tr>	
				</tbody>
			</table>
		</div>
	</form>
</div>

<div class="con">
	<h2 class="con">댓글 리스트</h2>
	
	<script>
		var ArticleReply__lastLoadedArticleReplyId = 0;
		function ArticleReply__loadList() {
			$.get('./getForPrintArticleRepliesRs', {
				id : param.id,
				from : ArticleReply__lastLoadedArticleReplyId +1
			}, function(data) {
				data.articleReplies = data.articleReplies.reverse();
				
				for (var i = 0; i < data.articleReplies.length; i++) {
					var articleReply = data.articleReplies[i];
					ArticleReply__drawReply(articleReply);

					ArticleReply__lastLoadedArticleReplyId = articleReply.id;
				}

				setTimeout(ArticleReply__loadList, 1000);
			}, 'json');
		}

		//댓글이 들어올 때 마다 prepend로 아래와 같은 html넣음
		var ArticleReply__$listTbody;

		function ArticleReply__drawReply(articleReply) {
			var html = $('.template-box-1 tbody').html();

			html = replaceAll(html, "{$번호}", articleReply.id);
			html = replaceAll(html, "{$날짜}", articleReply.regDate);
			html = replaceAll(html, "{$내용}", articleReply.body);
				
			/* 
			var html = ''; 
			html = '<tr data-article-reply-id="' + articleReply.id + '">'; 
			html += '<td>' + articleReply.id + '</td>';
			html += '<td>' + articleReply.regDate + '</td>';
			html += '<td>' + articleReply.body + '</td>';
			html += '<td>';
			html += '<a href="#" class="reply-btn">삭제</a>';
			html += '<a href="#" class="reply-btn">수정</a>';
			//html += '<button type="button" onclick="location.href='#'">수정</button>';
			//html += '<button type="button" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false; location.href='#'">삭제</button>';
			html += '</td>';
			html += '</tr>'; */

			ArticleReply__$listTbody.prepend(html);
		}
	
		//이 기능은 html도 다 읽어온 후 실행
		$(function() {
			ArticleReply__$listTbody = $('.article-reply-list-box > table tbody');

			ArticleReply__loadList();
		});

		function ArticleReply__delete(obj) {
			alert(obj);
		}
	</script>

	<div class="template-box template-box-1">
		<table>
			<tbody>
				<tr data-article-reply-id="{$번호}">
					<td>{$번호}</td>
					<td>{$날짜}</td>
					<td>{$내용}</td>
					<td>
						<div class="reply-btn">
							<button type="button" onclick="location.href='#'">수정</button>
							<button type="button" onclick="if ( confirm('삭제하시겠습니까?') ) {ArticleReply__delete(this);}">삭제</button>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="table-box article-reply-list-box">
		<table>
			<colgroup>
				<col width="100" />
				<col width="200" />
				<col width="500" />
				<col width="90" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>
					<th>날짜</th>
					<th>내용</th>
					<th>비고</th>
				</tr>
			</thead>
			<tbody>
				<%-- <c:forEach items="${articleReplies}" var="articleReply">
					<tr>
						<td>${articleReply.id}</td>
						<td>${articleReply.regDate}</td>
						<td>${articleReply.body}</td>
						<td>
							<div class="btnbtn">
								<button type="button" onclick="location.href='#'">수정</button>
								<button type="button" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false; location.href='#'">삭제</button>
							</div>
						</td>
					</tr>
				</c:forEach> --%>
			</tbody>
		</table>
	</div>
</div>

<%@ include file="../part/foot.jspf" %>