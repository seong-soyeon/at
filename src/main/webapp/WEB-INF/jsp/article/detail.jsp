<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시물 상세보기" />
<%@ include file="../part/head.jspf" %>
<style>
.article-reply-list-box tr .loading-delete-inline  {
	display: none;
	font-weight: bold;
	color: red;
}
.article-reply-list-box tr[data-loading="Y"] .loading-none {
	display: none;
}

.article-reply-list-box tr[data-loading="Y"][data-loading-delete="Y"] .loading-delete-inline {
	display: inline;
}
.article-reply-list-box tr[data-modify-mode="Y"] .modify-mode-none {
	display: none;
}
.article-reply-list-box tr .modify-mode-inline {
	display: none;
}
.article-reply-list-box tr .modify-mode-block {
	display: none;
}
.article-reply-list-box tr[data-modify-mode="Y"] .modify-mode-block {
	display: block;
}
.article-reply-list-box tr[data-modify-mode="Y"] .modify-mode-inline {
	display: inline;
}
</style>

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
		function Reply__submitWriteForm(form) {
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
	<form class="form1" onsubmit="Reply__submitWriteForm(this); return false;">
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
		var Reply__lastLoadedReplyId = 0;
		function Reply__loadList() {
			$.get('./getForPrintRepliesRs', {
				articleId : param.id,
				from : Reply__lastLoadedReplyId +1
			}, function(data) {
				data.replies = data.replies.reverse();
				
				for (var i = 0; i < data.replies.length; i++) {
					var reply = data.replies[i];
					Reply__drawReply(reply);

					Reply__lastLoadedReplyId = reply.id;
				}

				setTimeout(Reply__loadList, 1000);
			}, 'json');
		}

		//댓글이 들어올 때 마다 prepend로 아래와 같은 html넣음
		var Reply__$listTbody;

		function Reply__drawReply(reply) {
			var html = $('.template-box-1 tbody').html();

			html = replaceAll(html, "{$번호}", reply.id);
			html = replaceAll(html, "{$날짜}", reply.regDate);_
			html = replaceAll(html, "{$내용}", reply.body);
				
			/* 
			var html = ''; 
			html = '<tr data-article-reply-id="' + reply.id + '">'; 
			html += '<td>' + reply.id + '</td>';
			html += '<td>' + reply.regDate + '</td>';
			html += '<td>' + reply.body + '</td>';
			html += '<td>';
			html += '<a href="#" class="reply-btn">삭제</a>';
			html += '<a href="#" class="reply-btn">수정</a>';
			//html += '<button type="button" onclick="location.href='#'">수정</button>';
			//html += '<button type="button" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false; location.href='#'">삭제</button>';
			html += '</td>';
			html += '</tr>'; */

			Reply__$listTbody.prepend(html);
		}
	
		//이 기능은 html도 다 읽어온 후 실행
		$(function() {
			Reply__$listTbody = $('.article-reply-list-box > table tbody');

			Reply__loadList();
		});

		function Reply__enableModifyMode(obj) {
			var $clickedBtn = $(obj);
			var $tr = $clickedBtn.closest('tr');
			var $replyBodyText = $tr.find('.reply-body-text');
			var $textarea = $tr.find('form textarea');
			$textarea.val($replyBodyText.text().trim());
			$tr.attr('data-modify-mode', 'Y');
		}

		function Reply__disableModifyMode(obj) {
			var $clickedBtn = $(obj);
			var $tr = $clickedBtn.closest('tr');

			$tr.attr('data-modify-mode', 'N');
		}

		function Reply__submitModifyReplyForm(form) {
			var $tr = $(form).closest('tr');
			form.body.value = form.body.value.trim();
			if (form.body.value.length == 0) {
				alert('댓글내용을 입력 해주세요.');
				form.body.focus();
				return false;
			}
			var replyId = parseInt($tr.attr('data-article-reply-id'));
			var body = form.body.value;
			$tr.attr('data-loading', 'Y');
			$tr.attr('data-loading-modify', 'Y');
			$.post('./doModifyReplyAjax', {
				id : replyId,
				body : body
			}, function(data) {
				$tr.attr('data-loading', 'N');
				$tr.attr('data-loading-modify', 'N');
				
				Reply__disableModifyMode(form);
				
				if (data.resultCode.substr(0, 2) == 'S-') {
					var $replyBodyText = $tr.find('.reply-body-text');
					var $textarea = $tr.find('form textarea');
					$replyBodyText.text($textarea.val());
				} else {
					if (data.msg) {
						alert(data.msg)
					}
				}
			});
		}

		//이 함수가 있는 버튼과 가장 가까운 tr(=댓글 한개)삭제
		function Reply__delete(obj) {
			var $clickedBtn = $(obj);
			var $tr = $clickedBtn.closest('tr');
			var replyId = parseInt($tr.attr('data-article-reply-id'));
			
			$tr.attr('data-loading', 'Y');
			$tr.attr('data-loading-delete', 'Y');
			
			$.post(
				'./doDeleteReplyAjax', {
					id: replyId
				},
				function(data) {
					$tr.attr('data-loading', 'N');
					$tr.attr('data-loading-delete', 'N');

					if (data.resultCode.substr(0,2) == 'S-') {
						$tr.remove();
					} else {
						if(data.msg) {
							alert(data.msg)
						}
					}
				},
				'json'
			);
			
		}
	</script>

	<div class="template-box template-box-1">
		<table>
			<tbody>
				<tr data-article-reply-id="{$번호}">
					<td>{$번호}</td>
					<td>{$날짜}</td>
					<td>
						<div class="reply-body-text modify-mode-none">{$내용}</div>
						<div class="modify-mode-block">
							<form onsubmit="Reply__submitModifyReplyForm(this); return false;">
								<textarea name="body">{$내용}</textarea>
								<br />
								<input class="loading-none" type="submit" value="수정" />
							</form>
						</div>
					</td>
					<td>
						<div class="reply-btn">
							<span class="loading-delete-inline">삭제중입니다...</span>
					
							<button class="loading-none modify-mode-none"  type="button" 
								onclick="Reply__enableModifyMode(this); return false; location.href='#'">수정</button>
							<button class="loading-none modify-mode-inline"  type="button" 
								onclick="Reply__disableModifyMode(this); return false; location.href='#'">수정취소</button>
							<button class="loading-none"  type="button" 
								onclick="if ( confirm('정말 삭제하시겠습니까?') ) {Reply__delete(this); } return false; location.href='#'">삭제</button>
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
			<%-- <c:forEach items="${replies}" var="reply">
					<tr>
						<td>${reply.id}</td>
						<td>${reply.regDate}</td>
						<td>${reply.body}</td>
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