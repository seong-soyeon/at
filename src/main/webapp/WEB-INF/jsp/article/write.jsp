<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 작성</title>
</head>
<body>
	<h1>게시물 작성</h1>
	
	<form action="doWrite">
		<div>
			<span> 제목 </span>
			<div>
				<input name="title" type="text" placeholder="제목" autofocus="autofocus">
			</div>
		</div>
		<div>
			<span> 내용 </span>
			<div>
				<textarea name="body" placeholder="내용"></textarea>
			</div>
		</div>
	</form>
</body>
</html>