<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시물 수정" />
<%@ include file="../part/head.jspf" %>
	
	<form action="doModify" method="POST" class="con form1" onsubmit="submitModifyForm(this); return false;">
		<input name="id" type="hidden" value="${article.id}">
		<div class="form-row">
			<span> 제목 </span>
			<div>
				<input name="title" type="text" placeholder="제목" autofocus="autofocus" value="${article.title}">
			</div>
		</div>
		<div class="form-row">
			<span> 내용 </span>
			<div>
				<textarea name="body" placeholder="내용">${article.body}</textarea>
			</div>
		</div>
		
		<div class="form-row">
			<div class="flex">
				<input type="submit" value="수정" />
				<input type="reset"	value="취소" onclick="history.back();" />
			</div>
		</div>	
	</form>

<script>
	function submitModifyForm(form) {
		form.title.value = form.title.value.trim();
		if (form.title.value.length == 0) {
			alert('제목을 입력해주세요.');
			form.title.focus();
			return false;
		}
		form.body.value = form.body.value.trim();
		if (form.body.value.length == 0) {
			alert('내용을 입력해주세요.');
			form.body.focus();
			return false;
		}
		form.submit();
	}
</script>

<%@ include file="../part/foot.jspf" %>