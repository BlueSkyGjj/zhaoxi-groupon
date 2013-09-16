package com.paic.webx.upload;

import java.io.File;
import java.io.IOException;
import java.io.Serializable;

import org.apache.commons.io.FileUtils;

public class FormFileBean implements Serializable {

	private static final long serialVersionUID = 1L;

	private String fileName;

	private String contentType;

	private String filePath;

	private byte[] binary;

	public byte[] getBinary() {
		return binary;
	}

	public void setBinary(byte[] binary) {
		this.binary = binary;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getFileName() {
		return fileName;
	}

	public String getFileExt() {
		return fileName == null ? null : fileName.substring(fileName
				.lastIndexOf(".") + 1);
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public void saveToFile(File file) {
		try {
			FileUtils.writeByteArrayToFile(file, this.binary);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
