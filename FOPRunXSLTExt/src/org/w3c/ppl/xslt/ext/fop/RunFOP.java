package org.w3c.ppl.xslt.ext.fop;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.net.URI;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.sax.SAXResult;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.apache.xalan.processor.TransformerFactoryImpl;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

/**
 *
 * @author arvedhs
 */
public class RunFOP {

    public String executeFop(String ifName, Document foTree)
            throws Exception {

        FopFactory fopFactory = FopFactoryFactory.createFopFactory();
        if (fopFactory == null) {
            throw new Exception("Cannot create FopFactory");
        }
        OutputStream out = new BufferedOutputStream(new FileOutputStream(new File(ifName)));
        Fop fop = fopFactory.newFop(MimeConstants.MIME_FOP_AREA_TREE, out);
        TransformerFactory tf = new TransformerFactoryImpl();
        Transformer transformer = tf.newTransformer();
        Source src = new DOMSource(foTree);
        Result res = new SAXResult(fop.getDefaultHandler());
        transformer.transform(src, res);
        return ifName;
    }

    public String executeFop(String ifName, Node foTree)
            throws Exception {

        FopFactory fopFactory = FopFactoryFactory.createFopFactory();
        if (fopFactory == null) {
            throw new Exception("Cannot create FopFactory");
        }
        OutputStream out = new BufferedOutputStream(new FileOutputStream(new File(ifName)));
        Fop fop = fopFactory.newFop(MimeConstants.MIME_FOP_AREA_TREE, out);
        TransformerFactory tf = new TransformerFactoryImpl();
        Transformer transformer = tf.newTransformer();
        Source src = new DOMSource(foTree);
        Result res = new SAXResult(fop.getDefaultHandler());
        transformer.transform(src, res);
        return ifName;
    }
}
