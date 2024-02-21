package com.altinity.demo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Hello world!
 *
 */
public class App {
    public static void main(String[] args) {
        System.out.println("Hello World!");
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://logos3:3306/test", "rhodges", "secret");
            Statement stmt = con.createStatement();
            System.out.println("Executing query");
            ResultSet rs = stmt.executeQuery("select 1");
            while (rs.next()) {
                System.out.println(rs.getString(1));
            }
            rs.close();

            // Insert a new product. 
            long product_id = -1;
            con.setAutoCommit(false);
            String insertProd = "INSERT INTO product(product_name, category_id, product_spec, base_price, start_date, end_date) VALUES ('Intel CPU', 2, 'Intel Core i5-12600K', '125.00', '2024-02-18 12:15:05', '2024-02-25 12:00');";
            try (PreparedStatement ps1 = con.prepareStatement(insertProd, Statement.RETURN_GENERATED_KEYS)) {
                int rows = ps1.executeUpdate();
                ResultSet keys = ps1.getGeneratedKeys();
                keys.next();
                product_id = keys.getLong(1);
                System.out.printf("Rows inserted: %d, product_id: %d\n", rows, product_id);
                con.commit();    
            } catch (SQLException e) {
                System.out.println(e);
                con.rollback();
                return;
            } 

            // Insert a couple of bids. 
            bid(con, product_id, 12, "130.00", "2024-02-19 08:29:55");
            bid(con, product_id, 10, "127.00", "2024-02-19 09:01:17");
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            if (con != null) {
                try {
                    System.out.println("Closing connection");
                    con.close();
                } catch (SQLException se) {
                }
            }
        }
    }

    public static void bid(Connection con, long product, long bidder, String price, String date) throws SQLException {
        con.setAutoCommit(false);
        String insertBids= "INSERT INTO product_bid(product_id, bidder_id, bid_price, bid_date) VALUE (?, ?, ?, ?);";
        try (PreparedStatement ps = con.prepareStatement(insertBids)) {
            ps.setLong(1, product);
            ps.setLong(2, bidder);
            ps.setString(3, price);
            ps.setString(4, date);
            int rows = ps.executeUpdate();
            con.commit();
            System.out.printf("Rows inserted: %d\n", rows);    
        } catch (SQLException e) {
            con.rollback();
            throw e;
        }
    }
}
