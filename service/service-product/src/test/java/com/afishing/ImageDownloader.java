package com.afishing;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.*;
import java.util.UUID;

/**
 * 图片下载工具 - 独立运行
 * 将数据库中所有线上图片下载到本地，并更新数据库
 */
public class ImageDownloader {

    // 数据库配置
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fish_commerce?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "wsp0222.";

    // 文件保存路径
    private static final String UPLOAD_PATH = "uploads/";
    private static final String ACCESS_URL = "/uploads/";

    public static void main(String[] args) {
        System.out.println("========== 开始下载商品图片 ==========");

        // 创建上传目录
        Path uploadDir = Paths.get(UPLOAD_PATH).toAbsolutePath().normalize();
        try {
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
                System.out.println("创建上传目录: " + uploadDir);
            }
        } catch (IOException e) {
            System.err.println("创建目录失败: " + e.getMessage());
            return;
        }

        // 连接数据库
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            System.out.println("数据库连接成功");

            // 查询所有有图片的商品
            String querySql = "SELECT id, name, main_image FROM product WHERE main_image IS NOT NULL AND main_image != ''";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(querySql);

            int total = 0;
            int success = 0;
            int fail = 0;
            int skip = 0;

            while (rs.next()) {
                total++;
                Long id = rs.getLong("id");
                String name = rs.getString("name");
                String imageUrl = rs.getString("main_image");

                System.out.println("\n处理商品 [" + name + "]");
                System.out.println("原图片URL: " + imageUrl);

                // 跳过已经是本地的图片
                if (imageUrl.startsWith("/uploads/")) {
                    System.out.println("已是本地图片，跳过");
                    skip++;
                    continue;
                }

                // 下载图片
                String newUrl = downloadImage(imageUrl, uploadDir);

                if (!newUrl.equals(imageUrl)) {
                    // 更新数据库
                    String updateSql = "UPDATE product SET main_image = ? WHERE id = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                        pstmt.setString(1, newUrl);
                        pstmt.setLong(2, id);
                        pstmt.executeUpdate();
                        System.out.println("✓ 更新成功: " + newUrl);
                        success++;
                    }
                } else {
                    System.out.println("✗ 下载失败，保留原URL");
                    fail++;
                }

                // 延迟，避免请求过快
                Thread.sleep(200);
            }

            System.out.println("\n========== 下载完成 ==========");
            System.out.println("总计: " + total);
            System.out.println("成功: " + success);
            System.out.println("失败: " + fail);
            System.out.println("跳过: " + skip);

        } catch (Exception e) {
            System.err.println("执行失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 下载图片到本地
     */
    private static String downloadImage(String imageUrl, Path uploadDir) {
        if (imageUrl == null || imageUrl.isEmpty()) {
            return imageUrl;
        }

        HttpURLConnection connection = null;
        InputStream inputStream = null;
        FileOutputStream outputStream = null;

        try {
            // 生成文件名
            String extension = getExtensionFromUrl(imageUrl);
            String filename = UUID.randomUUID().toString() + extension;
            Path targetPath = uploadDir.resolve(filename);

            // 下载图片
            URL url = new URL(imageUrl);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(30000);
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");

            int responseCode = connection.getResponseCode();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                System.err.println("HTTP错误: " + responseCode);
                return imageUrl;
            }

            inputStream = connection.getInputStream();
            outputStream = new FileOutputStream(targetPath.toFile());

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

            String localUrl = ACCESS_URL + filename;
            System.out.println("下载成功: " + targetPath);
            return localUrl;

        } catch (Exception e) {
            System.err.println("下载失败: " + e.getMessage());
            return imageUrl;
        } finally {
            try {
                if (outputStream != null) outputStream.close();
                if (inputStream != null) inputStream.close();
                if (connection != null) connection.disconnect();
            } catch (IOException e) {
                // ignore
            }
        }
    }

    /**
     * 从URL获取文件扩展名
     */
    private static String getExtensionFromUrl(String url) {
        if (url == null || url.isEmpty()) {
            return ".jpg";
        }

        String cleanUrl = url.split("\\?")[0];
        int lastDotIndex = cleanUrl.lastIndexOf(".");
        int lastSlashIndex = cleanUrl.lastIndexOf("/");

        if (lastDotIndex > lastSlashIndex && lastDotIndex != -1) {
            String ext = cleanUrl.substring(lastDotIndex).toLowerCase();
            if (ext.matches("\\.(jpg|jpeg|png|gif|webp|bmp)")) {
                return ext;
            }
        }

        return ".jpg";
    }
}
