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
<%@ include file="../part/foot.jspf" %>