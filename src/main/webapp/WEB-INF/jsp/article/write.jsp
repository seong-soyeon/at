<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시물 작성" />
<%@ include file="../part/head.jspf" %>
	
	<form action="doWrite" method="POST" class="con form1" onsubmit="ArticleWriteForm__submit(this); return false;">
		<div class="form-row">
			<span> 제목 </span>
			<div>
				<input name="title" type="text" placeholder="제목" maxlength="100" autofocus="autofocus">
			</div>
		</div>
		<div class="form-row">
			<span> 내용 </span>
			<div>
				<textarea name="body" placeholder="내용" maxlength="2000"></textarea>
			</div>
		</div>
		<div class="form-row">
			<div class="flex">
				<input type="submit" value="작성">
				<input type="reset"	value="취소" onclick="if ( confirm('취소하시겠습니까?(리스트로 이동합니다.)') == false ) return false; 	location.href='list'">
			</div>
		</div>	
	</form>

<script>
	function ArticleWriteForm__submit(form) {
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