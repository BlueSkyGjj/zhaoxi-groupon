package com.paic.webx.tool;

public class Pagination {
	public int cp = 1;
	public int npp = 10;
	public int total = 0;

	public Pagination(int c, int n) {
		cp = c;
		npp = n;
	}

	public int getPageNum() {
		return (total % npp == 0) ? total / npp : (total / npp + 1);
	}

	public int getStart() {
		return (cp - 1) * npp;
	}

	public int getEnd() {
		if (total < npp || cp == getStart())
			return total;
		else
			return cp * npp;
	}

	public boolean hasNext() {
		return cp < getPageNum();
	}

	public boolean hasPre() {
		return cp > 1 && getPageNum() > 1;
	}
}
