<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="Error.jsp" %>
<%
    // 获取请求参数
    int id = Integer.parseInt(request.getParameter("id"));
    int rootId = Integer.parseInt(request.getParameter("rootid"));
%>
<html>
<head>
    <title>发表回复</title>
    <script type="text/javascript">
        // 前端参数检查
        function check() {
            if (document.getElementById("title").value == "") {
                alert("标题不能为空！");
                document.title.focus();
                return false;
            } else if (document.getElementById("cont").value == "") {
                alert("内容不能为空！");
                document.cont.focus();
                return false;
            } else {
                return true;
            }
        }
    </script>
</head>
<body>
    <form action="ReplyOK.jsp" name="form" method="post" onsubmit="return check()">
        <input type="hidden" name="id" value="<%= id %>"/>
        <input type="hidden" name="rootid" value="<%= rootId %>">
        <table border="1">
            <tr>
                <th>标题：</th>
                <td>
                    <input type="text" id="title" name="title" size="80"/>
                </td>
            </tr>
            <tr>
                <th>内容：</th>
                <td>
                    <textarea id="cont" name="cont" rows="12" cols="80"></textarea>
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
