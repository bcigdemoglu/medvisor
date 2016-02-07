<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%-- //[START imports]--%>
<%@ page import="com.example.medvisor.UserComplaint" %>
<%@ page import="com.example.medvisor.UserInfo" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
    <title>Welome home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
        <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

    <!-- jQuery UI CSS -->
    <link href="//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" type="text/css" rel="stylesheet">
    <!-- Bootstrap styling for Typeahead -->
    <link href="dist/css/tokenfield-typeahead.css" type="text/css" rel="stylesheet">
    <!-- Tokenfield CSS -->
    <link href="dist/css/bootstrap-tokenfield.css" type="text/css" rel="stylesheet">
    <link href="docs-assets/css/pygments-manni.css" type="text/css" rel="stylesheet">
    <link href="docs-assets/css/docs.css" type="text/css" rel="stylesheet">
</head>

<body>
    <p><strong>Using jQuery UI Autocomplete</strong></p>

              <div class="bs-example">
                <div class="form-group">
                  <input type="text" class="form-control" id="tokenfield-1" value="red,green,blue" placeholder="Type something and hit enter" />
                </div>
              </div>


<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
        pageContext.setAttribute("user", user);
    
%>

<p>Welcome, ${fn:escapeXml(user.nickname)}! (You can
    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

    <form action="/sign" method="post">
        <div><textarea name="content" rows="3" cols="60" placeholder="What's the matter?">
<%
        String content = request.getParameter("content");
        if (content != null) {
            pageContext.setAttribute("post_content", content);

%>${fn:escapeXml(post_content)}<%}%>

</textarea></div>
        <div><input type="submit" value="Post complaint"/></div>
    </form>

<%-- //[START datastore]--%>
<%
        // Create the correct Ancestor key
        Key<UserInfo> userEmail = Key.create(UserInfo.class, user.getEmail());

        // Run an ancestor query to ensure we see the most up-to-date
        // view of the Greetings belonging to the selected Guestbook.
        List<UserComplaint> userComplaints = ObjectifyService.ofy()
              .load()
              .type(UserComplaint.class) // We want only complaints
              .ancestor(userEmail)  // Anyone with this email
              .order("-date")       // Most recent first - date is indexed.
              .list();

        if (userComplaints.isEmpty()) {
%>
<p>${fn:escapeXml(user.nickname)}, you have no complaints.</p>
<%
        } else {
%>
<p>Your complaints are:</p>
<%
            // Look at all of our greetings
            for (UserComplaint userComplaint : userComplaints) {
                pageContext.setAttribute("complaint_ID", userComplaint.id.toString());
                pageContext.setAttribute("userComplaint_content", userComplaint.content);
%>
<p></p>
<blockquote>${fn:escapeXml(userComplaint_content)} ${fn:escapeXml(userComplaint.id)}</blockquote>
<form action="/editComplaint" method="post">
        <div><button type="submit"> Edit </button></div>
        <input type="hidden" name="id" value="${fn:escapeXml(complaint_ID)}"/>
        <input type="hidden" name="operation" value="edit"/> 
    </form>
    <form action="/editComplaint" method="post">
        <div><button type="submit"> Delete </button></div>
        <input type="hidden" name="id" value="${fn:escapeXml(complaint_ID)}"/>
        <input type="hidden" name="operation" value="delete"/> 
    </form>
<%
            }
        }
%>
<%-- //[END datastore]--%>
<% 
    } else {
%>
<p>Please
    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
    to use our service.</p>
<%
    }
%>

</body>

<script type="text/javascript" src="//code.jquery.com/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="//code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type="text/javascript" src="dist/bootstrap-tokenfield.js" charset="UTF-8"></script>
    <script type="text/javascript" src="docs-assets/js/scrollspy.js" charset="UTF-8"></script>
    <script type="text/javascript" src="docs-assets/js/affix.js" charset="UTF-8"></script>
    <script type="text/javascript" src="docs-assets/js/typeahead.bundle.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="docs-assets/js/docs.min.js" charset="UTF-8"></script>

    <script type="text/javascript">
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-22737379-5', 'sliptree.github.io');
      ga('send', 'pageview');
</script>

</html>
<%-- //[END all]--%>