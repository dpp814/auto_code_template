<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.query.${StringUtils.lowerCase(tableDefine.id)};

import com.citycloud.ccuap.web.api.parameter.IQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

/**
 * ${tableDefine.cnname}分页查询参数
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
@ApiModel("${tableDefine.cnname}分页查询参数")
public class ${tableDefine.id}ListQuery implements IQuery {
    private static final long serialVersionUID = ${PubUtils.getRandomLong()}L;

    @ApiModelProperty(value = "当前页", required = true)
    @Min(value = 1, message = "[9004,{当前页},{1}]")
    @NotNull(message = "[9000,{分页pageNum}]")
    private Integer pageNum;

    @ApiModelProperty(value = "每页记录数", required = true)
    @Min(value = 1, message = "[9004,{每页记录数},{1}]")
    @NotNull(message = "[9000,{分页pageSize}]")
    private Integer pageSize;

<%
    columns.each{
        if(!it.getIsPK()) {
            def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
            println """    /** ${it.cnname} */"""
            if(it.getCanBeNull()) {
                println """    @ApiModelProperty(value = "${it.comment}")"""
            } else {
                println """    @ApiModelProperty(value = "${it.comment}", required = true)"""
                if("String".equalsIgnoreCase(colDataType)) {
                    println """    @NotBlank(message = "[9000,{${it.cnname}}]")"""
                } else if("java.util.Date".equalsIgnoreCase(colDataType) || "Timestamp".equalsIgnoreCase(colDataType) || "Integer".equalsIgnoreCase(colDataType) ||  "Long".equalsIgnoreCase(colDataType) ||  "java.math.BigDecimal".equalsIgnoreCase(colDataType) ) {
                    println """    @NotNull(message = "[9000,{${it.cnname}}]")"""
                } else {
                    println """    @NotEmpty(message = "[9000,{${it.cnname}}]")"""
                }
            }
            println """    private ${colDataType} ${it.dataName};"""
            println ""
        }
    };
%>
}
