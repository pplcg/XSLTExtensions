package org.w3c.ppl.xslt.ext.fop.xalan;

import org.w3c.dom.Node;
import org.w3c.ppl.xslt.ext.fop.RunFOP;

/**
 *
 * @author arvedhs
 */
public class RunFOPXalan {
    
    public static String areaTreeUrl(Node foTree, String ifName) throws Exception {
        return new RunFOP().executeFop(ifName, foTree);
    }
}
