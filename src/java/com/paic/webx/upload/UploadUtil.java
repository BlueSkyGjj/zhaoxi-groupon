package com.paic.webx.upload;

import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class UploadUtil {

	private List allowedExtensions;

	private List deniedExtensions;

	private String encoding;

	private int maxSize = 1024 * 1024;

	public String getEncoding() {
		return encoding;
	}

	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}

	public int getMaxSize() {
		return maxSize;
	}

	public void setMaxSize(int maxSize) {
		this.maxSize = maxSize;
	}

	public List getAllowedExtensions() {
		return allowedExtensions;
	}

	public void setAllowedExtensions(String allowedExtensions) {
		this.allowedExtensions = stringToArrayList(allowedExtensions);
	}

	public List getDeniedExtensions() {
		return deniedExtensions;
	}

	public void setDeniedExtensions(String deniedExtensions) {
		this.deniedExtensions = stringToArrayList(deniedExtensions);
	}

	public MultipartFormBean getFileFromRequest(HttpServletRequest request)
			throws FileUploadException {
		try {
			if (encoding != null)
				request.setCharacterEncoding(encoding);
		} catch (UnsupportedEncodingException e1) {
			throw new FileUploadException("Upload file encoding not supported!");
		}

		MultipartFormBean resultBean = new MultipartFormBean();

		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setHeaderEncoding(encoding);
		upload.setFileSizeMax(maxSize);
		List items = upload.parseRequest(request);

		Map fields = new HashMap();
		try {
			Iterator iter = items.iterator();
			while (iter.hasNext()) {
				FileItem item = (FileItem) iter.next();
				if (item.isFormField()) {
					// parameter values check
					String fn = item.getFieldName();
					if (fn.startsWith("l_")) {
						if (fields.keySet().contains(fn)) {
							String[] arr = (String[]) fields.get(fn);
							String[] newArr = new String[arr.length + 1];
							for (int i = 0; i < arr.length; i++)
								newArr[i] = arr[i];
							newArr[arr.length] = item.getString();
							fields.put(fn, newArr);
						} else {
							fields.put(fn,
									new String[] { item.getString(encoding) });
						}
					} else {
						fields.put(fn, item.getString(encoding));
					}
				} else {
					String ext = getFileExt(item.getName());
					if (ext == null) {
						fields.put(item.getFieldName(), null);
						continue;
					}
					if (!extIsAllowed(ext)) {
						throw new FileUploadException("Upload file format '"
								+ ext + "' is not accepted!");
					}
					resultBean.addFileItem(item);
					fields.put(item.getFieldName(), null);
				}

			}

			resultBean.setFields(fields);
		} catch (UnsupportedEncodingException e) {
			throw new FileUploadException("Upload file encoding not supported!");
		}

		return resultBean;
	}

	private String getFileExt(String fileName) {
		if (fileName == null || fileName.trim().equals(""))
			return null;
		else
			return fileName.substring(fileName.lastIndexOf(".") + 1);
	}

	public void downloadFile(FormFileBean bean, HttpServletResponse response) {
		try {
			if (bean == null)
				return;

			// if (encoding != null)
			// response.setCharacterEncoding(encoding);
			// else
			// encoding = response.getCharacterEncoding();

			String fn = java.net.URLEncoder.encode(bean.getFileName(), "UTF-8");
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition", "attachment;"
					+ "filename=\"" + fn + "\"");

			OutputStream os = response.getOutputStream();
			os.write(bean.getBinary());
			os.flush();
			os.close();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Helper function to convert the configuration string to an ArrayList.
	 */
	private List stringToArrayList(String str) {
		if (str == null)
			str = "";

		String[] strArr = str.split("\\|");
		List tmp = new ArrayList();
		if (str.length() > 0) {
			for (int i = 0; i < strArr.length; ++i) {
				// System.out.println(i + " - " + strArr[i]);
				tmp.add(strArr[i].toLowerCase());
			}
		}
		return tmp;
	}

	/**
	 * Helper function to verify if a file extension is allowed or not allowed.
	 */
	public boolean extIsAllowed(String ext) {
		ext = ext.toLowerCase();
		if (allowedExtensions == null || deniedExtensions == null)
			return true;
		if (allowedExtensions.contains(ext)) {
			if (!deniedExtensions.contains(ext))
				return true;
		}
		return false;
	}
}
