package com.afishing.config;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@WebFilter(urlPatterns = "/*", asyncSupported = true)
public class HeaderFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        // 允许 iframe 嵌入
        httpResponse.setHeader("X-Frame-Options", "ALLOWALL");
        httpResponse.setHeader("Content-Security-Policy", "frame-ancestors *");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 销毁
    }
}
