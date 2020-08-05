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
		<button type="button" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false; location.href='./doDelete?id=${article.id}	'">게시물 삭제</button>
	</div>
</div>

<h2 class="con">댓글작성</h2>

<form action="doWriteReply" method="POST" class="con form1" onsubmit="ArticleWriteForm__submit(this); return false;">
	<input type="hidden" name="articleId" value="${article.id}">
	<input type="hidden" name="redirectUrl" value="${requestUriQueryString}">
	<div class="con table-box replytable-box">
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
						<input class="replybtn" type="reset"	value="취소" onclick="if ( confirm('취소하시겠습니까?(리스트로 이동합니다.)') == false ) return false; 	location.href='list'">
					</td>
				</tr>					
				</tr>
				
			</tbody>
		</table>
	</div>
</form>

<h2 class="con">댓글 리스트</h2>

<div class="search con flex">
	<div>전체 게시물 개수 : ${totalCount}</div>
	<div class="search-box">
		<form action="list">
			<input type="hidden" name="page" value="1" /> 
			<input type="hidden" name="searchKeywordType" value="title" /> 
			<input type="text" name="searchKeyword" value="${param.searchKeyword}" />
			<button type="submit">검색</button>
		</form>
	</div>
</div>

<div class="table-box con">
	<table>
		<colgroup>
			<col width="100" />
			<col width="200" />
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
			<c:forEach items="${articleReplies}" var="articleReply">
				<tr>
					<td>${articleReply.id}</td>
					<td>${articleReply.regDate}</td>
					<td>${articleReply.body}</td>
					<td><a href="detail?id=${article.id}">${article.title}</a></td>
				</tr>
			</c:forEach>	
		</tbody>
	</table>
	<div class="con btnbtn">
		<button type="button" onclick="location.href='write' ">글쓰기</button>
	</div>
</div>






<%@ include file="../part/foot.jspf" %>