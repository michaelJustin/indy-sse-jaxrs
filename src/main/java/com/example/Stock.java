package com.example;

public class Stock {
    
    private String code;

    public Stock() {
        this.code = "abc äöü ÄÖÜ";
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
    
    
    
}
