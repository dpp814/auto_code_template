<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);

    def columnTypeList = columns.collect{it -> it.columnType};
    def dateTimeFlag = columnTypeList.contains("DATE") || columnTypeList.contains("DATETIME");
    def decimalFlag = columnTypeList.contains("DECIMAL");
%>

import lombok.Data;
import io.swagger.v3.oas.annotations.media.Schema;
import java.io.Serializable;
import org.hibernate.validator.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.NotEmpty;
<% if(dateTimeFlag) { %>import java.util.Date;<% } %>
<% if(decimalFlag) { %>import java.math.BigDecimal;<% } %>

/**
 * ${tableDefine.cnname} 默认CreateDTO
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
@Schema(description = "${tableDefine.cnname} 默认CreateDTO")
public class ${tableDefine.id}CreateDTO implements Serializable {
    private static final long serialVersionUID = 42L;

<%
    columns.each{
        def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
        if(!it.getCanBeNull() && !"createdBy,createdAt,".contains(it.dataName) && !it.getIsPK()) {
            if("String".equalsIgnoreCase(colDataType)) {
                println """    @NotBlank(message = "${it.cnname}不能为空")"""
            } else {
                println """    @NotNull(message = "${it.cnname}不能为空")"""
            }
        }
        if("createdBy,createdAt,updatedBy,updatedAt,removed,".contains(it.dataName)){
            println """    @Schema(description = "${it.comment}", type = "${colDataType}", hidden = true)"""
        }else{
            println """    @Schema(description = "${it.comment}", type = "${colDataType}")"""
        }
        println """    private ${colDataType} ${it.dataName};"""
        println ""
    };
%>
}
