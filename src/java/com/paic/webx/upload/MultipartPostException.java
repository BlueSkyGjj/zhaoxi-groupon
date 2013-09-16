package com.paic.webx.upload;

public class MultipartPostException extends Exception {

	private static final long serialVersionUID = 1L;

	public MultipartPostException(String msg) {
		super("Multipart Post Handled Failed Due to " + msg);
	}
}
