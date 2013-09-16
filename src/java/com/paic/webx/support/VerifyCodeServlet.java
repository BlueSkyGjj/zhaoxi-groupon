package com.paic.webx.support;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.GraphicsEnvironment;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriter;
import javax.imageio.plugins.jpeg.JPEGImageWriteParam;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VerifyCodeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static int imageWidth = 50;
	private static int imageHeight = 22;
	private static int fontSize = 18;
	private static int number = 4;

	private static int stepBg = 100;
	private static int stepTarget = 20;
	private static int colorBegin = 110;

	public static final String SESSION_KEY = "verify_code";

	private String getSvgSrcPre() {
		StringBuffer sb = new StringBuffer(
				"<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.0//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\">");
		sb.append("<svg width=\"");
		sb.append(imageWidth);
		sb.append("\" height=\"");
		sb.append(imageHeight);
		sb.append("\" xmlns=\"http://www.w3.org/2000/svg\">");
		sb.append("<text x=\"0\" y=\"");
		sb.append(imageHeight);
		sb.append("\" font-family=\"Arial\" font-size=\"");
		sb.append(imageHeight);
		sb.append("\" fill=\"black\">");

		return sb.toString();
	}

	private static final String SVG_SOURCE2 = "</text></svg>";

	private boolean svgMode = false;

	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			// width & height
			String w = req.getParameter("w");
			if (w != null)
				imageWidth = Integer.parseInt(w);
			String h = req.getParameter("h");
			if (h != null)
				imageHeight = Integer.parseInt(h);

			// font-size & number
			String s = req.getParameter("s");
			if (s != null)
				fontSize = Integer.parseInt(s);
			String n = req.getParameter("n");
			if (n != null)
				number = Integer.parseInt(n);

			// color parameters
			String paramBg = req.getParameter("stepBg");
			if (paramBg != null)
				stepBg = Integer.parseInt(paramBg);
			String paramTarget = req.getParameter("stepTarget");
			if (paramTarget != null)
				stepTarget = Integer.parseInt(paramTarget);
			String paramBegin = req.getParameter("colorBegin");
			if (paramBegin != null)
				colorBegin = Integer.parseInt(paramBegin);
		} catch (Exception e) {
			// skip
		}

		String vcode = sn2vcode();
		req.getSession().setAttribute(SESSION_KEY, vcode);

		if (svgMode)
			outSVG(vcode, resp);
		else
			outJPEG(vcode, resp);
	}

	private void outSVG(String vcode, HttpServletResponse resp)
			throws IOException {
		resp.setContentType("image/svg+xml");
		resp.getOutputStream().print(getSvgSrcPre() + vcode + SVG_SOURCE2);

	}

	private void outJPEG(String vcode, HttpServletResponse resp)
			throws IOException {
		resp.setContentType("image/jpeg");

		BufferedImage image = new BufferedImage(imageWidth, imageHeight,
				BufferedImage.TYPE_INT_RGB);

		Random random = new Random();
		Graphics g = image.getGraphics();
		g.setColor(new Color(stepBg + random.nextInt(colorBegin), stepBg
				+ random.nextInt(colorBegin), stepBg
				+ random.nextInt(colorBegin)));
		g.fillRect(0, 0, imageWidth, imageHeight);
		g.setFont(new Font("Times New Roman", Font.HANGING_BASELINE, fontSize));

		for (int i = 1; i <= number; i++) {
			String rand = vcode.substring(i - 1, i);
			g.setColor(new Color(stepTarget + random.nextInt(colorBegin),
					stepTarget + random.nextInt(colorBegin), stepTarget
							+ random.nextInt(colorBegin)));

			g.drawString(rand, 13 * (i - 1) + 0, 16);
		}

		ImageWriter writer = (ImageWriter) ImageIO.getImageWritersByFormatName(
				"jpeg").next();

		JPEGImageWriteParam params = new JPEGImageWriteParam(null);
		ImageOutputStream ios = ImageIO.createImageOutputStream(resp
				.getOutputStream());

		writer.setOutput(ios);
		writer.write(null, new IIOImage(image, null, null), params);

		writer.dispose();
		ios.close();
	}

	static String sn2vcode() {
		String sRand = "";
		Random random = new Random();
		for (int i = 0; i < number; i++) {
			String rand = String.valueOf(random.nextInt(10));
			sRand += rand;
		}
		return sRand;
	}

	public void init() throws ServletException {
		try {
			GraphicsEnvironment.getLocalGraphicsEnvironment();
		} catch (Throwable e) {
			// run under linux console?
			svgMode = true;
		}
	}
}