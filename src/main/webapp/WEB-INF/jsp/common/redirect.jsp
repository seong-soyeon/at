<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script>
	var historyBack = '${historyBack}' == 'true';

	if (historyBack) {
		history.back();
	}

	var alertMsg = '${alertMsg}'.trim();


	var locationReplaceUrl = '${locationReplace}'.trim();
	
	if ( locationReplaceUrl ) {
		if (alertMsg) {
			alert(alertMsg);
		}
		location.replace(locationReplaceUrl);
	}
</script>