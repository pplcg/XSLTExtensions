package org.w3c.ppl.xslt.ext.fop.saxon;

import javax.xml.transform.TransformerException;
import net.sf.saxon.Configuration;
import net.sf.saxon.lib.Initializer;

/**
 *
 * @author arvedhs
 */
public class RunFOPExtInitializer implements Initializer {

    @Override
    public void initialize(Configuration c) throws TransformerException {
        c.registerExtensionFunction(new RunFOPSaxon());
    }
    
}
