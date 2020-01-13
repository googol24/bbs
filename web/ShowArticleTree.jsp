<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page errorPage="Error.jsp" %>

<%!
    // 声明区块（声明成员变量只能写在这种区块），否则会被写到Servlet的service()方法作为局部变量了
    String str = "";

    boolean bLogin = false;// 声明为成员变量

    // 声明区块（声明方法只能写在这种区块），否则会被写到Servlet的service()方法里面，报错
    private void tree(Connection connection, int id, int level) {
        // 缩进前导字符串
        String preStr = "";
        for (int i = 0; i < level; i++) {
            preStr += "----";
        }
        // 方法体里面声明Statement和ResultSet
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            statement = connection.createStatement();
            String sql = "SELECT * FROM article WHERE pid=" + id;
            resultSet = statement.executeQuery(sql);
            while (resultSet.next()) {
                String strLogin = "";
                if (bLogin) {
                    strLogin = "<td><a href='Delete.jsp?id=" + resultSet.getInt("id") + "&pid=" + resultSet.getInt("pid") + "'>删除</a></td>";
                }
                str += "<tr><td>" + resultSet.getInt("id") + "</td><td>" +
                        preStr +
                        "<a href='ShowArticleDetail.jsp?id=" + resultSet.getInt("id") + "'>" + resultSet.getString("title") +
                        "</a></td>" +
                        strLogin +
                        "</tr>";
                if (resultSet.getInt("isleaf") != 0) {
                    tree(connection, resultSet.getInt("id"), level + 1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (statement != null) {
                    statement.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<%
    // 代码片段区块（相当于service()）

    // 连接MySQL
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    // 初始化
    // 根据jsp的生命周期，HttpServlet对象只有一个，所以成员变量每次刷新使用之前需要清空一下，不然会堆积叠加
    str = "";
    bLogin = false;

    // 管理员权限判断
    String admin = (String) session.getAttribute("admin");

    if (admin != null && admin.equals("true")) {
        bLogin = true;
    }

    // 操作权限局部变量
    String strLogin = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1/bbs", "root", "root");
        stmt = conn.createStatement();

        // 只查询主题帖，回复帖通过递归查询
        rs = stmt.executeQuery("SELECT * FROM article WHERE pid = 0");
        while (rs.next()) {
            if (bLogin) {
                strLogin = "<td><a href='Delete.jsp?id=" + rs.getInt("id") + "&pid=" + rs.getInt("pid") + "'>删除</a></td>";
            }

            // str:相当于成员变量
            str += "<tr><td>" + rs.getInt("id") +
                    "</td><td><a href='ShowArticleDetail.jsp?id=" + rs.getInt("id") + "'>" +
                    rs.getString("title") +
                    "</a></td>" +
                    strLogin +
                    "</tr>";
            if (rs.getInt("isleaf") != 0) {
                tree(conn, rs.getInt("id"), 1);
            }
        }
    } catch (ClassNotFoundException e) {
        // JSP自己处理可以默认处理所有的Java Exception
        // 异常输出到后台Console
        System.out.println("未找到驱动类");
        e.printStackTrace();
    } catch (SQLException e) {
        System.out.println("SQL异常：" + e.getMessage());
        e.printStackTrace();
    } finally {
        // 关闭连接
        if (rs != null) {
            rs.close();
        }
        if (stmt != null) {
            stmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
<html>
<head>
    <title>Show Article Tree</title>
    <meta charset="UTF-8">
</head>
<body>
<a href="Post.jsp">发帖</a>
<table border="1">
    <tr>
        <th>ID</th>
        <th>Title</th>
        <% if (bLogin) { %>
        <th>操作</th>
        <% } %>
    </tr>
    <%= str %>
</table>
</body>
</html>
