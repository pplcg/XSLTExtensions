package org.w3c.ppl.xslt.ext.ahf.saxon;

import javax.xml.transform.TransformerException;
import net.sf.saxon.Configuration;
import net.sf.saxon.lib.Initializer;

/**
 *
 * @author tgraham
 */
public class RunAHFExtInitializer implements Initializer {

    @Override
    public void initialize(Configuration c) throws TransformerException {
        c.registerExtensionFunction(new RunAHFSaxon());
    }
    
}
