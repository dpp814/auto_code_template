<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;
import java.util.List;
import java.io.Serializable;

/**
 * ${tableDefine.cnname} 实体bean
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
@TableName("${tableDefine.dbTableName}")
public class ${tableDefine.id}Entity implements Serializable{

  private static final long serialVersionUID = ${PubUtils.getRandomLong()}L;

<% if(pkColumn!=null) { %>
    @TableId(value = "${pkColumn.columnName}", type = IdType.AUTO)
    private ${pkJavaType} ${pkColumn.dataName};
<% } %>
<%
    columns.each{
        if(!it.getIsPK()) {
            println """	/**  ${it.cnname}  */""";
            println """ @TableField(value="${it.columnName}")""";
            println """	private ${tableNameUtil.getDataType(it.columnType)} ${it.dataName};"""
            println """ \r""";
        }
    };
%>
}
