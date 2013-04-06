package org.w3c.ppl.xslt.ext.fop.saxon;

import net.sf.saxon.dom.DocumentOverNodeInfo;
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Item;
import net.sf.saxon.om.SequenceIterator;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.tree.tiny.TinyDocumentImpl;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;
import net.sf.saxon.value.Value;
import org.w3c.dom.Document;
import org.w3c.ppl.xslt.ext.fop.RunFOP;

/**
 * @author arvedhs
 */
public class RunFOPSaxon extends ExtensionFunctionDefinition {

    @Override
    public StructuredQName getFunctionQName() {
        return new StructuredQName("runfop", "http://org.w3c.ppl.xslt/saxon-extension", "area-tree-url");
    }

    @Override
    public SequenceType[] getArgumentTypes() {
        return new SequenceType[]{SequenceType.SINGLE_NODE, SequenceType.SINGLE_STRING};
    }

    @Override
    public SequenceType getResultType(SequenceType[] sts) {
        return SequenceType.SINGLE_STRING;
    }

    @Override
    public ExtensionFunctionCall makeCallExpression() {
        return new ExtensionFunctionCall() {
            @Override
            public SequenceIterator<? extends Item> call(SequenceIterator<? extends Item>[] sis,
                    XPathContext xpc) throws XPathException {
                
                TinyDocumentImpl item = (TinyDocumentImpl) sis[0].next();
                Document foTree = (Document) DocumentOverNodeInfo.wrap(item);
                String ifName = ((StringValue) sis[1].next()).getStringValue();

                String result = null;
                try {
                    result = new RunFOP().executeFop(ifName, foTree);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    throw new XPathException(ex);
                }
                return Value.asIterator(StringValue.makeStringValue(result));
            }
        };
    }
}