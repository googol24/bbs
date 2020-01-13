<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="Error.jsp" %>
<%
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1/bbs", "root", "root");
    Statement stmt = conn.createStatement();

    // 查询总数
    ResultSet rsTotal = stmt.executeQuery("SELECT COUNT(*) FROM article WHERE pid = 0");
    rsTotal.next();
    int totalCount = rsTotal.getInt(1);


    // 分页控制
    int pageSize = 3;
    int pageNo = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        // 页码合法性校验
//        try {
//            pageNo = Integer.parseInt(pageParam.trim());
//        } catch (NumberFormatException e) {
//            pageNo = 1;
//        }
        if (pageParam.matches("[0-9]+") && Integer.parseInt(pageParam.trim()) > 0) {
            pageNo = Integer.parseInt(pageParam.trim());
        }
    }

    // 总的页码数
    // 使用Math.ceil注意是先计算里面的，需要把里面的操作数分别转为浮点数再计算
    int totalPage = (int)Math.ceil((double) totalCount / (double) pageSize);
//    int totalPage = totalCount % pageSize == 0 ? totalCount / pageSize : totalCount / pageSize + 1;

    // 页码修正
    if (pageNo > totalPage) {
        pageNo = totalPage;
    }

    int startPos = (pageNo - 1) * pageSize;

    // 只查询主题帖
    ResultSet rs = stmt.executeQuery("SELECT * FROM article WHERE pid = 0 ORDER BY pdate DESC LIMIT " + startPos + "," + pageSize);
%>
<html>
<head>
    <title>主题帖子页</title>
    <script type="text/javascript">
        function changePage() {
            document.pageSelect.submit();
        }
    </script>
</head>
<body>
<a href="Post.jsp">发表新的主题</a>
<table border="2">
    <tr>
        <th>ID</th>
        <th>Title</th>
    </tr>
    <% while (rs.next()) { %>
    <tr>
        <td>
            <%= rs.getInt("id") %>
        </td>
        <td>
            <%= rs.getString("title") %>
        </td>
    </tr>
    <% } %>
</table>
<!--分页模块-->
<p>
    第<%= pageNo %>页
    &nbsp;&nbsp;
    <a href="ShowArticleFlat.jsp?page=<%= pageNo - 1%>"> < </a>
    &nbsp;&nbsp;
    <a href="ShowArticleFlat.jsp?page=<%= pageNo + 1%>"> > </a>
    &nbsp;&nbsp;
    共<%= totalPage %>页
</p>
<!--分页下拉条-->
<form name="pageSelect" action="ShowArticleFlat.jsp">
    <select name="page" onchange="changePage()">
        <% for (int i = 1; i <= totalPage; i++) {%>
        <option value="<%= i %>" <%= (pageNo == i) ? "selected" : "" %> >
            第 <%= i %> 页
        </option>
        <% } %>
    </select>
</form>

<!--分页输入框-->
<form name="pageInput" action="ShowArticleFlat.jsp">
    跳转到第 <input type="number" style="width: 5%" name="page"> 页
    <input type="submit" value="跳转">
</form>
</body>
<%
    rs.close();
    stmt.close();
    conn.close();
%>
</html>
