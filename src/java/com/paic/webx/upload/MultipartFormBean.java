package com.paic.webx.upload;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.fileupload.FileItem;

public class MultipartFormBean {

	private List itemList = new ArrayList();

	private Map fields;

	public Map getFields() {
		return fields;
	}

	public void setFields(Map fields) {
		this.fields = fields;
	}

	public String getFieldValue(String fieldName) {
		if (fields == null || fieldName == null)
			return null;
		return (String) fields.get(fieldName);
	}

	public Object[] getFeildValues(String fieldName) {
		if (fields == null || fieldName == null)
			return null;
		List list = new ArrayList();
		Iterator it = fields.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry entry = (Map.Entry) it.next();
			String key = (String) entry.getKey();
			String v = (String) entry.getValue();
			if (key.equals(fieldName)) {
				list.add(v);
			}
		}
		return list.toArray();
	}

	public int getFieldIntValue(String fieldName) {
		String v = getFieldValue(fieldName);
		return v == null ? -1 : Integer.parseInt(v);
	}

	public FileItem getItem(String fieldName) {
		Iterator it = itemList.iterator();
		while (it.hasNext()) {
			FileItem item = (FileItem) it.next();
			if (item.getFieldName().equals(fieldName))
				return item;
		}
		return null;
	}

	public FormFileBean toBean(FileItem item) {
		if (item == null || item.get() == null)
			return null;

		FormFileBean resultBean = new FormFileBean();
		String fileNameLong = item.getName();
		fileNameLong = fileNameLong.replace('\\', '/');
		String[] pathParts = fileNameLong.split("/");
		String tfileName = pathParts[pathParts.length - 1];

		resultBean.setContentType(item.getContentType());
		resultBean.setBinary(item.get());
		resultBean.setFileName(tfileName);
		resultBean.setFilePath(fileNameLong);
		return resultBean;
	}

	public FormFileBean getOne(String fieldName) {
		return toBean(getItem(fieldName));
	}

	public FormFileBean getOne(int index) {
		if (itemList.size() <= index)
			return null;

		FileItem item = (FileItem) itemList.get(index);
		return toBean(item);
	}

	public String getFileName(FileItem item) {
		if (item != null) {
			String fileNameLong = item.getName();
			fileNameLong = fileNameLong.replace('\\', '/');
			String[] pathParts = fileNameLong.split("/");
			String tfileName = pathParts[pathParts.length - 1];

			return tfileName;
		}
		return null;
	}

	public void addFileItem(FileItem item) {
		this.itemList.add(item);
	}

	public List getItemList() {
		return itemList;
	}

}
