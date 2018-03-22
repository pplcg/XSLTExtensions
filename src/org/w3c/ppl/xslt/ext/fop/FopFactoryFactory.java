package org.w3c.ppl.xslt.ext.fop;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URI;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.fop.apps.FopFactory;

/**
 *
 * @author arvedhs
 */
class FopFactoryFactory {

    static FopFactory createFopFactory() {
        return FopFactory.newInstance(new File(".").toURI());
    }
}
