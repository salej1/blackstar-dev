/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.bloom.common.bean;

import org.apache.commons.lang3.StringUtils;

/**
 * Componente identificador de cat&aacute;logos.
 * @author oscar.martinez
 */
public class CatalogoBean <ID> implements Comparable<CatalogoBean<ID>> {

    private ID id;
    private String descripcion;
    private String extra;

    public String getExtra() {
		return extra;
	}

	public void setExtra(String extra) {
		this.extra = extra;
	}

	public CatalogoBean() {
        super();
    }

    public CatalogoBean(ID id) {
        this.id = id;
    }

    public CatalogoBean(ID id, String descripcion) {
        this.id = id;
        this.descripcion = descripcion;
    }

    @Override
    public int compareTo(CatalogoBean<ID> o) {

        if (o == null) {
            return 1;
        }

        if (StringUtils.isBlank(this.getDescripcion())) {
            if (StringUtils.isBlank(o.getDescripcion())) {
                return 0;
            }
            return -1;
        }
        if (StringUtils.isBlank(o.getDescripcion())) {
            return 1;
        }
        return this.getDescripcion().trim().compareToIgnoreCase(
                o.getDescripcion().trim());
    }

    @Override
    public String toString() {
        return String.format("ID: %s|Descripcion:%s", getId(),
                getDescripcion());
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 97 * hash + (this.id != null ? this.id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final CatalogoBean<ID> other = (CatalogoBean<ID>) obj;
        if (this.id != other.id && (this.id == null || !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    /**
     * Obtiene el identificador del cat&aacute;logo.
     * @return el identificador del cat&aacute;logo.
     */
    public ID getId() {
        return this.id;
    }

    /**
     * Obtiene la descripci&oacute;n del cat&aacute;logo.
     * @return la descripci&oacute;n del cat&aacute;logo.
     */
    public String getDescripcion() {
        return this.descripcion;
    }

    /**
     * Asigna el identificador del cat&aacute;logo.
     * @param id el identificador del cat&aacute;logo.
     */
    public void setId(ID id) {
        this.id = id;
    }

    /**
     * Asigna la descripci&oacute;n del cat&aacute;logo.
     * @param descripcion la descripci&oacute;n del cat&aacute;logo.
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
}
