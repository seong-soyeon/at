<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시물 수정" />
<%@ include file="../part/head.jspf" %>
	
<form method="POST" action="doModifyReply">
	<input type="hidden" name="id" value="${reply.id}" /> <input
		type="hidden" name="redirectUrl" value="${param.redirectUrl}" />
	<div class="table-box con">
		<table>
			<colgroup>
				<col width="180">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th>번호</th>
					<td>${reply.id}</td>
				</tr>
				<tr>
					<th>날짜</th>
					<td>${reply.regDate}</td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea maxlength="300" class="height-100px" name="body"
							placeholder="내용을 입력해주세요.">${reply.body}</textarea></td>
				</tr>
				<tr>
					<th>수정</th>
					<td>
						<input type="submit" value="수정" />
						<input type="reset"	value="취소" onclick="history.back();" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</form>

<%@ include file="../part/foot.jspf"%>