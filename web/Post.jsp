<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="Error.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 判断请求是GET过来的（跳转）还是POST过来的（提交）
    String action = request.getParameter("action");

    // 处理发帖请求
    if (action != null && action.equals("post")) {
        String title = request.getParameter("title");
        String content = request.getParameter("cont");

        // 参数检查
        if (title == null) {
            out.println("标题不合法！");
            return;
        }
        title = title.trim();

        if (title.equals("")) {
            out.print("标题不能为空！");
            return;
        }

        if (content == null) {
            out.println("内容不合法！");
            return;
        }
        content = content.trim();

        if (content.equals("")) {
            out.print("内容不能为空！");
            return;
        }

        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost/bbs", "root", "root");
        Statement statement = connection.createStatement();
        String insertSql = "INSERT INTO article(`pid`,`rootid`,`title`,`cont`,`pdate`,`isleaf`) VALUES (0, ?, ?, ?, NOW(), 0)";

        // 指定返回插入的KEY
        PreparedStatement preparedStatement = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);

        // 事务处理
        connection.setAutoCommit(false);

        // rootId应该是自身的ID，先填一个-1，后面再更新
        preparedStatement.setInt(1, -1);
        preparedStatement.setString(2, title);
        preparedStatement.setString(3, content);
        preparedStatement.executeUpdate();

        // 获取刚刚插入的帖子记录的id
        ResultSet resultSet = preparedStatement.getGeneratedKeys();
        resultSet.next();
        int key = resultSet.getInt(1);

        // 更新 rootId
        statement.executeUpdate("UPDATE article SET rootid = " + key + " WHERE id = " + key);

        // 事务提交
        connection.commit();

        // 还原现场
        connection.setAutoCommit(true);

        // 资源回收
        resultSet.close();
        preparedStatement.close();
        statement.close();
        connection.close();

        // 跳转到首页
//        response.sendRedirect("index.jsp");

        // 暂时重定向到新的主题帖页
        response.sendRedirect("ShowArticleFlat.jsp");
    }
%>
<html>
<head>
    <title>发帖</title>
</head>
<body>
    <form action="Post.jsp" method="post">
        <input type="hidden" name="action" value="post">
        <table border="1">
            <tr>
                <th>标题：</th>
                <td>
                    <input type="text" name="title" size="80"/>
                </td>
            </tr>
            <tr>
                <th>内容：</th>
                <td>
                    <textarea name="cont" rows="12" cols="80"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="提交">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
