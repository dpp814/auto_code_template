<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)};

import com.citycloud.ccuap.web.api.parameter.ICommand;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;

/**
 * 更新${tableDefine.cnname}数据命令
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
@ApiModel("更新${tableDefine.cnname}数据命令")
public class Update${tableDefine.id}Cmd implements ICommand {
    private static final long serialVersionUID = ${PubUtils.getRandomLong()}L;

<%
    columns.each{
          def colDataType=tableNameUtil.getDataType(it.columnType);

          println """    /** ${it.cnname} */"""
          if(it.getCanBeNull()) {
            println """    @ApiModelProperty(value = "${it.comment}")"""
          } else {
            println """    @ApiModelProperty(value = "${it.comment}", required = true)"""
          }
          if("String".equalsIgnoreCase(colDataType)) {
              println """    @NotBlank(message = "[9000,{${it.cnname}}]")"""
          } else if("java.util.Date".equalsIgnoreCase(colDataType) || "java.sql.Timestamp".equalsIgnoreCase(colDataType) || "Integer".equalsIgnoreCase(colDataType) ||  "Long".equalsIgnoreCase(colDataType) ||  "java.math.BigDecimal".equalsIgnoreCase(colDataType) ) {
              println """    @NotNull(message = "[9000,{${it.cnname}}]")"""
          } else {
              println """    @NotEmpty(message = "[9000,{${it.cnname}}]")"""
          }
          println """    private ${colDataType} ${it.dataName};"""
          println ""
    };
%>
}
