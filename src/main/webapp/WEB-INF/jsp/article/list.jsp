<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시물 리스트" />
<%@ include file="../part/head.jspf" %>


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
				<th>제목</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${articles}" var="article">
				<tr>
					<td>${article.id}</td>
					<td>${article.regDate}</td>
					<td><a href="detail?id=${article.id}">${article.title}</a></td>
				</tr>
			</c:forEach>	
		</tbody>
	</table>
	<div class="con btnbtn">
		<button type="button" onclick="location.href='write' ">글쓰기</button>
	</div>
</div><a href="?searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}&page=${i}" class="block">${i}</a>

	<div class="con page-box">
		<ul class="flex flex-jc-c">
			<c:forEach var="i" begin="1" end="${totalPage}" step="1">
				<!-- 삼항연산자 i == paramPage 가 참이면 "current"  거짓이면 ""  -->
				<li class="${i == cPage ? 'current' : ''}">
					<a href="?searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}&page=${i}" class="block">${i}</a>
				</li>
			</c:forEach>
		</ul>
	</div>
<%@ include file="../part/foot.jspf" %>