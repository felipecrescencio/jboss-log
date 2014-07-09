<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.io.RandomAccessFile"%>

<html>
	<head>
		<style type="text/css">
			* {
				background-color: #000000;
				color: #FFFFFF;
				font-family: "Courier New", Courier, "Lucida Sans Typewriter", "Lucida Typewriter", monospace;
			}

			.negrito {
				font-weight: bold;
			}
		</style>
		<title>JBoss Log Viewer</title>
	</head>

	<body>

<%
	String logFile = request.getParameter("logFile");

	if (logFile == null || logFile.equals("") ) {
		%>
			The log file name must be received.
		<%
	} else if (logFile.indexOf("server.log") < 0 ) {
		%>
			SHAME ON YOU!!! You can watch only log files!
		<%
	} else {
		String pLines = request.getRequestURI();
	
		if(pLines == null || pLines.trim().equals("") ) {
			pLines = "1000";
		} else {
			pLines = pLines.substring(pLines.lastIndexOf("/") +1);
		}
	
		int linesToRead = 1000;
		
		if(pLines.matches("^[0-9]+$")) {
			linesToRead = Integer.parseInt(pLines);
		}
	
		if(linesToRead < 1 || linesToRead > 10000) {
	%>
		<h3 style="color: red;">PAR&Acirc;METRO N&Uacute;MERO DE LINHAS INV&Aacute;LIDO!!!</h3>
		<h3 >TENTE UM N&Uacute;MERO ENTRE 1 E 10000.</h3>
	<%
		} else {
	%>
	
		<h3>JBoss Log Viewer - Last <%= linesToRead %> lines</h3>
		<%
			RandomAccessFile raf = new RandomAccessFile(logFile, "r");
			List<String> lines = new ArrayList<String>();
	
			final int chunkSize = 1024 * 32;
			long end = raf.length();
			boolean readMore = true;
	
			while (readMore) {
				byte[] buf = new byte[chunkSize];
				
				// Read a chunk from the end of the file
				long startPoint = end - chunkSize;
				long readLen = chunkSize;
				if (startPoint < 0) {
					readLen = chunkSize + startPoint;
					startPoint = 0;
				}
				raf.seek(startPoint);
				readLen = raf.read(buf, 0, (int)readLen);
				if (readLen <= 0) {
					break;
				}
			
				// Parse newlines and add them to an array
				int unparsedSize = (int)readLen;
				int index = unparsedSize - 1;
				while (index >= 0) {
					if (buf[index] == '\n') {
						int startOfLine = index + 1;
						int len = (unparsedSize - startOfLine);
						if (len > 0) {
							lines.add(new String(buf, startOfLine, len));
						}
						unparsedSize = index + 1;
					}
					--index;
				}
			
				// Move end point back by the number of lines we parsed
				// Note: We have not parsed the first line in the chunked
				// content because could be a partial line
				end = end - (chunkSize - unparsedSize);
			
				
			
				readMore = lines.size() < linesToRead && startPoint != 0;
			}
		
			// Only print the requested number of lines
			if (linesToRead > lines.size()) {
				linesToRead = lines.size();
			}
		
			for (int i = linesToRead - 1; i >= 0; --i) {
				out.print(lines.get(i));
				out.print("<br />");
			}
		}
	}
	%>

	</body>
</html>
