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
import com.bihu.cbs.model.base.BaseModel;
import io.swagger.v3.oas.annotations.media.Schema;
<% if(dateTimeFlag) { %>import java.util.Date;<% } %>
<% if(decimalFlag) { %>import java.math.BigDecimal;<% } %>

/**
 * ${tableDefine.cnname} 模型
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
public class ${tableDefine.id} extends BaseModel {
    private static final long serialVersionUID = 42L;

<%
    columns.each{
        if(!"createdBy,createdAt,updatedBy,updatedAt,removed,".contains(it.dataName)){
            def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
            println """    @Schema(description = "${it.comment}", type = "${colDataType}")"""
            println """    private ${colDataType} ${it.dataName};"""
            println ""
        }
    };
%>
}
