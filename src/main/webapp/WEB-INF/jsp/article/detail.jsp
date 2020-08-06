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
	<h2>댓글작성</h2>
	<form action="doWriteReply" method="POST" class="form1" onsubmit="WriteReply__submitForm(this); return false;">
		<input type="hidden" name="articleId" value="${article.id}">
		<input type="hidden" name="redirectUrl" value="${requestUriQueryString}">
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
							<input class="replybtn" type="reset" value="취소" onclick="if ( confirm('취소하시겠습니까?(리스트로 이동합니다.)') == false ) return false; 	location.href='list'">
						</td>
					</tr>	
				</tbody>
			</table>
		</div>
	</form>
</div>

<div class="con">
	<h2 class="con">댓글 리스트</h2>
	<div class="table-box">
		<table>
			<colgroup>
				<col width="100" />
				<col width="200" />
				<col width="500" />
				<col width="130" />
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
						<td>
							<div class="btnbtn">
								<button type="button" onclick="location.href='modifyReply?id=${articleReply.id}'">수정</button>
								<button type="button" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false; location.href='./doDeleteReply?id=${articleReply.id}'">삭제</button>
							</div>
						</td>
					</tr>
				</c:forEach>	
			</tbody>
		</table>
	</div>
</div>
<script>
	function WriteReply__submitForm(form) {
		form.body.value = form.body.value.trim();
		if (form.body.value.length == 0) {
			alert('댓글을 입력해주세요.');
			form.body.focus();
			return;
		}
		$.post('./doWriteReplyAjax', {
			articleId : param.id,
			body : form.body.value
		}, function(data) {
				if (data.msg) {
					alert(data.msg);
				}
				if ( data.resultCode.substr(0, 2) == 'S-' ) {
					location.reload(); // 임시
				}
			}, 'json');
			form.body.value = '';
		}
	</script>
<%@ include file="../part/foot.jspf" %>