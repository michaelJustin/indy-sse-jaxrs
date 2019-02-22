package com.example;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Stock {
    
    private final String code;
    private final BigDecimal price;
    private final LocalDateTime dateTime;

    public Stock(String code, BigDecimal price, LocalDateTime dateTime) {
        this.code = code;
        this.price = price;
        this.dateTime = dateTime; 
    }
    
    public BigDecimal getPrice() {
        return price;
    }

    public LocalDateTime getDateTime() {
        return dateTime;
    }
  
    public String getCode() {
        return code;
    }
    
}
