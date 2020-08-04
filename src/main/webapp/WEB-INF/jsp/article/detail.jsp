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
	<div class="move-btn">
		<a class="move-btn1" href="#">< 이전글</a>
		<a class="move-btn1" href="#">다음글 ></a>
	</div>
	<div class="con btnbtn">
		<button type="button" onclick="location.href='list'">뒤로가기</button>
		<button type="button" onclick="location.href='write'">게시물 추가</button>
		<button type="button" onclick="location.href='modify?id=${article.id}'">게시물 수정</button>
		<button type="button" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false; 	location.href='./doDelete?id=${article.id}	'">게시물 삭제</button>
	</div>
</div>
<style>
.body {
	height: 200px;
}
.move-btn {
	text-align: center;
}
.move-btn> .move-btn1 {
	margin: 10px;
}
</style>
<%@ include file="../part/foot.jspf" %>