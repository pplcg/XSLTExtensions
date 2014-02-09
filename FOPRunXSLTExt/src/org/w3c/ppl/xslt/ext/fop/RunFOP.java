package org.w3c.ppl.xslt.ext.fop;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
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

    public void executeFop(InputStream isFo, OutputStream osAt)
            throws Exception {

        FopFactory fopFactory = FopFactoryFactory.createFopFactory();
        if (fopFactory == null) {
            throw new Exception("Cannot create FopFactory");
        }
        Fop fop = fopFactory.newFop(MimeConstants.MIME_FOP_AREA_TREE, osAt);
        TransformerFactory tf = new TransformerFactoryImpl();
        Transformer transformer = tf.newTransformer();
	Source src = new StreamSource(isFo);
        Result res = new SAXResult(fop.getDefaultHandler());
	transformer.transform(src, res);
    }

    public Node executeFop(Node foTree)
            throws Exception {

        FopFactory fopFactory = FopFactoryFactory.createFopFactory();
        if (fopFactory == null) {
            throw new Exception("Cannot create FopFactory");
        }
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Fop fop = fopFactory.newFop(MimeConstants.MIME_FOP_AREA_TREE, out);
        TransformerFactory tf = new TransformerFactoryImpl();
        Transformer transformer = tf.newTransformer();
        Source src = new DOMSource(foTree);
        Result res = new SAXResult(fop.getDefaultHandler());
        transformer.transform(src, res);
        return DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new ByteArrayInputStream(out.toByteArray()));
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
