/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.bloom.db.dao.mapper;

import com.bloom.common.bean.CatalogoBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

/**
 * Componente de mapeo JDBC para cat&aacute;logos.
 * @author oscar.martinez
 */
public class CatalogoMapper<ID> implements RowMapper<CatalogoBean<ID>> {

    /**
     * El nombre de la columna ID por defecto.
     */
    public static final String DEFAULT_COLUMNA_ID = "id";

    /**
     * El nombre de la columna descripci&oacute;n por defecto.
     */
    public static final String DEFAULT_COLUMNA_DESC = "desc";

    private String nombreColumnaId = DEFAULT_COLUMNA_ID;
    private String nombreColumnaDescripcion = DEFAULT_COLUMNA_DESC;
    private String nombreColumnaExtra = null;

    public CatalogoMapper() {
        super();
    }

    public CatalogoMapper(String nombreColumnaId,
            String nombreColumnaDescripcion) {
        this();
        this.nombreColumnaId = nombreColumnaId;
        this.nombreColumnaDescripcion = nombreColumnaDescripcion;
    }
    
    public CatalogoMapper(String nombreColumnaId,
            String nombreColumnaDescripcion, String nombreColumnaExtra) {
        this();
        this.nombreColumnaId = nombreColumnaId;
        this.nombreColumnaDescripcion = nombreColumnaDescripcion;
        this.nombreColumnaExtra = nombreColumnaExtra;
    }
    

    @Override
    public CatalogoBean<ID> mapRow(ResultSet rs, int i) throws SQLException {
        CatalogoBean<ID> cat = new CatalogoBean<ID>();
        cat.setId((ID) rs.getObject(nombreColumnaId));
        cat.setDescripcion(rs.getString(nombreColumnaDescripcion));
        
        if (nombreColumnaExtra != null){
        	cat.setExtra(rs.getString(nombreColumnaExtra));
        }
        
        return cat;
    }

    public String getNombreColumnaId() {
        return nombreColumnaId;
    }

    public void setNombreColumnaId(String nombreColumnaId) {
        this.nombreColumnaId = nombreColumnaId;
    }

    public String getNombreColumnaDescripcion() {
        return nombreColumnaDescripcion;
    }

    public void setNombreColumnaDescripcion(String nombreColumnaDescripcion) {
        this.nombreColumnaDescripcion = nombreColumnaDescripcion;
    }


}
