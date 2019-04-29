package org.jboss.test.clusterbench.web.session;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.logging.Logger;

@WebFilter(filterName = "sessionCheckerFilter")
public class SessionCheckerFilter implements Filter {
    protected static final Logger log = Logger.getLogger(SessionCheckerFilter.class.getName());
    private FilterConfig config = null;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.config = config;
        log.info("Initializing SessionCheckerFilter");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        if (httpServletRequest.getUserPrincipal() != null ) {
            log.info("USER PRICIPAL: " + httpServletRequest.getUserPrincipal().getName());
            log.info("User: " + httpServletRequest.isUserInRole("User"));
            log.info("users: " + httpServletRequest.isUserInRole("users"));
        } else {
            log.info("USER PRICIPAL IS null");
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
