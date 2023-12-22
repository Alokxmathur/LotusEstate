<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.io.*, java.util.*"%>
<%@page
  import="com.axiomtank.objectdb.*, 
  java.util.*,org.apache.commons.lang3.*,
  com.axiomtank.common.objects.Role,
  com.axiomtank.util.Session,
  com.axiomtank.pool.controller.*"%>
<%
  String __rolesNeeded[] = {"Admin", "SuperAdmin"};
  String _title = Session.getAppName() + " Guest";
  %>
 <%@include file="common/commonWithJSandCSS.inc"%>
 <%
  String mode = (String) session.getAttribute("mode");
  if ("host".equals(mode)) {
	  response.sendRedirect("host.jsp");
  }
 %>
 <div class="container">
 	<div class="row">
 		<div id="statusDiv" class="col-md-6"></div>
	</div>
	<div class="row">&nbsp;</div>
	<div class="row">
		<div class="col-md-6">
			Guests of the Luxury Suite or the Tranquil Guesthouse may request the hosts to manage the hot tub by messaging them on the AirBnB App.
		</div>
		<div class="text-right"><a href="switchMode.jsp"><input type="button" value="Host Mode" class="button btn-link"></a></div>
	</div>
	<div class="row">
		<div class="col-md-6">
			<div class="airbnb-embed-frame" data-id="993738729734757995" data-view="home" style="width: 450px; height: 300px; margin: auto;"><a href="https://www.airbnb.com/rooms/993738729734757995?guests=1&amp;adults=1&amp;s=66&amp;source=embed_widget">View On Airbnb</a><a href="https://www.airbnb.com/rooms/993738729734757995?guests=1&amp;adults=1&amp;s=66&amp;source=embed_widget" rel="nofollow">Guest suite in Alpharetta · ★4.67 · 1 bedroom · 1 bed · 1 bath</a><script async="" src="https://www.airbnb.com/embeddable/airbnb_jssdk"></script></div> 
		</div>	
	</div>
	<div class="row">
		<div class="col-md-6">
			<div class="airbnb-embed-frame" data-id="995855210732487477" data-view="home" style="width: 450px; height: 300px; margin: auto;"><a href="https://www.airbnb.com/rooms/995855210732487477?guests=1&amp;adults=1&amp;s=66&amp;source=embed_widget">View On Airbnb</a><a href="https://www.airbnb.com/rooms/995855210732487477?guests=1&amp;adults=1&amp;s=66&amp;source=embed_widget" rel="nofollow">Guesthouse in Alpharetta · ★5.0 · 1 bedroom · 2 beds · 1 bath</a><script async="" src="https://www.airbnb.com/embeddable/airbnb_jssdk"></script></div>
		</div>
	</div>
</div>

<script>
$(document).ready(function(){
    $.ajax({
        url: 'getStatus.jsp', // URL of the server-side script
        success: function(data) {
            $('#statusDiv').html(data); // Update the content of the DIV element
        }
    });
    setInterval(function(){
        $.ajax({
            url: 'getStatus.jsp', // URL of the server-side script
            success: function(data) {
                $('#statusDiv').html(data); // Update the content of the DIV element
            }
        });
    }, 1000); // Refresh the content every .5 seconds
});
</script>
