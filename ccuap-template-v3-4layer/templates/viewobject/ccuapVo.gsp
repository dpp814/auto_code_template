<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.viewobject.${StringUtils.lowerCase(tableDefine.id)};

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import java.io.Serializable;
import java.util.Date;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * ${tableDefine.cnname}返回值对象
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
@ApiModel("${tableDefine.cnname}Vo")
public class ${tableDefine.id}Vo implements Serializable {
    private static final long serialVersionUID = ${PubUtils.getRandomLong()}L;

<%
    columns.each{
        def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
            println """    @ApiModelProperty(value = \"${it.comment}\")""";
        if("Long".equalsIgnoreCase(colDataType) || "java.math.BigDecimal".equalsIgnoreCase(colDataType)) {
            println """    @JsonSerialize(using = ToStringSerializer.class)"""
        }
        println """    private ${colDataType} ${it.dataName};"""
        println ""
    };
%>
}
