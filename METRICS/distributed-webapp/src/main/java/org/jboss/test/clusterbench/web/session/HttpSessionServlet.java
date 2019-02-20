package org.jboss.test.clusterbench.web.session;

import javax.servlet.annotation.WebServlet;

@WebServlet(name = "HttpSessionServlet", urlPatterns = {"/session"})
public class HttpSessionServlet extends CommonHttpSessionServlet {
}
