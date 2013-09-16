package org.dy.thirdpart.sae;

import com.sina.sae.storage.SaeStorage;

public class FileStorageAdaptor {
	public static String write(String fileName, byte[] content) {
		String domain = SaeConf.getDomain();
		SaeStorage storage = new SaeStorage();

		storage.write(domain, fileName, content);
		return storage.getUrl(domain, fileName);
	}

	public static boolean delete(String fileName) {
		String domain = SaeConf.getDomain();
		SaeStorage storage = new SaeStorage();

		return storage.delete(domain, fileName);
	}
}
