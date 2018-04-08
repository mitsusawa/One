<%--
  Created by IntelliJ IDEA.
  User: sawata
  Date: 2017/08/12
  Time: 16:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<html>
<head>
	<title>Title</title>
	<meta http-equiv="refresh" content="15">
</head>
<body>
<%
	if (!session.isNew()) {
%>
<script type="text/javascript" language="javascript">
    <!--
    window.location.replace('./');
    // -->
</script>
<%
		session.invalidate();
	} else {
		out.println("500 error");
	}
%>
</body>
</html>
