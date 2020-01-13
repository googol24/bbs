<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String action = request.getParameter("action");
    if (action != null && action.equals("login")) {
        String userName = request.getParameter("username");
        String password = request.getParameter("password");

        if (userName == null || !userName.equals("admin")) {
%>
            <font color="red" size="5">
                username is not correct!
            </font>
<%
        } else if (password == null || !password.equals("admin123")) {
%>
            <font color="red" size="5">
                password is not correct!
            </font>
<%
        } else {
            // 管理员信息存入session
            session.setAttribute("admin", "true");

            // 跳转到首页
            response.sendRedirect("index.jsp");
        }
    }
%>
<html>
<head>
    <title>BBS后台登录系统</title>
</head>
<body>
    <form method="post" action="Login.jsp">
        <input type="hidden" name="action" value="login">
        <table border="1">
            <tr>
                <th>用户名</th>
                <td>
                    <input type="text" name="username">
                </td>
            </tr>
            <tr>
                <th>密码</th>
                <td>
                    <input type="password" name="password">
                </td>
            </tr>
            <tr align="center">
                <td colspan="2">
                    <input type="submit" value="登录">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>