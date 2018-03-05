package org.w3c.ppl.xslt.ext.ahf.xalan;

import jp.co.antenna.XfoJavaCtl.*;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import javax.xml.transform.TransformerFactory;
import java.io.StringWriter;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;


class ErrDump implements MessageListener {

	public void onMessage(int errLevel, int errCode, String errMessage) {
		System.out.println("ErrorLevel = " + errLevel + "\nErrorCode = " + errCode + "\n" + errMessage);
	}
}

/**
 * @author tgraham
 */
public class RunAHFXalan {

    public static Node areaTree(Node foTree) throws Exception {
	ByteArrayInputStream isFo = null;
	ByteArrayOutputStream osAt = null;
	XfoObj axfo = null;
	try {
	    isFo = new ByteArrayInputStream(nodeToString(foTree).getBytes());
	    osAt = new ByteArrayOutputStream();
                    
	    axfo = new XfoObj();
	    ErrDump eDump = new ErrDump();
	    axfo.setMessageListener(eDump);
	    axfo.setExitLevel(4);
	    // Just setting the printer name in render() fails with
	    // 'Unknown printer name:' message in AHF 6.1 MR3.
	    axfo.setPrinterName("@AreaTree");
	    axfo.render(isFo, osAt, "@AreaTree");
	    return DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new ByteArrayInputStream(osAt.toByteArray()));
	} catch (Exception ex) {
	    ex.printStackTrace();
	    throw new Exception(ex);
	}
	finally {
	    try {
		if (axfo != null)
		    axfo.releaseObjectEx();
	    } catch (XfoException e) {
		System.out.println("ErrorLevel = " + e.getErrorLevel() + "\nErrorCode = " + e.getErrorCode() + "\n" + e.getErrorMessage());
		return null;
	    }
	}
    }

    private static String nodeToString(Node node) {
        StringWriter sw = new StringWriter();
        try {
	    Transformer t = TransformerFactory.newInstance().newTransformer();
            t.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
            t.transform(new DOMSource(node), new StreamResult(sw));
        } catch (TransformerException te) {
            System.out.println("nodeToString Transformer Exception");
        }
        return sw.toString();
    }
}
