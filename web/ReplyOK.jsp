<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="Error.jsp" %>
<%
    // 回帖处理

    // 设定中文的字符集
    // 在使用之前设定编码
    // 设置对客户端请求和数据库取值时的编码，不指定的话request对象提交的数据默认使用的编码为iso-8859-1
    request.setCharacterEncoding("UTF-8");

    // 首先获取请求参数
    int id = Integer.parseInt(request.getParameter("id"));
    int rootId = Integer.parseInt(request.getParameter("rootid"));
    String title = request.getParameter("title");

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

    String content = request.getParameter("cont");

    // 参数检查
    if (content == null) {
        out.println("内容不合法！");
        return;
    }
    content = content.trim();

    if (content.equals("")) {
        out.print("内容不能为空！");
        return;
    }

    // 回复内容里面的换行替换成HTML里面的换行
    content = content.replaceAll("\n", "<br/>");

    // 然后生成回帖信息（注意事务处理）
    Class.forName("com.mysql.jdbc.Driver");
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost/bbs", "root", "root");
    Statement statement = connection.createStatement();
    String insertSql = "INSERT INTO article(`pid`,`rootid`,`title`,`cont`,`pdate`,`isleaf`) VALUES (?, ?, ?, ?, NOW(), 0)";
    String updateSql = "UPDATE article SET isleaf=1 WHERE id=" + id;// 被回复的帖子一定不再是叶节点
    PreparedStatement preparedStatement = connection.prepareStatement(insertSql);

    // 事务处理
    connection.setAutoCommit(false);

    // 插入回复帖
    preparedStatement.setInt(1, id);
    preparedStatement.setInt(2, rootId);
    preparedStatement.setString(3, title);
    preparedStatement.setString(4, content);
    preparedStatement.executeUpdate();

    // 更新原贴
    statement.executeUpdate(updateSql);

    // 事务提交
    connection.commit();
    connection.setAutoCommit(true);// 恢复现场

    // 关闭资源对象
    preparedStatement.close();
    statement.close();
    connection.close();
%>
<html>
<head>
    <title>Reply OK</title>
</head>
<body>
    <h2>这是 Reply OK 页面</h2>
    <%
        // 跳转到BBS首页
        response.sendRedirect("/bbs/");
//        response.sendRedirect("index.jsp");
    %>
</body>
</html>
