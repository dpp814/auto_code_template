<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)};

import com.citycloud.ccuap.web.api.parameter.ICommand;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

/**
 * 删除${tableDefine.cnname}数据命令
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
@ApiModel("删除${tableDefine.cnname}数据命令")
public class Delete${tableDefine.id}Cmd implements ICommand {
    private static final long serialVersionUID = ${PubUtils.getRandomLong()}L;

<%
    if(pkColumn!=null) {
      println """    /** ${pkColumn.cnname} */"""
      println """    @ApiModelProperty(value = "${pkColumn.comment}", required = true)"""

      if("String".equalsIgnoreCase(pkJavaType)) {
          println """    @NotBlank(message = "[9000,{${pkColumn.cnname}}]")"""
      } else if("java.util.Date".equalsIgnoreCase(pkJavaType) || "java.sql.Timestamp".equalsIgnoreCase(pkJavaType) || "Integer".equalsIgnoreCase(pkJavaType) ||  "Long".equalsIgnoreCase(pkJavaType) ||  "java.math.BigDecimal".equalsIgnoreCase(pkJavaType) ) {
          println """    @NotNull(message = "[9000,{${pkColumn.cnname}}]")"""
      } else {
          println """    @NotEmpty(message = "[9000,{${pkColumn.cnname}}]")"""
      }
      println """    private ${pkJavaType} ${pkColumn.dataName};"""
      println ""
    }
%>
}
