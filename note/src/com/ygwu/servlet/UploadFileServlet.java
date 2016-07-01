package com.ygwu.servlet;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

@WebServlet("/UploadFileServlet.do")
public class UploadFileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private long sizeMax = 10 * 1024 * 1024;

	private int sizeThreshold = 512 * 1024;

	private String path;

	private String temppath = "c:\\temp";
	

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UploadFileServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public void init() throws ServletException {
		// 1,配置的xml里面的文件上传的路径取出来
		ServletContext servletContext = getServletContext();
		path = servletContext.getInitParameter("uploadfilepath");

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		boolean res = processUpload(request, response);
		
		if(res){
			//获取表单text控件的值
			String account = request.getAttribute("username").toString();
			System.out.println(account);
			
			//获取文件上传的原始名称
			String fileName = request.getAttribute("randomName").toString();
			System.out.println(fileName);
//			
//			//获取文件上传后，服务器上保存的名字
//			String fileNameServer = request.getAttribute("upfileServer").toString();
//			System.out.println(fileNameServer);
//			request.setAttribute("upfile", fileNameServer);
			
			request.setAttribute("message", "上传成功");
		}
		request.getRequestDispatcher("/upload.jsp").forward(request, response);
	}

	private boolean processUpload(HttpServletRequest request, HttpServletResponse response)
			throws IOException, FileNotFoundException {
		String msg=null;
		boolean res = true;
		// 检查我们有一个文件上传请求
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		response.setContentType("text/html");
		java.io.PrintWriter out = response.getWriter();
		if (!isMultipart) {
			out.println("<html>");
			out.println("<head>");
			out.println("<title>Servlet upload</title>");
			out.println("</head>");
			out.println("<body>");
			out.println("<p>No file uploaded</p>");
			out.println("</body>");
			out.println("</html>");
			return false;
		}
		DiskFileItemFactory factory = new DiskFileItemFactory();

		// 文件大小的最大值将被存储在内存中
		factory.setSizeThreshold(sizeThreshold);
		
		// Location to save data that is larger than maxMemSize.
		File tempdir = new File(temppath);
		if (!tempdir.exists()) {
			tempdir.mkdir();
		}
		factory.setRepository(tempdir);

		// 创建一个新的文件上传处理程序
		ServletFileUpload upload = new ServletFileUpload(factory);

		// 允许上传的文件大小的最大值
		upload.setSizeMax(sizeMax);

		try {
			List<FileItem> items = upload.parseRequest(request);

			Iterator<FileItem> iterator = items.iterator();
			while (iterator.hasNext()) {
				FileItem fileItem = iterator.next();
				boolean formField = fileItem.isFormField();
				
				if(!formField){
					String name = fileItem.getName();
					
					
					// 生成一个随机的文件的名字
					String randomName = System.currentTimeMillis()+name;
					
					OutputStream fos = new FileOutputStream(path + "\\" + randomName);// D:\files\fileupload
					
					request.setAttribute("randomName", randomName);
					
					InputStream is = fileItem.getInputStream();
					
					byte[] bys = new byte[1024];
					int len = 0;
					while ((len = is.read(bys)) != -1) {
						fos.write(bys, 0, len);
						fos.flush();
					}
					fos.close();
				}else{
					String fieldName = fileItem.getFieldName();
					String value = fileItem.getString();
					System.out.println(value);
					request.setAttribute(fieldName, value);
				}
			}

		} catch (FileUploadException e) {
			msg = "文件的内容过大，请上传小于20MB的文件" ;
			e.printStackTrace();
			res = false;
		}
		request.setAttribute("msg", msg);
		return res;
	}

}
