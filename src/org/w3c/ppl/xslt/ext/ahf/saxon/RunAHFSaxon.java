package org.w3c.ppl.xslt.ext.ahf.saxon;

import jp.co.antenna.XfoJavaCtl.*;
import net.sf.saxon.dom.DocumentOverNodeInfo;
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Item;
import net.sf.saxon.om.NodeInfo;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.SequenceIterator;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.query.QueryResult;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.tree.tiny.TinyDocumentImpl;
import net.sf.saxon.value.AtomicValue;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.SingletonItem;
import net.sf.saxon.value.StringValue;
import net.sf.saxon.value.ObjectValue;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import javax.xml.transform.TransformerFactory;
import java.io.StringWriter;
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
public class RunAHFSaxon extends ExtensionFunctionDefinition {

    @Override
    public StructuredQName getFunctionQName() {
        return new StructuredQName("runahf", "http://org.w3c.ppl.xslt/saxon-extension", "area-tree");
    }

    @Override
    public SequenceType[] getArgumentTypes() {
        return new SequenceType[]{SequenceType.SINGLE_NODE};
    }

    @Override
    public SequenceType getResultType(SequenceType[] sts) {
        return SequenceType.SINGLE_NODE;
    }

    @Override
    public ExtensionFunctionCall makeCallExpression() {
        return new ExtensionFunctionCall() {
            @Override
            public Sequence call(XPathContext context, Sequence[] arguments) throws XPathException {
                
                NodeInfo item = (NodeInfo)arguments[0].head();
                ByteArrayInputStream isFo = null;
                ByteArrayOutputStream osAt = null;
                XfoObj axfo = null;
                try {
                    isFo = new ByteArrayInputStream(QueryResult.serialize(item).getBytes("UTF-8"));
                    osAt = new ByteArrayOutputStream();
                    
                    axfo = new XfoObj();
                    ErrDump eDump = new ErrDump();
                    axfo.setMessageListener(eDump);
                    axfo.setExitLevel(4);
                    // Just setting the printer name in render() fails with
                    // 'Unknown printer name:' message in AHF 6.1 MR3.
                    axfo.setPrinterName("@AreaTree");
                    axfo.render(isFo, osAt, "@AreaTree");
                    StreamSource sAt = new StreamSource(new ByteArrayInputStream(osAt.toByteArray()));
                    return context.getConfiguration().buildDocument(sAt);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    throw new XPathException(ex);
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
        };
    }
}