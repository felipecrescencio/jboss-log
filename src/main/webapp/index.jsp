<%@page import="java.util.Arrays"%>
<%@page import="java.io.FilenameFilter"%>
<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.io.RandomAccessFile"%>

<html>
	<title>JBoss Log Viewer</title>
	<head>
		<style type="text/css">
			* {
				background-color: #000;
				color: #FFF;
				font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
			}

			.negrito {
				font-weight: bold;
			}

			.bt-download , .bt-tail {
				cursor:pointer;
				font-weight: bold;
			}

			table {
				border: 1px solid #fff;
				border-collapse: collapse;
			}
		</style>
	</head>

	<body>
		<h3>JBoss Log Viewer</h3>

		<form id="formDownload" action="<%= request.getRequestURL() %>download" method="post">
			<input type="hidden" id="logFile" name="logFile" value="<%= System.getProperty("org.jboss.boot.log.file") %>"></input>
		</form>

		<form id="formTail" action="<%= request.getRequestURL() %>tail/1000" method="post">
			<input type="hidden" id="logFile" name="logFile" value="<%= System.getProperty("org.jboss.boot.log.file") %>"></input>
		</form>

		<p class="negrito">Usage:</p>
		<ul>
			<li>
				<span class="bt-download" fileName="<%= System.getProperty("org.jboss.boot.log.file") %>">Download JBoss Log</span>
			</li>
			<li>
				<div>Show last ? log lines</div>
				<div>i.e. show last 1000 lines: <span class="bt-tail" fileName="<%= System.getProperty("org.jboss.boot.log.file") %>"><%= request.getRequestURL() %>tail/1000</span></div>
				<p class="negrito">10K LINES MAX!!!</p>
			</li>
		</ul>

		<p class="negrito">Other logs in log folder:</p>
		<table border="1" cellpadding="5">
		<%
			String s4 = System.getProperty("org.jboss.boot.log.file");

			File f3 = new File(s4);

			File parentDir = new File(f3.getParent());

			// create new filename filter
			FilenameFilter logFilter = new FilenameFilter() {
				public boolean accept(File dir, String name) {
					return (name.indexOf("server.log") >= 0);
				}
			};

			File[] paths = parentDir.listFiles(logFilter);

			Arrays.sort(paths);

			for(int count=(paths.length -1); count >= 0; count--) {
				File path = paths[count];
			%>
				<tr>
					<td><span title="tail" class="bt-tail" fileName="<%= path.getPath() %>"><%= path.getName() %></span></td><td><span class="bt-download" fileName="<%= path.getPath() %>">download</span></td>
				</tr>
			<%
			}
		%>
		</table>

		<script type="text/javascript" src="/log/js/jquery-1.11.1.min.js" charset="utf-8"></script>

		<script type="text/javascript" >
			$( document ).ready(function() {
				$(" .bt-download ").click(function(){
					var fileName = $(this).attr("fileName");

					$("form#formDownload input#logFile").val(fileName);
					$("form#formDownload").submit();
				});

				$(" .bt-tail ").click(function(){
					var fileName = $(this).attr("fileName");

					$("form#formTail input#logFile").val(fileName);
					$("form#formTail").submit();
				});
			});
		</script>
	</body>
</html>
