<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;

    def columnTypeList = columns.collect{it -> it.columnType};
    def dateTimeFlag = columnTypeList.contains("DATE") || columnTypeList.contains("DATETIME");
    def decimalFlag = columnTypeList.contains("DECIMAL");

    def bizFieldsMap=tableModel.bizFieldsMap;
    def searchDateList = columns.findAll{f -> "DATE,DATETIME,TIMESTAMP".contains(f.columnType) && bizFieldsMap.searchKey.contains(f.columnName) };
    def inList = columns.findAll{f -> "SELECT".equalsIgnoreCase(f.jspTag) };
%>

import lombok.Data;
import io.swagger.v3.oas.annotations.media.Schema;
import java.io.Serializable;
<% if(dateTimeFlag) { %>import java.util.Date;<% } %>
<% if(decimalFlag) { %>import java.math.BigDecimal;<% } %>

/**
 * ${tableDefine.cnname} 默认Query
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
@Schema(description = "${tableDefine.cnname} 默认Query")
public class ${tableDefine.id}ListQuery implements Serializable {
    private static final long serialVersionUID = 42L;

<%
    columns.each{
        def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
        println """    @Schema(description = "${it.comment}", type = "${colDataType}")"""
        println """    private ${colDataType} ${it.dataName};"""
        println ""
    };

    searchDateList.each{
        def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
        println """    @Schema(description = "${it.comment}_开始", type = "String")"""
        println """    private String ${it.dataName}Begin;"""
        println ""
        println """    @Schema(description = "${it.comment}_结束", type = "String")"""
        println """    private String ${it.dataName}End;"""
        println ""
    }

    inList.each{
        def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
        println """    @Schema(description = "${it.comment}列表", type = "List")"""
        println """    private List<${colDataType}> ${it.dataName}List;"""
        println ""
    }




%>
}