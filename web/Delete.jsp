<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ page errorPage="Error.jsp" %>--%>
<%!
    // 删除也是递归执行的，定义一个方法
    // 首先递归删除孩子节点，再删除自身
    private void delete(Connection connection, int id) {
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT * FROM ARTICLE WHERE pid=" + id);
            while (resultSet.next()) {
                // 首先递归删除所有的孩子节点的帖子
                delete(connection, resultSet.getInt("id"));
            }
            // 再删除本帖自身
            statement.executeUpdate("DELETE FROM ARTICLE WHERE id=" + id);

            // 删除完之后需要判断被删除节点的父节点是否还有孩子节点，如果没有的话需要把被删除节点的父节点设置为叶子节点
            // 这个处理只有一次判断，放在递归内部不太适合，会造成很多没必要的处理操作(对子节点的处理)

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (statement != null) {
                    statement.close();
                }
                if (resultSet != null) {
                    resultSet.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<%
    // 请求传参
    int id = Integer.parseInt(request.getParameter("id"));
    int pid = Integer.parseInt(request.getParameter("pid"));

    // 连接MySQL
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    // 权限判断
    String admin = (String) session.getAttribute("admin");
    if (admin == null || !admin.equals("true")) {
        out.print("<font color = 'red' size = '5'>不具备删除权限！</font>");
        return;
    }

    // 删除帖子（事务内处理）
    // 注意：MyISAM 存储引擎不支持事务
    try {
        Class.forName("com.mysql.jdbc.Driver");

        connection = DriverManager.getConnection("jdbc:mysql://127.0.0.1/bbs", "root", "root");
        statement = connection.createStatement();

        connection.setAutoCommit(false);
        delete(connection, id);

        // 删除完之后需要判断被删除节点的父节点是否还有孩子节点，如果没有的话需要把被删除节点的父节点设置为叶子节点
        resultSet = statement.executeQuery("SELECT * FROM article WHERE pid=" + pid);
        if (!resultSet.next()) {
            // 如果被删除节点的父节点没有其他孩子节点了
            System.out.println("被删除节点的父节点没有其他孩子节点了");
            statement.executeUpdate("UPDATE article SET isleaf=0 WHERE id=" + pid);
        }

        // 提交事务
        connection.commit();

        // 删除执行完成后恢复现场
        connection.setAutoCommit(true);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        try {
            if (connection != null) {
                connection.rollback();
                connection.setAutoCommit(true);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        e.printStackTrace();

    } finally {
        // 关闭资源
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // 操作成功之后重定向首页
    response.sendRedirect("index.jsp");
%>
