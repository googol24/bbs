<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<html>
<head>
    <title>Error Page</title>
</head>
<body>
<h2>
    <p>Error: <%= exception.getMessage() %></p>
    <p>详细信息请见控制台输出</p>
    <%
        // 控制台输出报错
        exception.printStackTrace();
    %>
</h2>
</body>
</html>
