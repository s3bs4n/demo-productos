package com.example.demo.repositorios;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.demo.clases.Producto;

public interface ProductoRepository extends JpaRepository<Producto, Long> {
}