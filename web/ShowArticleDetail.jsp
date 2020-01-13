<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="Error.jsp" %>
<html>
<head>
    <title>Article Detail</title>
</head>
<%
    // 获取请求参数
    String sid = request.getParameter("id");
    int id = Integer.parseInt(sid);

    // 连接MySQL查询数据
    Class.forName("com.mysql.jdbc.Driver");
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost/bbs", "root", "root");
    Statement statement = connection.createStatement();
    ResultSet resultSet = statement.executeQuery("SELECT * FROM article WHERE id=" + id);
%>
<body>
<% if (resultSet.next()) { %>
<%--格式化输出--%>
<table border="1">
    <tr>
        <td>ID</td>
        <td><%= resultSet.getInt("id") %></td>
    </tr>
    <tr>
        <td>Title</td>
        <td><%= resultSet.getString("title") %></td>
    </tr>
    <tr>
        <td>Content</td>
        <td><%= resultSet.getString("cont") %></td>
    </tr>
</table>
<p>
    <a href="Reply.jsp?id=<%= resultSet.getInt("id") %>&rootid=<%= resultSet.getInt("rootid") %>">发表回复></a>
</p>

<% }
resultSet.close();
statement.close();
connection.close();
%>
</body>
</html>
