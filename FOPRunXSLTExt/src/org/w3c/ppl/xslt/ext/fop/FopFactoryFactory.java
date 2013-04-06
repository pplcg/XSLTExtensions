package org.w3c.ppl.xslt.ext.fop;

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
        try {
            Method newInstanceMethod = findFopFactoryCtorWithNoParams();
            if (newInstanceMethod != null) {
                return (FopFactory) newInstanceMethod.invoke(null);
            }
        } catch (IllegalAccessException ex) {
            Logger.getLogger(FopFactoryFactory.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalArgumentException ex) {
            Logger.getLogger(FopFactoryFactory.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvocationTargetException ex) {
            Logger.getLogger(FopFactoryFactory.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    private static Method findFopFactoryCtorWithNoParams() {
        try {
            return FopFactory.class.getMethod("newInstance", new Class[]{});
        } catch (NoSuchMethodException ex) {
            // NOOP
        } catch (SecurityException ex) {
            // NOOP
        }
        return null;
    }
}
