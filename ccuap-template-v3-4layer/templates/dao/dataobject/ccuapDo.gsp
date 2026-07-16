<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.dao.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * ${tableDefine.cnname}Do
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
@TableName("${tableDefine.dbTableName}")
public class ${tableDefine.id}Do {
<% if(pkColumn!=null) { %>
    @TableId
    private ${pkJavaType} ${pkColumn.dataName};
<% } %>
<%
    columns.each{
        if(!it.getIsPK()) {
            def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
            println """    /** ${it.comment} */""";
            println """    private ${colDataType} ${it.dataName};"""
            println ""
        }
    };
%>
}
