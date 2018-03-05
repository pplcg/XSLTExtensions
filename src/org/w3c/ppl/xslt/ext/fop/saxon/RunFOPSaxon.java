package org.w3c.ppl.xslt.ext.fop.saxon;

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
import org.w3c.ppl.xslt.ext.fop.RunFOP;
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

/**
 * @author arvedhs
 */
public class RunFOPSaxon extends ExtensionFunctionDefinition {

    @Override
    public StructuredQName getFunctionQName() {
        return new StructuredQName("runfop", "http://org.w3c.ppl.xslt/saxon-extension", "area-tree");
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

                try {
                    isFo = new ByteArrayInputStream(QueryResult.serialize(item).getBytes("UTF-8"));
                    osAt = new ByteArrayOutputStream();

                    new RunFOP().executeFop(isFo, osAt);
                    StreamSource sAt = new StreamSource(new ByteArrayInputStream(osAt.toByteArray()));
                    return context.getConfiguration().buildDocument(sAt);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    throw new XPathException(ex);
                }
            }
        };
    }
}