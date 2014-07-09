<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.zip.ZipOutputStream"%>
<%@page import="java.util.zip.ZipEntry"%>

<%!
	void addFile( ZipOutputStream outZip, File f, String name ) {
		FileInputStream in = null ;
		try
		{
		// Add ZIP entry to output stream.
		outZip.putNextEntry( new ZipEntry( name ) ) ;
		
		in = new FileInputStream( f ) ;
		
		// Transfer bytes from the file to the ZIP file
		byte[] buf = new byte[ 4096 ] ;
		int len ;
		while( ( len = in.read( buf ) ) > 0 )
		{
		outZip.write( buf, 0, len ) ;
		}
		}
		catch( IOException ex ) { ex.printStackTrace(); }
		finally
		{
		// Complete the entry
		try{ outZip.closeEntry() ; } catch( IOException ex ) { }
		try{ in.close() ; } catch( IOException ex ) { }
		}
	}
%>

<%
	String logFile = request.getParameter("logFile");

	if (logFile == null || logFile.equals("")) {
		%>
			The log file name must be received.
		<%
	} else if (logFile.indexOf("server.log") < 0 ) {
		%>
			SHAME ON YOU!!! You can watch only log files!
		<%
	} else {
		ServletOutputStream outStream = null;

		try {
			Date today = new Date();

			// formatting Date with time information
			SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMddHHmmSS");

			// set the content type and the filename
			response.setContentType( "application/zip" ) ;
			response.addHeader( "Content-Disposition", "attachment; filename=server"+ DATE_FORMAT.format(today) +".zip" ) ;

			// get a ZipOutputStream, so we can zip our files together
			ZipOutputStream outZip = new ZipOutputStream( response.getOutputStream() );

			// add some files to the zip...
			addFile( outZip, new File(logFile), "server"+ DATE_FORMAT.format(today) +".log" ) ;

			// flush the stream, and close it
			outZip.flush() ;
			outZip.close() ;
		}
		catch(Exception e)
		{
			out.print(e.getMessage());
		}
	}
%>
